class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :require_admin!

  def require_admin!
    unless current_user.admin?
      redirect_to tournament_path(Tournament.first!)
    end
  end
end
