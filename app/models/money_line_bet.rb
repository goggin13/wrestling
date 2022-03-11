class MoneyLineBet < Bet
  def title
    "Moneyline bet on #{wrestler.name}"
  end

  def payout_ratio
    # underdog
    if (wager == "home" && match.spread > 0) || (wager == "away" && match.spread < 0)
      100 + (match.spread.abs * 20)
    # favorite
    elsif (wager == "home" && match.spread < 0) || (wager == "away" && match.spread > 0)
      (100 + (match.spread.abs * 20)) * -1
    else
      raise "win_scenario case fall through"
    end
  end

  def submit_label
    "#{wrestler.initials} M/L"
  end

  def label
    "#{formatted_amount} #{wrestler.initials} M/L"
  end

  def success_message
    "Wagered #{label}"
  end

  def remove_message
    "Retract #{label} Bet"
  end

  def win_scenario
    "#{wrestler.name} wins"
  end
end
