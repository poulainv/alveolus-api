
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
     
    });

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