class Leaderboard
  BUY_IN = 10.00

  def initialize(tournament)
    @tournament = tournament
  end

  def results
    ranked_users = user_balances.sort_by do |user_data|
      user_data[:balance]
    end.reverse

    total_real_world_pot = user_balances.length * BUY_IN
    results = []
    previous_rank = 0
    previous_balance = 999999
    rounding_bonus = 0
    ranked_users.each_with_index do |user_data, index|
      rank = if user_data[:balance] == previous_balance
        previous_rank
      else
        index + 1
      end

      user_data[:rank] = rank
      user_data[:percentage] = user_data[:balance] / total_balances
      user_data[:take_home] = (total_real_world_pot * user_data[:percentage]).floor
      results << user_data

      previous_balance = user_data[:balance]
      previous_rank = user_data[:rank]
    end

    return [] if ranked_users.length == 0

    current_take_home = ranked_users.map { |u| u[:take_home] }.sum
    rounding_bonus = total_real_world_pot - current_take_home
    ranked_users[0][:take_home] += rounding_bonus

    results
  end

  def total_balances
    return @_total_balances if defined?(@_total_balances)

    @_total_balances = user_balances.inject(0) do |acc, user_data|
      acc + user_data[:balance]
    end

    @_total_balances
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
