class MoneyLineBet < Bet
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
end
