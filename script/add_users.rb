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

].each do |email|
  password = SecureRandom.hex(8)
  User.create!(
		:email => email,
    :password => password,
    :password_confirmation => password
  )
end

puts "Added #{User.count} users"
