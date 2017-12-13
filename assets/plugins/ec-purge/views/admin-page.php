<?php 

$options = EC_Purge::get_options();

?>

<script>
  jQuery(document).ready(function ($) {
  
   /**
    * Creates response element.
    * @method createResponseEl
    * @param success {Boolean} True on success.
    * @param status {Number} HTTP response status.
    * @param response {String} Response message.
    * @return {jQuery}
    */  
    function createResponseEl (success, status, response) {
      var wrapEl = $('<div id="ecp-purge-response"></div>'),
          statusEl = $('<div><span class="label">Status</span><span class="value">' + status + '</span></div>');
      statusEl.addClass(success ? 'ecp-success' : 'ecp-error');
      wrapEl.append(statusEl);
      wrapEl.append('<div><span class="label">Response</span><span class="value">' + response + '</span></div>');
      return wrapEl;
    }
  
   /**
    * Handler for clicks on the purge button.
    */  
    $('#ecp-purge-form button').click(function (e) {
      
      e.preventDefault();
      
      var btnEl   = $(this).prop('disabled', true),
          formEl  = btnEl.closest('form'),
          inputEl = formEl.find('input[name="ecp_url"]'),
          url     = inputEl.val();
      
      $('#ecp-purge-response').remove();
      
      formEl.find('.tip').text('');
      if (!url.trim().length) {
        formEl.find('.tip').text('Please enter a URL.');
        return false;
      }
      
      $.post({
        url: ajaxurl,
        data: {
          action           : 'ecp_purge',
          url              : url.trim(),
          ecp_purge_nonce  : formEl.find('input[name="ecp_purge_nonce"]').val(),
          _wp_http_referer : formEl.find('input[name="_wp_http_referer"]').val()
        },
        success: function (response) {
          btnEl.removeProp('disabled');
          var data  = JSON.parse(response),
              msg   = data.response;
          
          if (typeof msg === 'string') {
            var start = msg.indexOf('<title>') + 7,
                end   = msg.indexOf('</title>');
            msg = msg.substring(start, end);
          }
          formEl.after(createResponseEl(data.success, data.status, msg));
        },
        error: function (response) {
          btnEl.removeProp('disabled');
          console.log('error');
        }
      });
    });
    
  });
</script>

<style type="text/css">
  .ecp-row label,
  .ecp-row input,
  .ecp-row .tip {
    vertical-align:middle;
  }
  .ecp-row .tip {
    color:#999;
    font-size:0.7rem;
    font-style:italic;
  }
  .ecp-row .tip.error {
    color:#b44;
  }
  input[name="ecp_url"] {
    width:300px;
  }
  .ecp-update {
    background-color:#fff;
    border:1px solid #5cb85c;
    border-radius:0.3rem;
    color:#5cb85c;
    display:inline-block;
    margin-top:1rem;
    padding:0.5rem 1rem;
  }
  #ecp-purge-response .label,
  #ecp-purge-response .value {
    display:inline-block;
  }
  #ecp-purge-response .label {
    width:100px;
  }
  #ecp-purge-response div.ecp-success .value {
    color:#4b4;
  }
  #ecp-purge-response div.ecp-error .value {
    color:#b44;
  }
</style>

<?php 
  if (isset($_POST['ecp_update_options'])) {
    check_admin_referer('ecp_update', 'ecp_update_nonce');
    if (isset($_POST['ecp_secret'])) {
      $options['secret'] = $_POST['ecp_secret'];
    }
    update_option('ecp_options', $options, false);
    ?><div class="ecp-update">Settings updated</div><?php
  }
?>

<div class="wrap ecp-wrap">
  <h2>EC Purge</h2>
  
  <h3>Settings</h3>
  <form method="post" action="<?php echo esc_attr($_SERVER['REQUEST_URI']); ?>">
    <?php wp_nonce_field('ecp_update', 'ecp_update_nonce'); ?>
    <div class="ecp-row">
      <label for="ecp_secret">Secret</label>
      <input type="text" name="ecp_secret" value="<?php echo $options['secret']; ?>" />
      <span class="tip">Secret value for X-Purge-Token header.</span>
    </div>
    <div class="ecp-row submit">
      <input type="submit" class="button button-primary" name="ecp_update_options" value="Update Settings" />
    </div>
  </form>
  
  <h3>Tools</h3>
  <form id="ecp-purge-form">
    <?php wp_nonce_field('ecp_purge', 'ecp_purge_nonce'); ?>
    <div class="ecp-row">
      <label for="ecp_url">Object to purge</label>
      <input type="text" name="ecp_url" placeholder="Absolute URL" />
      <span class="tip error"></span>
    </div>
    <div class="ecp-row submit">
      <button class="button button-primary">Purge</button>
    </div>
  </form>
  
</div>