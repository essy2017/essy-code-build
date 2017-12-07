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

# Clean up theme.
theme_dir=build/wp-content/themes/essycode
rm -rf $theme_dir/.git
rm $theme_dir/.gitignore
rm -rf $theme_dir/.sass-cache
rm -rf $theme_dir/scss
rm -rf $theme_dir/scripts

# Copy visible and hidden server files.
echo Copying server files...

for filename in assets/server-files/*; do
  file=$(basename $filename)
  cp $filename build/$file
done

for filename in assets/server-files/.*; do
  if [ -f $filename ]; then
    file=$(basename $filename)
    cp $filename build/$file
  fi
done

# Copy elastic beanstalk extensions and remove sample configurations.
echo Copying .ebextensions...
cp -r assets/.ebextensions build
rm -f build/.ebextensions/env-sample.config

# Create artifact.
echo Creating artifact...
rm -f artifact.zip
cd build
zip -rq ../artifact.zip .
