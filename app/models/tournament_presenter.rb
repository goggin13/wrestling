class TournamentPresenter
  def initialize(tournament, user=nil)
    @tournament = tournament
    @user = user
  end

  def matches
    @tournament.matches.order("weight ASC")
  end

  def bets_for_match(match, row)
    bets_by_match[match.id][row]
  end

  def bets_by_match
    return @_bets_by_match if defined?(@_bets_by_match)

    @_bets_by_match = {}
    matches.each do |match|
      @_bets_by_match[match.id] = [
        [
          SpreadBet.new(amount: 5.0, match: match, wager: "away"),
          MoneyLineBet.new(amount: 5.0, match: match, wager: "away"),
          OverUnderBet.new(amount: 5.0, match: match, wager: "over")
        ],
        [
          SpreadBet.new(amount: 5.0, match: match, wager: "home"),
          MoneyLineBet.new(amount: 5.0, match: match, wager: "home"),
          OverUnderBet.new(amount: 5.0, match: match, wager: "under")
        ],
      ]
    end

    @_bets_by_match
  end

  def pickem_win?(match)
    bet = Bet.where(user_id: @user.id, type: "PickemBet", match_id: match.id).first

    bet.present? && bet.won?
  end

  def pickem_count
    Bet.where(user_id: @user.id, type: "PickemBet")
      .where("match_id in (?)", matches.map(&:id))
      .filter { |b| b.won? }
      .length
  end
end
