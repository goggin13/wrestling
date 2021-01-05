if docker ps | grep -o wrestling-web ; then
  docker exec -it wrestling-web bash
elif docker ps | grep -o wrestling-console ; then
  docker exec -it wrestling-console bash
else
	docker run \
		-it \
    -e RAILS_ENV=test \
    --env-file .aws \
    -p 3000:3000 \
		--name wrestling-console \
		-v $HOME/Documents/projects/wrestling:/var/www/wrestling \
		--rm \
		goggin13/wrestling \
		bash
fi
