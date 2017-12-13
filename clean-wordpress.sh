#!/bin/bash
if [ ! -d "assets/wordpress" ]; then
  echo ERROR: Could not find assets/wordpress directory.
  exit -1
fi

cd assets/wordpress

# Remove sample config.
echo Removing wp-config-sample.php...
rm -f wp-config-sample.php

# Remove default plugins.
echo Removing default plugins...
for filename in wp-content/plugins/*; do
  if [ -f $filename ]; then
    if [ $(basename $filename) != "index.php" ]; then
      rm $filename
    fi
  fi
  if [ -d $filename ]; then
    rm -rf $filename
  fi
done

# Remove default themes.
echo Removing default themes...
for filename in wp-content/themes/*; do
  if [ -d $filename ]; then
    rm -rf $filename
  fi
done
