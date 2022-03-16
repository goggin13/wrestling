set -e

git push
git push heroku-staging master

heroku run rake db:migrate -a wrastling-staging
heroku run rake staging:users staging:tournament -a wrastling-staging

node_modules/.bin/cypress run

echo "deploying to production"
git push heroku master
heroku run rake db:migrate -a wrastling
