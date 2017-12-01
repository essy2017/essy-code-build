#!/bin/bash

# Set this to your local Wordpress development installation.
wordpress_local=/Applications/XAMPP/htdocs/essycode

# Exit on error.
set -e

# Create build directory.
echo Creating build directory...
rm -rf build
mkdir -p build

# Copy Wordpress installation after checking that it exists.
echo Copying Wordpress...
if [ ! -d assets/wordpress ]; then
  echo ERROR: Could not find assets/wordpress. Run ./download-wordpress.sh and try again.
  exit 1
fi
cp -r assets/wordpress/* build

# Copy .htaccess from local environment.
if [ -f $wordpress_local/.htaccess ]; then
  cp $wordpress_local/.htaccess build/.htaccess
fi

# Replace sample configuration.
rm build/wp-config-sample.php
cp assets/wp-config.php build

# Clear out default themes and plugins and copy from local environment.
echo Installing plugins and themes...
rm -rf build/wp-content/plugins/*
rm -rf build/wp-content/themes/*
cp -r $wordpress_local/wp-content/plugins/* build/wp-content/plugins
cp -r $wordpress_local/wp-content/themes/* build/wp-content/themes

# Copy elastic beanstalk extensions and remove sample configurations.
echo Installing .ebextensions...
cp -r assets/.ebextensions build
rm -f build/.ebextensions/env-sample.config

# Create artifact.
echo Creating artifact...
cd build
zip -rq ../artifact.zip .
