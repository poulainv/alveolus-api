$(document).ready(function(){
    $("#new_user").validate({
        rules: {
	      "user[email]": {
	        email : true,
	        required: true
	      },
                "user[password]": {
	        minlength: 6,
	        required: true
	      },
                "user[password_confirmation]": {
	        minlength: 6,
	        required: true,
                  equalTo: "#user_password"
	      }
        },
	    highlight: function(label) {
                    console.log($(label).siblings('.help-inline'));
	    	$(label).closest('.control-group').addClass('error');
                    $(label).closest('.control-group').removeClass('success');
                    $(label).siblings('.help-inline').show();
	    },
              unhighlight: function(label) {
	    	$(label).closest('.control-group').removeClass('error');
                    $(label).closest('.control-group').addClass('success');
                   $(label).siblings('.help-inline').hide();
	    },
              errorPlacement: function(label){

              }
    });

});