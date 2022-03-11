class MoneyLineBet < Bet
  def title
    "Moneyline bet on #{wrestler.name}"
  end

  def payout_ratio
    -150
  end

  # bet 150 dollars, win 100 dollars
  # given X dollars what is payout
  # X / payout = 150 / 100
  # 100X = 150/payout
  # payout = 150/X/100
  # 150 / 100 / 100

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
    if wager == "home" && match.spread > 0
      "#{wrestler.name} wins, or loses by less than #{match.spread} points"
    elsif wager == "home" && match.spread < 0
      "#{wrestler.name} wins by more than #{match.spread * -1} points"
    elsif wager == "away" && match.spread > 0
      "#{wrestler.name} wins by more than #{match.spread} points"
    elsif wager == "away" && match.spread < 0
      "#{wrestler.name} wins, or loses by less than #{match.spread * -1} points"
    else
      raise "win_scenario case fall through"
    end
  end

  def moneyback_scenario
    if match.spread < 0
      "#{match.home_wrestler.name} wins by #{match.spread * -1} points"
    else
      "#{match.away_wrestler.name} wins by #{match.spread} points"
    end
  end
end
