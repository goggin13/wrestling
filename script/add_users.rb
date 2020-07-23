User.create!({:email => "goggin13@gmail.com", :password => "111111", :password_confirmation => "111111" })
[
  "patsqueglia@gmail.com",
  "rudolphocisneros@gmail.com",
  "livcarrington@gmail.com",
  "klynch425@gmail.com",
  "danstipanuk@gmail.com",
  "lucaslemanski2@gmail.com",
  "meganbfallon@gmail.com",

].each do |email|
  User.create!({:email => email, :password => "111111", :password_confirmation => "111111" })
end
