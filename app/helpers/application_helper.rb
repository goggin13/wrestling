module ApplicationHelper

  def user_tournament_link(user, tournament)
    link_to(user.email, tournament_bet_path(tournament, c: user.encoded_email))
  end
end
