if docker ps | grep -o wrestling-web ; then
  docker exec -it wrestling-web bash
else
	docker run \
		-it \
    -p 3000:3000 \
		--name wrestling-console \
		-v $HOME/Documents/projects/wrestling:/var/www/wrestling \
		--rm \
		goggin13/wrestling \
		bash
fi
