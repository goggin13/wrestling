class BetService
  def self.settle_bets_for_match(match)
    Rails.logger.info "[BetService] setting bets_settling = true"
    Tournament.current.update!(bets_settling: true)
    if Rails.env.production?
      Rails.logger.info "[BetService] sleeping..."
      sleep(4)
      Rails.logger.info "[BetService] waking"
    end

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

    Tournament.current.update!(bets_settling: false)
    Rails.logger.info "[BetService] set bets_settling = false"
  end
end
