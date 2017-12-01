#!/bin/bash

# Load config. Should include:
#   wordpress_source
source config.cfg

# Exit on error.
set -e

# Create build directory.
rm -rf build
mkdir -p build

# Copy Wordpress installation after checking that it exists.
if [ ! -d assets/wordpress ]; then
  echo ERROR: Could not find assets/wordpress. Run ./download-wordpress.sh and try again.
  exit 1
fi
cp -r assets/wordpress/* build

# Copy .htaccess from local installation.
if [ -f $wordpress_source/.htaccess ]; then
  cp $wordpress_source/.htaccess build/.htaccess
fi

# Replace sample configuration with live configuration.
rm build/wp-config-sample.php
cp assets/wp-config.php build

# Clear out default themes and plugins and copy from local dev.
rm -rf build/wp-content/plugins/*
rm -rf build/wp-content/themes/*
cp -r $wordpress_source/wp-content/plugins/* build/wp-content/plugins
cp -r $wordpress_source/wp-content/themes/* build/wp-content/themes

# Copy elastic beanstalk extensions and remove sample configurations.
cp -r assets/.ebextensions build
rm -f build/.ebextensions/env-sample.config

# Create artifact.
cd build
zip -rq ../artifact.zip .
