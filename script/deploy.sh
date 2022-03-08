git push heroku-staging abstract_bets:master
heroku run rake db:migrate -a wrastling-staging
heroku run rake staging:users staging:tournament -a wrastling-staging

# git push heroku abstract_bets:master
# heroku run rake db:migrate
