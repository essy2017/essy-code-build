<?php 

class EC_Purge {

 /**
  * Default options.
  * @property default_options 
  * @type Array 
  * @static 
  * @private
  */  
  private static $default_options = array(
    'secret' => ''
  );
  
 /**
  * Cached options.
  * @property options 
  * @type Array 
  * @static 
  * @private
  */  
  private static $options = null;

 /**
  * Gets plugin options.
  * @method get_options 
  * @return {Array} Options.
  * @static`
  */  
  public static function get_options () {
    if (self::$options === null) {
      self::$options = self::$default_options;
      $saved_options = get_option('ecp_options');
      if (!empty($saved_options)) {
        foreach ($saved_options as $key => $value) {
          self::$options[$key] = $value;
        }
      }
    }
    return self::$options;
  }
  
 /**
  * Purges object from Varnish cache.
  * @method purge 
  * @param url {String} Object URL.
  * @return {Array} With properties:
  *   response {String} Server response.
  *   status {Number} HTTP status.
  *   success {Boolean} True if status === 200.
  * @static
  */  
  public static function purge ($url) {
    
    $options = self::get_options();
    $curl    = curl_init();
    $opts    = array(
      CURLOPT_HTTPHEADER     => array('X-Purge-Token:' . $options['secret']),
      CURLOPT_RETURNTRANSFER => 1,
      CURLOPT_URL            => $url,
      CURLOPT_CUSTOMREQUEST  => 'PURGE'
    );
    
    curl_setopt_array($curl, $opts);
    $response = curl_exec($curl);
    $status   = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    
    return array(
      'response'  => $response,
      'status'    => $status,
      'success'   => $status === 200
    );
  }
  
}