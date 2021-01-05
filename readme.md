Wrestling Gambling App

ToDo - before another tournament
- switch bet from string wager to wager on wrestling (better support brackets later)
- interface for managing users and user avatars
- interface for managing wrestlers and wrestler avatars
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
