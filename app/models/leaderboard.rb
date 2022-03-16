class Leaderboard
  def initialize(tournament)
    @tournament = tournament
  end

  def results
    ranked_users = user_balances.sort_by do |user_data|
      user_data[:balance]
    end.reverse

    results = []
    previous_rank = 0
    previous_balance = 999999
    ranked_users.each_with_index do |user_data, index|
      rank = if user_data[:balance] == previous_balance
        previous_rank
      else
        index + 1
      end

      user_data[:rank] = rank
      results << user_data

      previous_balance = user_data[:balance]
      previous_rank = user_data[:rank]
    end

    results
  end

  def user_balances
    return @_user_balances if defined?(@_user_balances)
    match_ids = @tournament.matches.map(&:id)

    @_user_balances = User.all.map do |user|
      next if user.bets.where(match_id: match_ids).count() == 0

      pending_bet_balance = user.bets
        .where(payout: nil)
        .where(match_id: match_ids)
        .map(&:amount)
        .sum

      {user: user, balance: user.balance + pending_bet_balance}
    end.compact
  end
end
