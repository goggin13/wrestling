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
      "erinumhoefer@gmail.com"
    ].each do |email|
      password = SecureRandom.hex(8)
      User.create!(
        :email => email,
        :password => password,
        :password_confirmation => password,
        :balance => 1000
      )
    end

    puts "Added #{User.count} users"
  end

  desc "TODO"
  task bets: :environment do
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
