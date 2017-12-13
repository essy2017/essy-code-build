#!/bin/bash

plugin_dir=/Applications/XAMPP/htdocs/essycode/wp-content/plugins

# Exit on error.
set -e

for dirname in $plugin_dir/*; do
  if [ -d $dirname ]; then
    thedir=$(basename $dirname)
    cp -r $dirname assets/plugins/$thedir
    rm -rf assets/plugins/$thedir/.git
    rm -f assets/plugins/$thedir/.gitignore
  fi
done
