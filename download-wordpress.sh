#!/bin/bash
cd assets

# If version specified use that, else latest.
file=latest.tar.gz
if [ -n "$1" ]; then
  file=wordpress-$1.tar.gz
fi

curl https://wordpress.org/$file | tar -xvz
