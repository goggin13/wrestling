namespace :staging do

  desc "Add default users"
  task users: :environment do
    User.destroy_all

    User.create!(
      :email => "goggin13@gmail.com",
      :password => "password",
      :password_confirmation => "password",
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
      "person1@gmail.com",
      "person2@gmail.com"
    ].each do |email|
      password = SecureRandom.hex(8)
      User.create!(
        :email => email,
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
    User.update(balance: 100)
    Tournament.last.matches.each do |match|
      match.update_columns(closed: false, home_score: nil, away_score: nil)
      User.all.each do |user|
        wager = ["home", "away"].shuffle.first
        amount = (1..10).to_a.shuffle.first
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
          puts "Created #{bet.title} : #{user.reload.balance}"
        else
          bet.errors.each do |field, message|
            puts("Failed to save bet: #{field}-#{message}")
          end
          raise "failed to save bet"
        end
      end
    end
  end

  desc "Setup Tournament"
  task tournament: :environment do
    tournament = Tournament.find_or_create_by(name: "Dake vs. Chamizo")

    wrestlers = [
      {
        name: "Kyle Dake",
        college: "Cornell",
        college_year: 2013,
        bio: "2x World Champion\n4x NCAA Champion\n2020 Olympic Team Trials Qualifier"
      },
      {
        name: "Frank Chamizo",
        bio: "2x World Champion\nWorld runner-up\nWorld bronze\nOlympic Bronze Medalist"
      },
      {
        name: "Darrion Caldwell",
        college: "North Carolina State University",
        college_year: 2009,
        bio: "NCAA Champion\nCurrent Bellator MMA Fighter"
      },
      {
        name: "Luke Pletcher",
        college: "Ohio State University",
        college_year: 2020,
        bio: "2x NCAA All-American\n1st seed @ cancelled 2020 NCAAs\nCoach @ University of Pittsburgh"
      },
      {
        name: "Jack Mueller",
        college: "University of Virginia",
        college_year: 2020,
        bio: "2x NCAA All American\n4 seed @ cancelled 2020 NCAAs",
      },
      {
        name: "Roman Bravo Young",
        college: "Penn State University",
        college_year: 2022,
        bio: "NCAA all american as a true freshman\n5 seed @ cancelled 2020 NCAAs",
      },
      {
        name: "Vito Arujau",
        college: "Cornell",
        college_year: 2023,
        bio: "33-4, 4th @ NCAA as true freshman\nRedshirt 2020 season to train for Olympics\n2020 Olympic Team Trials Qualifier",
      },
      {
        name: "Sammy Alvarez",
        college: "Rutgers",
        college_year: 2024,
        bio: "10th seed @ cancelled 2020 NCAAs",
      },
      {
        name: "David Taylor",
        college: "Penn State University",
        college_year: 2014,
        bio: "World Champion\n2x NCAA champion, 2x runner-up\n2020 Olympic Team Trials Qualifier",
      },
      {
        name: "Myles Martin",
        college: "Ohio State University",
        college_year: 2019,
        bio: "NCAA Champion\n4x NCAA all-american\n2020 Olympic Team Trials Qualifier",
      }
    ]

    wrestlers.each do |w|
      if Wrestler.where(name: w[:name]).count == 0
        if w.has_key?(:college)
          w[:college] = College.find_or_create_by!(name: w[:college])
        end
        Wrestler.create!(w)
      end
    end

    matches = [
      ["Kyle Dake", "Frank Chamizo"],
      ["Darrion Caldwell", "Luke Pletcher"],
      ["Jack Mueller", "Roman Bravo Young"],
      ["Vito Arujau", "Sammy Alvarez"],
      ["David Taylor", "Myles Martin"]
    ]

    tournament.matches.destroy_all
    weights = [125, 133, 141, 149, 157, 165, 174]
    i = 0
    matches.each do |home, away|
      home_wrestler = Wrestler.where(name: home).first!
      away_wrestler = Wrestler.where(name: away).first!
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

    tournament.update!(current_match_id: nil)
  end
end
