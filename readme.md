Wrestling Gambling App

ToDo - before another tournament
- debug live site; blow away old data?
X Add score onto match and set it when winner is set
- Add over/under onto current bet
  X hook up over/under on bet page to back end
  X when creating/editing a match, set weight and over/under value
  X include over/under in payout calculation
- update betting interface to indicate a bet has been saved

X debug deploy
- interface for making and administering prop bets
X interface for managing users and user avatars
- intersperse leaderboard between rounds
- make fatalaties an associated object w/avatar
- upgrade rails
- leaderboard always present, ready to update from prop bets

- facilitate buy in and payout configuration by tournament
- handle flow of users betting on some tournaments and not others
- when a match is closed choose a random bet for anyone who hasn't bet yet
- switch bet from string wager to wager on wrestling (better support brackets later)
- show current pot on tournament display screen

X award each user 1 point per won bet

# College logos
https://www.sportslogos.net/teams/list_by_league/85/National_Collegiate_Athletic_Assoc/NCAA/logos/

https://www.flowrestling.org/articles/6852595-burroughs-taylor-complete-card-preview

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
