namespace :staging do

  desc "Add default users"
  task users: :environment do
    User.destroy_all

    User.create!(
      :email => "goggin13@gmail.com",
      :display_name => "goggin13",
      :password => "password",
      :password_confirmation => "password",
      :balance => 10,
    )

    [
      "patsqueglia@gmail.com",
      "rudolphocisneros@gmail.com",
      "livcarrington@gmail.com",
      "klynch425@gmail.com",
      "danstipanuk@gmail.com",
      "lucaslemanski2@gmail.com",
      "choy.ash831@gmail.com",
      "cookediana@gmail.com",
      "erinumhoefer@gmail.com",
      "emsitterley@gmail.com",
      "person1@gmail.com",
      "person2@gmail.com"
    ].each do |email|
      password = SecureRandom.hex(8)
      User.create!(
        :email => email,
        :display_name => email.split("@")[0],
        :password => password,
        :password_confirmation => password,
        :balance => 100
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
    tournament = Tournament.find_or_create_by(name: "2023 NCAA")
    cornell = College.find_or_create_by!(name: "Cornell")

    wrestler_data = {
      college: cornell,
      college_year: 2023,
      bio: "33-4, 4th @ NCAA as true freshman\nRedshirt 2020 season to train for Olympics\n2020 Olympic Team Trials Qualifier",
    }

    matches = [
      ["Spencer Lee", "Pat Glory"],
      ["Roman Bravo-Young", "Daton Fix"],
      ["Real Woods", "Andrew Alirez"],
      ["Yianni Diakomihalis", "Sammy Sasso"],
      ["Austin O`Connor", "Levi Haines"],
      ["David Carr", "Keegan O`Toole"],
      ["Carter Starocci", "Mikey Labriola"],
      ["Parker Keckeisen", "Aaron Brooks"],
      ["Nino Bonaccorsi", "Rocky Elam"],
      ["Mason Parris", "Greg Kerkvliet"],
    ]

    tournament.matches.destroy_all
    weights = [125, 133, 141, 149, 157, 165, 174, 184, 197, 285]
    i = 0
    matches.each do |home, away|
      home_wrestler = Wrestler.find_or_create_by!(wrestler_data.merge(name: home))
      away_wrestler = Wrestler.find_or_create_by!(wrestler_data.merge(name: away))
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
