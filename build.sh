#!/bin/bash

########
# SETUP.
########

BLUE='\033[38;5;33m'
GREEN='\033[0;32m'
GRAY='\033[38;5;240m'
ORANGE='\033[38;5;214m'
OUTPUT='\033[38;5;33m'
RED='\033[0;31m'
NC='\033[0m'

# Prints status message.
print_status() {
  msg=$1
  echo -e "${OUTPUT}$msg${GRAY}...${NC}\c"
}

# Prints success message.
print_success() {
  echo -e "${GREEN}complete${NC}"
}

# Prints error message.
print_error() {
  msg=$1
  echo -e "${RED}ERROR: $msg.${NC}"
}

# Exit on error.
set -e

# Make sure we have a local WordPress directory.
if [ ! -d "assets/wordpress" ]; then
  print_error "Could not find assets/wordpress directory."
  exit -1
fi

# Load theme source directory.
source config.txt


#########################
# CREATE BUILD DIRECTORY.
#########################
print_status "Creating build directory"
rm -rf build
mkdir -p build
print_success


##############################
# COPY WORDPRESS INSTALLATION.
##############################
print_status "Copying WordPress"
cp -r assets/wordpress/* build
print_success


###############
# COPY PLUGINS.
###############
print_status "Copying plugins"
cp -r assets/plugins/* build/wp-content/plugins
print_success

################
# INSTALL THEME.
################
print_status "Installing theme"

theme_target=build/wp-content/themes/essycode
mkdir $theme_target

# Copy PHP files.
for filename in $theme_src/*.php; do
  file=$(basename $filename)
  cp $filename $theme_target/$file
done

# Copy includes.
cp -r $theme_src/includes $theme_target/includes

# Copy core style.
cp $theme_src/style.css $theme_target/style.css

# Copy other styles.
cp -r $theme_src/css $theme_target/css

# Copy Javascript.
mkdir $theme_target/js
for filename in $theme_src/js/*.min.js; do
  file=$(basename $filename)
  cp $filename $theme_target/js/$file
done

print_success


#######################################
# COPY VISIBLE AND HIDDEN SERVER FILES.
#######################################
print_status "Copying server files"

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

print_success


####################################
# COPY ELASTIC BEANSTALK EXTENSIONS.
####################################
print_status "Copying .ebextensions"
cp -r assets/.ebextensions build
rm -f build/.ebextensions/env-sample.config
print_success

##################
# CREATE ARTIFACT.
##################
print_status "Creating artifact"
rm -f artifact.zip
cd build
zip -rq ../artifact.zip .
print_success
