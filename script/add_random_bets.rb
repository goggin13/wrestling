Bet.destroy_all
Tournament.last.matches.each do |match|
  User.all.each do |user|
    wager = [true, false].shuffle.first ? "home" : "away"
    if [0,1].shuffle[0] == 0
      wager = "home"
    else
      wager = "away"
    end
    Bet.create!(user: user, match: match, wager: wager, over_under: Bet::OVER)
    puts "#{user.email} betting #{wager} for #{match.title}"
  end
end
