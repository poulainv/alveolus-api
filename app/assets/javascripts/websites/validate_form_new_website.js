$(document).ready(function(){
    $("#new_webapp").validate({
        rules: {
	      "webapp[title]": {
	        minlength: 3,
                  maxlength: 25,
	        required: true
	      },
                "webapp[caption]": {
	        minlength: 30,
                  maxlength: 170,
	        required: true
	      },
                "webapp[description]": {
	        minlength: 100,
                  maxlength: 450,
	        required: true
	      },
                "webapp[url]": {
                  url : true,
	        required: true
	      },
                "webapp[photo]": {
                 accept: "jpeg|jpg|png|gif"
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