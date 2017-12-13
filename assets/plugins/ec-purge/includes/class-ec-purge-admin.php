<?php 

class EC_Purge_Admin {

 /**
  * Basename for plugin.
  * @property basename
  * @type String
  * @private
  * @static
  */
  private static $basename;
  
  private static $plugin_path;

 /**
  * Initializes admin section.
  * @method init
  * @param plugin {String} Plugin ending path.
  * @param basename {String} Name of plugin file.
  * @param plugin_path {String} Path to plugin.
  * @static
  */
  public static function init ($plugin, $basename, $plugin_path) {

    self::$basename    = $basename;
    self::$plugin_path = $plugin_path;
    add_action( 'admin_menu', array(__CLASS__, 'admin_menu') );
    add_filter( "plugin_action_links_$plugin", array(__CLASS__, 'add_settings_link') );
    add_action('wp_ajax_ecp_purge', array(__CLASS__, 'ajax_purge') );
  }

 /**
  * Adds a settings link to the plugin description.
  * @method add_settings_link
  * @param links {String[]} Existing links.
  * @return {String[]} New links.
  * @static
  */
  public static function add_settings_link ($links) {
    $settings_link = '<a href="options-general.php?page=ec-purge">' . __('Settings') . '</a>';
    array_push($links, $settings_link);
    return $links;
  }

 /**
  * Hooks into admin menu to add options page.
  * @method admin_menu
  * @static
  */
  public static function admin_menu () {
    if (function_exists('add_options_page')) {
      add_options_page('EC Purge', 'EC Purge', 'manage_options', self::$basename, array(__CLASS__, 'render_admin_page') );
    }
  }

 /**
  * Renders admin page.
  * @method render_admin_page
  * @static
  */  
  public static function render_admin_page () {
    include(self::$plugin_path . 'views/admin-page.php');
  }

 /**
  * Handler for AJAX call to purge object.
  * @method ajax_purge 
  * @return {String} JSON-encoded object with properties:
  *   response {String} Server response.
  *   status {Number} HTTP response status.
  *   success {Boolean} True on success.
  * @static
  */  
  public static function ajax_purge () {

    if (check_admin_referer('ecp_purge', 'ecp_purge_nonce')) {

      $url      = filter_input(INPUT_POST, 'url', FILTER_SANITIZE_STRING);
      
      echo json_encode(EC_Purge::purge($url));

      wp_die();
    }
  }
}