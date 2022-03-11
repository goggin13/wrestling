class SpreadBet < Bet
  def title
    "Spread bet on #{wrestler.name}"
  end

  def my_spread
    unformatted_spread = if wager == "home"
      match.spread
    else
      match.spread * -1
    end

    if unformatted_spread > 0
      "+#{unformatted_spread}"
    else
      unformatted_spread.to_s
    end
  end

  def payout_ratio
    -100
  end

  def submit_label
    "#{wrestler.initials} "
  end

  def label
    "#{formatted_amount} #{wrestler.initials} (#{my_spread})"
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
