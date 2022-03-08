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

  def home_spread(match)
    return "" unless match.spread.present?
    if match.spread > 0
      "+#{match.spread}"
    else
      match.spread
    end
  end

  def away_spread(match)
    return "" unless match.spread.present?
    if match.spread > 0
      match.spread * -1
    else
      "+#{match.spread * -1}"
    end
  end
end
