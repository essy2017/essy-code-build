<?php
/*
Plugin Name: EC Purge
Plugin URI: https://www.essycode.com
Version: 1.0.0
Author: Spencer Cherry
Description: Provides methods to purge Varnish cache.
*/
class EC_Purge_Init {

 /**
  * Initializes plugin.
  * @method init
  * @static
  */
  public static function init () {
    if (is_admin()) {
      require('includes/class-ec-purge.php');
      require('includes/class-ec-purge-admin.php');
      EC_Purge_Admin::init(
        plugin_basename(__FILE__), 
        basename(__FILE__), 
        trailingslashit(plugin_dir_path(__FILE__))
      );
    }
  }

}

EC_Purge_Init::init();
