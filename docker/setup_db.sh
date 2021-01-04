docker exec \                
  wrestling-web \         
  bundle exec rake db:create 
                             
docker exec \                
  wrestling-web \         
  undle exec rake db:migrate
