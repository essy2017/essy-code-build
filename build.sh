#!/bin/bash

# Path to local dev wordpress installation.
wordpress_source=/Applications/XAMPP/htdocs/essycode

# Exit on error.
set -e

# Create build directory.
rm -rf build
mkdir -p build

# Copy Wordpress installation.
cp -r assets/wordpress/* build

# Replace sample configuration with live configuration.
rm build/wp-config-sample.php
cp assets/wp-config.php build

# Remove default plugins and templates.
rm -rf build/wp-content/plugins/akismet
rm -f build/wp-content/plugins/hello.php
rm -rf build/wp-content/themes/twentyfifteen
rm -rf build/wp-content/themes/twentysixteen
rm -rf build/wp-content/themes/twentyseventeen

# Copy local dev plugins and themes.
cp -r $wordpress_source/wp-content/plugins/* build/wp-content/plugins
cp -r $wordpress_source/wp-content/themes/* build/wp-content/themes

# Copy elastic beanstalk extensions.
cp -r assets/.ebextensions build

# Create artifact.
cd build
zip -rq ../artifact.zip .
