#!/bin/bash

# Exit on error.
set -e

# Make sure we have a local WordPress directory.
if [ ! -d "assets/wordpress" ]; then
  echo ERROR: Could not find assets/wordpress directory.
  exit -1
fi

# Theme source directory.
theme_src=/Applications/XAMPP/htdocs/essycode/wp-content/themes/essycode

# Create build directory.
echo Creating build directory...
rm -rf build
mkdir -p build

# Copy core WordPress files.
echo Copying WordPress...
cp -r assets/wordpress/* build

# Copy plugins.
echo Copying plugins...
cp -r assets/plugins/* build/wp-content/plugins

# Install theme and clean up.
echo Intalling theme...
cp -r $theme_src build/wp-content/themes
theme_target=build/wp-content/themes/essycode
rm -rf $theme_target/.git
rm $theme_target/.gitignore
rm -rf $theme_target/.sass-cache
rm -rf $theme_target/scss
rm -rf $theme_target/scripts

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
