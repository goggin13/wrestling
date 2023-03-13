class PickemBet < SpreadBet
  def self.save_and_delete_others(bet)
    if bet.save
      Bet.where(user: bet.user, match: bet.match)
        .where("id != ?", bet.id)
        .destroy_all
    end

    bet
  end

  def title
    "#{wager.titlecase} bet on #{match.title}"
  end

  def label
    "#{wager} #{match.over_under}"
  end

  def success_message
    "Placed bet on #{wrestler.name} (#{my_spread})"
  end

  def remove_message
    "Retract #{label} Bet"
  end
end
