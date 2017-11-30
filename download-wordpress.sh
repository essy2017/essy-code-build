#!/bin/bash

cd assets
curl -O https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
chmod 755 latest.tar.gz
rm latest.tar.gz
