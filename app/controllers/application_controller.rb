class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def require_admin!
    unless current_user && current_user.admin?
      redirect_to tournament_path(Tournament.current)
    end
  end
end
