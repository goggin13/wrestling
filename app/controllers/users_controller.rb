class UsersController < ApplicationController
  def index
    @users = User.all
		@tournament = Tournament.last!
  end
end
