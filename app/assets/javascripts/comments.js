


 function Comments(){

	this.ajax_get_by_website_id = function (websiteId, callback){
	    $.ajax({
	        type: "GET",
	        url: "/webapps/"+websiteId+"/comments"
	    }).done(function( msg ) {
	        callback(msg);
	    });
	}
	
	this.ajax_post = function(websiteId, newRating, newComment, callback){
              alert("send");
		$.ajax({
		            type: "POST",
		            data : {
		                comment : newComment,
		                rating : newRating
		            },
		            url: "/webapps/"+websiteId+"/comments"
		        }).done(function( msg ) {
		            callback(msg);
		        }).fail(function() {
		            alert('Vous avez déjà publiez pour ce site');
		        });
		
	}

}