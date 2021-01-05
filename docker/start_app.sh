docker run \
  -it \
  -p 3000:3000 \
  --env-file .aws \
  --name wrestling-web \
  -v $HOME/Documents/projects/wrestling:/var/www/wrestling \
  --rm \
  goggin13/wrestling
