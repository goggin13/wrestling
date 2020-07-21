User.create!({:email => "goggin13@gmail.com", :password => "111111", :password_confirmation => "111111" })
[
  ["patsqueglia@gmail.com", "Patrick"],
  ["rudolphocisneros@gmail.com", "JR"],
  ["livcarrington@gmail.com", "Olivia"],
  ["klynch425@gmail.com", "Kelly"],
  ["danstipanuk@gmail.com", "DeezNuts"],
  ["lucaslemanski2@gmail.com", "Lucas"],
].each do |email, username|
  User.create!({:email => email, :password => "111111", :password_confirmation => "111111" })
end
