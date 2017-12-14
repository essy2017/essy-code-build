#!/bin/bash

########
# SETUP.
########

# Exit on error.
set -e

# Make sure we have a local WordPress directory.
if [ ! -d "assets/wordpress" ]; then
  echo ERROR: Could not find assets/wordpress directory.
  exit -1
fi

# Theme source directory.
theme_src=/Applications/XAMPP/htdocs/essycode/wp-content/themes/essycode


#########################
# CREATE BUILD DIRECTORY.
#########################
echo Creating build directory...
rm -rf build
mkdir -p build


##############################
# COPY WORDPRESS INSTALLATION.
##############################
echo Copying WordPress...
cp -r assets/wordpress/* build


###############
# COPY PLUGINS.
###############
echo Copying plugins...
cp -r assets/plugins/* build/wp-content/plugins


################
# INSTALL THEME.
################
echo Intalling theme...

theme_target=build/wp-content/themes/essycode 
mkdir $theme_target

# Copy PHP files.
for filename in $theme_src/*.php; do
  file=$(basename $filename)
  cp $filename $theme_target/$file
done

# Copy includes.
cp -r $theme_src/includes $theme_target/includes

# Copy styles.
cp $theme_src/style.css $theme_target/style.css 

# Copy Javascript.
mkdir $theme_target/js
for filename in $theme_src/js/*.min.js; do
  file=$(basename $filename)
  cp $filename $theme_target/js/$file
done


#######################################
# COPY VISIBLE AND HIDDEN SERVER FILES.
#######################################
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


####################################
# COPY ELASTIC BEANSTALK EXTENSIONS.
####################################
echo Copying .ebextensions...
cp -r assets/.ebextensions build
rm -f build/.ebextensions/env-sample.config


##################
# CREATE ARTIFACT.
##################
echo Creating artifact...
rm -f artifact.zip
cd build
zip -rq ../artifact.zip .
