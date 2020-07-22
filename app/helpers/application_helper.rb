module ApplicationHelper
  def user_tournament_link(user, tournament)
    link_to(user.email, tournament_bet_path(tournament, c: user.encoded_email))
  end

  def user_avatar(user, size="50x50")
    file = user.email.split("@")[0]
    image_tag("#{file}.jpg", size: size, alt: user.email, class: "avatar")
  end

  def random_fatality
    id = (1..20).to_a.shuffle.first
    image_tag("fatalaties/#{id}.gif")
  end
end
