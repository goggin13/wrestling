Wrestling Gambling App

ToDo - before another tournament
- interface for managing users and user avatars
- interface for managing matches in a tournament
- make colleges an associated object w/avatar
    https://www.sportslogos.net/teams/list_by_league/85/National_Collegiate_Athletic_Assoc/NCAA/logos/
- make fatalaties an associated object w/avatar
- switch bet from string wager to wager on wrestling (better support brackets later)
- organize images directory

# Setting up development
```
./docker/tag_and_build.sh
./docker/exec.sh
bundle exec rake db:test:prepare
bundle exec rspec --fail-fast
RAILS_ENV=development bundle exec rails runner add_users.rb
RAILS_ENV=development bundle exec rails runner setup_exhibition_tournament.rb
```
