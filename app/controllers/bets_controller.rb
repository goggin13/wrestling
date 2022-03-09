class BetsController < ApplicationController
  before_action :set_bet, only: %i[ show edit update destroy ]

  # GET /bets or /bets.json
  def index
    @bets = Bet.all
  end

  # GET /bets/1 or /bets/1.json
  def show
  end

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # GET /bets/1/edit
  def edit
  end

  # POST /bets or /bets.json
  def create
    @bet = Bet.new(bet_params)

    respond_to do |format|
      if @bet.save
        format.html {
          redirect_to tournament_url(@bet.match.tournament), notice: @bet.success_message
        }
        format.json { render :show, status: :created, location: @bet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bets/1 or /bets/1.json
  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html { redirect_to bet_url(@bet), notice: "Bet was successfully updated." }
        format.json { render :show, status: :ok, location: @bet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1 or /bets/1.json
  def destroy
    @bet.destroy

    respond_to do |format|
      format.html {
        redirect_to tournament_url(@bet.match.tournament), notice: "Removed #{@bet.label} Bet"
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bet
      @bet = Bet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bet_params
      params
        .require(:bet)
        .permit(:match_id, :type, :amount, :wager, :payout)
        .merge(:user_id => current_user.id)
    end
end
