class BetsController < ApplicationController
  before_action :set_bet, only: %i[ show edit update destroy ]
  before_action :validate_current_user_owns_bet, only: :destroy
  before_action :validate_bet_match_is_open, only: :destroy

  # GET /bets or /bets.json
  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @bets = @user.bets.order("updated_at DESC").all
    else
      @bets = Bet.order("updated_at DESC").all
    end

    @bets = @bets.sort_by { |b| b.match.weight }
  end

  # GET /bets/1 or /bets/1.json
  def show
  end

  # POST /bets or /bets.json
  def create
    respond_to do |format|
      bet = Bet.new(bet_params)
      bet = bet.becomes(bet.type.constantize)
      @bet = Bet.save_and_charge_user(bet)
      if @bet.id.present?
        format.html {
          redirect_to tournament_url(@bet.match.tournament), notice: @bet.success_message
        }
        format.json { render :show, status: :created, location: @bet }
      else
        @bet.errors.each do |field, message|
          Rails.logger.info("Failed to save bet: #{field}-#{message}")
        end
        format.html {
          redirect_to tournament_url(@bet.match.tournament), alert: "Failed to create bet"
        }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1 or /bets/1.json
  def destroy
    Bet.delete_and_refund_user(@bet)

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

    def validate_current_user_owns_bet
      unless @bet.user == current_user
        redirect_to tournament_url(@bet.match.tournament), alert: "You do not own that bet"
      end
    end

    def validate_bet_match_is_open
      unless @bet.match.open?
        redirect_to tournament_url(@bet.match.tournament), alert: "That match is closed for betting"
      end
    end
end
