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
    - wager = home|away
  - create subclass OverUnderBet
    - wager = over|under
- create tournament betting page
  - show matches
  - show form to make MoneyLineBet
  - show form to make OverUnderBet
  - bet form should
    - allow you to adjust wager up to current balance
    - tell you how much money you will win
    - display cases for winning and losing
      - you will win if "dake wins by more than 7"
      - you will tie if "dake wins by 7"
      - you will lose if "dake loses, or wins by 6 or less"
- when the admin updates the scores for a match
  - update all bets for the match
    - if won, set payout
    - add payout to user balance
- create subclass SpreadBet
  - wager = home|away
  - subclass of MoneyLineBet?
  - add to betting page
- create tournament leaderboard view
  - list of users with balance
  - live update as balances change 
  - display current match
  - once current match is closed
    - display user avatars alongside current match
- create ledger of bets per user
  - Ledger (user_id, bet_id, change, balance, description)
  - create ledger entry every time user balance is changed
- blow away old data on live site
- deploy and test

# Further AddOns
- make fatalaties an associated object w/avatar
- upgrade rails
- prop bets

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
