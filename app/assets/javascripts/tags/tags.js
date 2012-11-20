

function Tags(){
	this.ajax_get_by_website_id = function(websiteId,callback){
	    // Get list tag
	    $.ajax({
	        type: "GET",
	        url: "/webapps/"+websiteId+"/tags"
	    }).done(function( msg ) {
	        callback(msg);
	    });
	}
	
	this.ajax_post = function (websiteId, newTag, callBack){
		$.ajax({
        	type: "POST",
        	data : {
            	tag : newTag
        	},
        	url: "/webapps/"+websiteId+"/tags"
    	}).done(function( msg ) {
        	callBack(msg);
    	});
	}
}

