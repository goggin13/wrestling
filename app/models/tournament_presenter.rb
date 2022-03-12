class TournamentPresenter
  def initialize(tournament)
    @tournament = tournament
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
end
