module ApplicationHelper
  def user_tournament_link(user, tournament)
    link_to(user.email, tournament_bet_path(tournament, c: user.encoded_email))
  end

  def user_avatar(user, size="50x50")
    avatar(user, size: size)
  end

  def random_fatality
    id = (1..28).to_a.shuffle.first
    image_tag("fatalaties/#{id}.gif")
  end
end
