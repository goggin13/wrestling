docker run \
  -it \
  -p 3000:3000 \
  --name find-home-web \
  -v $HOME/Documents/projects/find-home:/var/www/find-home \
  --rm \
  goggin13/find-home
