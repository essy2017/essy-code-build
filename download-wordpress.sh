#!/bin/bash
cd assets

# Remove existing.
rm -rf wordpress

# If version specified use that, else latest.
file=latest.tar.gz
if [ -n "$1" ]; then
  file=wordpress-$1.tar.gz
fi

# Download and extract.
curl https://wordpress.org/$file | tar -xvz

# Clean directory.
cd ..
./clean-wordpress.sh
