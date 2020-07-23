class UsersController < ApplicationController
  def index
    @users = User.all
		@tournament = Tournament.first!
  end
end
