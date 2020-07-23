tournament = Tournament.find_or_create_by(name: "Dake vs. Chamizo")
"https://www.flowrestling.org/articles/6751151-kyle-dake-vs-frank-chamizo-headline-epic-july-25th-card"

# Wrestler.destroy_all
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
  puts w
  puts w[:name]
  puts Wrestler.where(name: w[:name]).count
  if Wrestler.where(name: w[:name]).count == 0
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
matches.each do |home, away|
  puts home, away
  home_wrestler = Wrestler.where(name: home).first!
  away_wrestler = Wrestler.where(name: away).first!
  Match.create!(
    tournament: tournament,
    home_wrestler: home_wrestler,
    away_wrestler: away_wrestler,
  )
end
