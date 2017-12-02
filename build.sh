#!/bin/bash

# Set this to your local Wordpress development installation.
wordpress_local=/Applications/XAMPP/htdocs/essycode

# Exit on error.
set -e

# Create build directory.
echo Creating build directory...
rm -rf build
mkdir -p build

echo Copying Wordpress...
cp -r $wordpress_local/* build

echo Generating .htaccess...
cp assets/.htaccess build/.htaccess
#if [ -f $wordpress_local/.htaccess ]; then
#  cat $wordpress_local/.htaccess >> build/.htaccess
#fi

#if [ -f $wordpress_local/.htaccess ]; then
#  cp $wordpress_local/.htaccess build/.htaccess
#fi

echo Replacing wp-config.php...
cp assets/wp-config.php build/wp-config.php

#
# Clean up theme.
#
theme_dir=build/wp-content/themes/essycode
rm -rf $theme_dir/.git
rm $theme_dir/.gitignore
rm -rf $theme_dir/.sass-cache
rm -rf $theme_dir/scss
rm -rf $theme_dir/scripts

# Copy elastic beanstalk extensions and remove sample configurations.
echo Installing .ebextensions...
cp -r assets/.ebextensions build
rm -f build/.ebextensions/env-sample.config

# Create artifact.
echo Creating artifact...
cd build
zip -rq ../artifact.zip .
