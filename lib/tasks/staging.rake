namespace :staging do

  desc "Add default users"
  task users: :environment do
    User.destroy_all

    User.create!(
      :email => "goggin13@gmail.com",
      :display_name => "goggin13",
      :password => "password",
      :password_confirmation => "password",
      :balance => 100,
    )

    [
      "rudolphocisneros@gmail.com",
      "klynch425@gmail.com",
      "lucaslemanski2@gmail.com",
      "choy.ash831@gmail.com",
      "erinumhoefer@gmail.com",
      "emsitterley@gmail.com",
      "katepotteiger@gmail.com",
      "seg12@cornell.edu"
    ].each do |email|
      password = SecureRandom.hex(8)
      User.create!(
        :email => email,
        :display_name => email.split("@")[0],
        :password => password,
        :password_confirmation => password,
        :balance => 100,
      )
    end

    puts "Added #{User.count} users"
  end

  desc "Add random bets"
  task bets: :environment do
    Bet.destroy_all
    User.update(balance: 10)
    Tournament.current.matches.each do |match|
      match.update_columns(closed: false, home_score: nil, away_score: nil)
      User.all.each do |user|
        wager = ["home", "away"].shuffle.first
        amount = (1..10).to_a.shuffle.first
        amount = 10
        bet = nil
        i = [0,1,2].shuffle.first
        if i == 0
          bet = MoneyLineBet.new(user: user, match: match, amount: amount, wager: wager)
        elsif i == 1
          bet = SpreadBet.new(user: user, match: match, amount: amount, wager: wager)
        elsif i == 2
          wager = wager == "away" ? "over" : "under"
          bet = OverUnderBet.new(user: user, match: match, amount: amount, wager: wager)
        end

        bet = Bet.save_and_charge_user(bet)
        if bet.id.present?
          puts "#{user.display_name} - #{bet.title}"
        else
          bet.errors.each do |field, message|
            puts("Failed to save bet: #{field}-#{message}")
          end
          raise "failed to save bet"
        end
      end
    end
  end

  desc "Add random pickem bets"
  task pickem_bets: :environment do
    Bet.destroy_all
    User.update(balance: 100)
    Tournament.current.matches.each do |match|
      match.update_columns(closed: false, home_score: nil, away_score: nil)
      User.all.each do |user|
        wager = ["home", "away"].shuffle.first
        amount = 1
        bet = PickemBet.new(user: user, match: match, amount: amount, wager: wager)
        bet = PickemBet.save_and_delete_others(bet)
        if bet.id.present?
          puts "#{user.display_name} - #{bet.title}"
        else
          bet.errors.each do |field, message|
            puts("Failed to save bet: #{field}-#{message}")
          end
          raise "failed to save bet"
        end
      end
    end
  end


  desc "roll users money to next bet"
  task roll_forward: :environment do
    match = Tournament.current.matches.where(closed: :false).order("weight ASC").first!
    puts "Next Match: #{match.title}"
    User.all.each do |user|
      puts "#{user.display_name}: #{user.formatted_balance}"
      next if user.balance == 0

      wager = ["home", "away"].shuffle.first
      bet = nil
      i = [0,1,2].shuffle.first
      if i == 0
        bet = MoneyLineBet.new(user: user, match: match, wager: wager)
      elsif i == 1
        bet = SpreadBet.new(user: user, match: match, wager: wager)
      elsif i == 2
        wager = wager == "away" ? "over" : "under"
        bet = OverUnderBet.new(user: user, match: match, wager: wager)
      end

      if (existing_bet = Bet.where(match: match, user: user, type: bet.class.name).first).present?
        puts "\trm #{existing_bet.title}"
        Bet.delete_and_refund_user(existing_bet)
      end

      bet.user.reload
      bet.amount = bet.user.balance

      bet = Bet.save_and_charge_user(bet)
      if bet.id.present?
        puts "\t#{bet.title}"
      else
        bet.errors.each do |field, message|
          puts("Failed to save bet: #{field}-#{message}")
        end
        raise "failed to save bet"
      end
    end
  end

  desc "Setup Tournament"
  task tournament: :environment do
    Tournament.destroy_all
    Match.destroy_all
    Bet.destroy_all
    Wrestler.destroy_all
    tournament = Tournament.find_or_create_by(name: "2023 NCAA")

    matches = [
      [
        {name: "Spencer Lee", college: "University of Iowa"},
        {name: "Pat Glory", college: "Princeton"},
      ],
      [
        {name: "Roman Bravo-Young", college: "Penn State"},
        {name: "Daton Fix", college: "University of Oklahoma"},
      ],
      [
        {name: "Real Woods", college: "University of Iowa"},
        {name: "Andrew Alirez", college: "University of Northern Colorado"},
      ],
      [
        {name: "Yianni Diakomihalis", college: "Cornell"},
        {name: "Sammy Sasso", college: "Ohio State"},
      ],
      [
        {name: "Austin O`Connor", college: "University of North Carolina"},
        {name: "Levi Haines", college: "Penn State"},
      ],
      [
        {name: "David Carr", college: "Iowa State"},
        {name: "Keegan O`Toole", college: "Missouri"},
      ],
      [
        {name: "Carter Starocci", college: "Penn State"},
        {name: "Mikey Labriola", college: "Nebraska"},
      ],
      [
        {name: "Parker Keckeisen", college: "University of Northern Iowa"},
        {name: "Aaron Brooks", college: "Penn State"},
      ],
      [
        {name: "Nino Bonaccorsi", college: "Pittsburgh"},
        {name: "Rocky Elam", college: "Missouri"},
      ],
      [
        {name: "Mason Parris", college: "Michigan"},
        {name: "Greg Kerkvliet", college: "Penn State"},
      ],
    ]

    tournament.matches.destroy_all
    weights = [125, 133, 141, 149, 157, 165, 174, 184, 197, 285]
    i = 0
    matches.each do |home, away|
      home_college = College.find_or_create_by!(name: home[:college])
      home[:college] = home_college
      away_college = College.find_or_create_by!(name: away[:college])
      away[:college] = away_college

      home_wrestler = Wrestler.find_or_create_by!(home)
      away_wrestler = Wrestler.find_or_create_by!(away)

      Match.create!(
        tournament: tournament,
        home_wrestler: home_wrestler,
        away_wrestler: away_wrestler,
        weight: weights[i],
        spread: (-10..10).to_a.shuffle.first,
        over_under: (5..30).to_a.shuffle.first
      )
      i += 1
    end

    tournament.update!(current_match_id: nil, in_session: true)
  end
end
