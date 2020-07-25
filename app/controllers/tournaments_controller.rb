class TournamentsController < ApplicationController
  before_action :require_admin!
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :bet, :display, :not_in_session, :administer]
  skip_before_action :authenticate_user!, only: [:bet, :show, :display, :not_in_session]
  skip_before_action :require_admin!, only: [:bet, :show, :display, :not_in_session]

  def bet
    email = Base64.decode64(params[:c])
    user = User.where(email: email).first!
    sign_in(user)
    redirect_to tournament_path(@tournament)
  end

  def display
    @match = @tournament.current_match
    if @match.present?
      @home = @match.home_wrestler
      @home_bets = @match.home_bets
      @away = @match.away_wrestler
      @away_bets = @match.away_bets
    end

    render layout: false
  end

  def not_in_session
  end

  def administer
    @users = User.all
  end

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to tournament_administer_path(@tournament), notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id] || params[:tournament_id])
    end

    # Only allow a list of trusted parameters through.
    def tournament_params
      params.require(:tournament).permit(:name, :current_match_id)
    end
end
