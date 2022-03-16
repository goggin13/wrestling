Wrestling Gambling App

# Betting Improvement Revamp
X upgrade bundler
X install E2E testing framework
X set up staging site
X update Match model
  X add home_score, away_score, spread
  X remove total_score
  X update match form to handle these
  X update admin screen to input these nicely
- stop being lazy and TDD these changes
X add balance to user model
  X display on user index page
  X display in banner
- create abstract bets table
  X {match_id, user_id, type, amount, wager, payout, open}
  - make payout a method for now, TBD on how to set
  X when createing a bet, validate user has money in their balance
    X transactionally subtract from user balance
  X when deleting a bet, give the user money back
  X create subclass MoneyLineBet
X prevent deleting a bet from a closed match
- create tournament betting page
  X show matches
  X show form to make MoneyLineBet
  - BET FORM SHOULD
    X popup and then delegate back to regular form to submit
    X allow you to adjust wager up to current balance
    X tell you how much money you will win
    X display cases for winning and losing

X !!!Testing party!!!

X handle closed matches in the UI
X when the admin updates the scores for a match
  X update all bets for the match
    X if won, set payout
    X add payout to user balance
X create subclass SpreadBet
X create subclass OverUnderBet
X create tournament leaderboard view
  X list of users with balance
  X live update as balances change 
  X display current match
  X once current match is closed
    X display user avatars alongside current match
X create ledger of bets per user
  X Ledger (user_id, bet_id, change, balance, description)
  X create ledger entry every time user balance is changed
- blow away old data on live site
- deploy and test
- more cypress tests

# Further AddOns
- animation to tournament show page when you receive more funds
- slider to adjust amount to bet
- make fatalaties an associated object w/avatar
- upgrade rails
- prop bets
- fix overunder wager hack

# College logos
https://www.sportslogos.net/teams/list_by_league/85/National_Collegiate_Athletic_Assoc/NCAA/logos/

# Setting up development
```
./docker/tag_and_build.sh
./docker/exec.sh
bundle exec rake db:test:prepare
bundle exec rspec --fail-fast
RAILS_ENV=development bundle exec rails runner script/add_users.rb
RAILS_ENV=development bundle exec rails runner script/setup_exhibition_tournament.rb
```

tournament
  has_many :users (through matches, through bets)
  buy_in
  match_plus_bonus_style
    bonus_pct
    pot = buy_in * users
    single_match_pot = pot * (1-bonus_pct)
    bonus_pot = pot * bonus_pct

Prop Bet(Description, hit?)
  on_change: update all wagers
Prop Bet Wager(user_id, prob_bet_id, hit?)

Prop Bets
- Steveson backflip
- PSU wins team title
- Iowa wins team title
- Billy Baldwin on the mic
- Kyle Dake interviewed
- Any winner by fall?
- >2 champions reference god,JC in interview
