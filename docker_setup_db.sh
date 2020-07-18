docker exec \                
  find-home-web \         
  bundle exec rake db:create 
                             
docker exec \                
  find-home-web \         
  undle exec rake db:migrate
