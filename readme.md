Wrestling Gambling App

ToDo - before another tournament
- remove all constants, make betting 1 point per match

- intersperse leaderboard between rounds
- award each user 1 point per won bet
- facilitate buy in and payout configuration by tournament
- handle flow of users betting on some tournaments and not others
- when a match is closed choose a random bet for anyone who hasn't bet yet
- make fatalaties an associated object w/avatar
- switch bet from string wager to wager on wrestling (better support brackets later)
- interface for managing users and user avatars
- interface for ad hoc prop bets
- show current pot on tournament display screen

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

Prop Bets
- Steveson backflip
- PSU wins team title
- Iowa wins team title
- Billy Baldwin on the mic
- Kyle Dake interviewed
- Any winner by fall?
- >2 champions reference god,JC in interview
