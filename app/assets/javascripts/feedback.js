/*
 * Feedback (for jQuery)
 * version: 0.1 (2009-07-21)
 * @requires jQuery v1.3 or later
 *
 * This script is part of the Feedback Ruby on Rails Plugin:
 *   http://
 *
 * Licensed under the MIT:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright 2009 Jean-Sebastien Boulanger [ jsboulanger@gmail.com ]
 *
 * Usage:
 *
 *  jQuery(document).ready(function() {
 *    jQuery('#feedback_tab_link').feedback({
 *      // options
 *    });
 *  })
 *
 */
$(document).ready(function(){

  var settings = new Object();
  
  settings.form = "#feedback_form";
  settings.formUrl = '/feedback/new';
  
  settings.feedbackContent = "#feedbackContent";
  settings.statusMessage = "#statusMessage";
  settings.sendingText = "Envoi en cours..."
  settings.sendButton = "#sendFeedback";
  settings.feedbackModal = "#feedback_modal";
  settings.feedbackWindow = "#feedback_window";

  settings.spinner = "#img-spinner_feedback";
  
  $("#feedback_link").click(function(){
      console.log("Click feedback");
      $(settings.feedbackWindow).load(settings.formUrl,null,function(){
          $(settings.feedbackModal).modal('show');
          $('#feedback_form').submit(submitFeedback);
      });
     
  })



  var submitFeedback = function() {
		$('input[name=feedback\\[page\\]]').val(location.href);
    var data = $(settings.form).serialize();
    var url = $.trim($(settings.form).attr('action'));
    message_user(settings.sendingText);
    $(settings.spinner).show();
    $.ajax({
      type: "POST",
      url: url,
      data: data,
      success: function(msg, status) {
           message_user(msg);
           $(settings.spinner).hide();
           window.setTimeout(hideModal, 1500);
      },
      error: function(xhr, status, a) {
         message_user(xhr.responseText);
      }
    });
    return false;
  }

  var hideModal = function(){
    $(settings.feedbackModal).modal('hide');
  }

  var message_user = function(text){
     
       $(settings.feedbackContent).hide(200);
        $(settings.statusMessage).html(text);
        $(settings.sendButton).hide();
}



 
});