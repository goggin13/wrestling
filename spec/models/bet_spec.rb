require 'rails_helper'

RSpec.describe Bet, type: :model do

  describe ".create_and_decrement_amount" do
    before do
      @user = FactoryBot.create(:user, balance: 20)
      @match = FactoryBot.create(:match)
      @params = {
        user_id: @user.id,
        amount: 10,
        wager: "home",
        match: @match
      }
    end

    it "creates a new bet and modifies the user's balance if they have enough" do
      expect do
        bet = Bet.save_and_charge_user(Bet.new(@params))
      end.to change(Bet, :count).by(1)
      @user.reload
      expect(@user.balance).to eq(10)
    end

    it "returns an invalid bet" do
      bet = Bet.save_and_charge_user(Bet.new(@params.merge(amount: nil)))
      expect(bet.errors[:amount][0]).to eq("can't be blank")
    end

    it "returns a newly created bet" do
      bet = Bet.save_and_charge_user(Bet.new(@params))
      expect(bet.id).to_not be_nil
    end

    it "fails to create a new bet if the user doesn't have funds" do
      expect do
        bet = Bet.save_and_charge_user(Bet.new(@params.merge(amount: 25)))
      end.to change(Bet, :count).by(0)
      @user.reload
      expect(@user.balance).to eq(20)
    end

    it "returns a bet with validation errors if the user doesn't have funds" do
      expect do
        bet = Bet.save_and_charge_user(Bet.new(@params.merge(amount: 25)))
      end.to change(Bet, :count).by(0)
      @user.reload
      expect(@user.balance).to eq(20)
    end
  end

  describe "amount" do
    before do
      @user = FactoryBot.create(:user, balance: 20)
    end

    it "is required" do
      bet = Bet.new(user: @user, amount: nil)
      bet.save
      expect(bet.errors[:amount][0]).to eq("can't be blank")
    end

    it "is invalid if less than 0" do
      bet = Bet.new(user: @user, amount: -1)
      bet.save
      expect(bet.errors[:amount][0]).to eq("must be greater than 0")
    end

    it "is invalid if greater than user.balance" do
      bet = Bet.new(user: @user, amount: 25)
      bet.save
      expect(bet.errors[:amount][0]).to eq("must be less than user balance")
    end

    it "is valid if > 0 and user has the balance" do
      bet = Bet.new(user: @user, amount: 10.0)
      bet.save
      expect(bet.errors[:amount].length).to eq(0)
    end
  end

  describe "wager" do
    it "is valid if it is home" do
      bet = Bet.new(wager: "home")
      bet.save
      expect(bet.errors[:wager].length).to eq(0)
    end

    it "is valid if it is away" do
      bet = Bet.new(wager: "away")
      bet.save
      expect(bet.errors[:wager].length).to eq(0)
    end

    it "is invalid if it is not home|away" do
      bet = Bet.new(wager: "neither")
      bet.save
      expect(bet.errors[:wager][0]).to eq("is not included in the list")
    end
  end

  describe "match must be open" do
    it "is invalid if the match is closed" do
      @match = FactoryBot.create(:match, closed: true)
      bet = Bet.new(match: @match)
      bet.save
      expect(bet.errors[:match][0]).to eq("Must be open for betting")
    end
  end

  describe "uniqueness" do
    before do
      @user = FactoryBot.create(:user)
      @match = FactoryBot.create(:match)
    end

    it "fails for a user on the same type of bet forthe same wager and same match" do
      FactoryBot.create(:bet, user: @user, match: @match, type: "MoneyLineBet", wager: "home")
      bet = Bet.new(user: @user, match: @match, type: "MoneyLineBet", wager: "home", amount: 10)
      bet.save
      expect(bet.errors[:match][0]).to eq("has already been taken")
    end

    it "is valid for a user who wagers home and away on the same match" do
      FactoryBot.create(:bet, user: @user, match: @match, type: "MoneyLineBet", wager: "home")
      bet = Bet.new(user: @user, match: @match, type: "MoneyLineBet", wager: "away", amount: 10)
      expect(bet.valid?).to eq(true)
    end
  end
end
