class Leaderboard
  def initialize(tournament)
    @tournament = tournament
  end

  def results
    ranked_overall_payouts = overall_payouts.sort_by{ |k,v| v }.reverse

    results = {}
    current_rank = 0
    last_payout = 999999
    ranked_overall_payouts.each do |user_id, payout|
      if payout < last_payout
        current_rank += 1
      end
      results[current_rank] ||= []
      results[current_rank] << [User.find(user_id), payout]
      last_payout = payout
    end

    results
  end

  def overall_payouts
    return @_overall_payouts if defined?(@overall_payouts)

    @overall_payouts = @tournament.matches.inject({}) do |overall_payouts, match|
      match.payouts.each do |user_id, match_payout|
        overall_payouts[user_id] ||= 0
        overall_payouts[user_id] += match_payout
      end

      overall_payouts
    end
  end
end
