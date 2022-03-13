class BetService
  def self.settle_bets_for_match(match)
    Bet.transaction do
      Rails.logger.info "[BetService] Settling Bets"
      match.bets.each do |bet|
        Rails.logger.info "[BetService] Settling bet #{bet.user.email} : #{bet.title}"
        Rails.logger.info "[BetService] bet won: #{bet.won?}, bet money_back: #{bet.money_back?}"
        bet.set_payout!
        bet.user.balance += bet.payout
        bet.user.save!
        Rails.logger.info "[BetService] updated balance for #{bet.user.email} : #{bet.user.balance}"
      end
    end
  end
end
