i = 0
Tournament.last.matches.each do |match|
  match.bets.destroy_all
  User.all.each do |user|
    next if user.email == "patsqueglia@gmail.com"
    wager = [true, false].shuffle.first ? "home" : "away"
    if i == 0
      wager = "home"
    elsif i == 1
      wager = "away"
    end
    Bet.create!(user: user, match: match, wager: wager)
    puts "#{user.email} betting #{wager} for #{match.title}"
  end
  i += 1
end
