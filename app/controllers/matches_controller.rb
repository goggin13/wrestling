class MatchesController < ApplicationController
  before_action :require_admin!
  before_action :set_match, only: [:show, :edit, :update, :destroy, :close, :open, :winner]
  before_action :set_form_variables, only: [:edit, :new]
  skip_before_action :require_admin!, only: [:show]
  skip_before_action :authenticate_user!, only: [:show]

  def close
    @match.update!(closed: true)
    flash[:notice] = "#{@match.title} closed for voting"
    redirect_to tournament_administer_path(@match.tournament)
  end

  def open
    if @match.winner.present?
      flash[:notice] = "#{@match.title} cannot be opened while there is a winner"
    else
      @match.update!(closed: false)
      flash[:notice] = "#{@match.title} open for voting"
    end
    redirect_to tournament_administer_path(@match.tournament)
  end

  def winner
    @match.update!(
      winner_id: match_params[:winner_id],
      total_score: match_params[:total_score],
      closed: true
    )
    winner = @match.winner.nil? ? "None" : @match.winner.name
    flash[:notice] = "#{@match.title} winner set to #{winner}"
    redirect_to tournament_administer_path(@match.tournament)
  end

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.all
  end

  def display
    render :layout => false
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id] || params[:match_id])
    end

    # Only allow a list of trusted parameters through.
    def match_params
      params.require(:match).permit(:weight, :home_wrestler_id, :away_wrestler_id, :winner_id, :tournament_id, :total_score)
    end

    def set_form_variables
      @tournaments = Tournament.order("created_at DESC").all
      @wrestlers = Wrestler.order("name").all
    end
end
