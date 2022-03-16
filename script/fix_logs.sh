set -e

rm -f log/*
touch log/development.log
chmod 0664 log/development.log
touch log/test.log
chmod 0664 log/test.log
ls log/*
