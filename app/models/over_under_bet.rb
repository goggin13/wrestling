class OverUnderBet < Bet
  def title
    "#{wager.titlecase} bet on #{match.title}"
  end

  def payout_ratio
    -100
  end

  def submit_label
    "#{wager} #{match.over_under}"
  end

  def label
    "#{formatted_amount} #{wager} #{match.over_under}"
  end

  def success_message
    "Wagered #{label}"
  end

  def remove_message
    "Retract #{label} Bet"
  end

  def win_scenario
    if wager == "over"
      "the combined score is over #{match.over_under}"
    elsif wager == "under"
      "the combined score is under #{match.over_under}"
    else
      raise "win_scenario case fall through"
    end
  end

  def moneyback_scenario
    "the combined score is equal to #{match.over_under}"
  end

  def won?
    return false unless match.complete?

    if wager == "over"
      (match.home_score + match.away_score) > match.over_under
    else
      (match.home_score + match.away_score) < match.over_under
    end
  end

  def money_back?
    (match.home_score + match.away_score) == match.over_under
  end
end
