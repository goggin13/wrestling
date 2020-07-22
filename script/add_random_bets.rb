Bet.destroy_all

Tournament.first.matches.each do |match|
  User.all.each do |user|
    wager = [true, false].shuffle.first ? "home" : "away"
    Bet.create!(user: user, match: match, wager: wager)
    puts "#{user.email} betting #{wager} for #{match.title}"
  end
end
