if docker ps | grep -o find-home-web ; then
  docker exec -it find-home-web bash
else
	docker run \
		-it \
		--name find-home-console \
		-v $HOME/Documents/projects/find-home:/var/www/find-home \
		--rm \
		goggin13/find-home \
		bash
fi
