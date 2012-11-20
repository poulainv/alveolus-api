 function Comments(){

	this.ajax_get_by_website_id = function (websiteId, callback){
	    $.ajax({
	        type: "GET",
	        url: "/webapps/"+websiteId+"/comments"
	    }).done(function( msg ) {
	        callback(msg);
	    });
	}

          this.ajax_get_by_website_id_for_user_sign_in = function (websiteId, userId, callback){
	    $.ajax({
	        type: "GET",
	        url: "users/"+userId+"/webapps/"+websiteId+"/comments.json"
	    }).done(function( msg ) {
	        callback(msg);
	    });
	}
	
	this.ajax_post = function(websiteId, newRating, newComment, callback){
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

          this.ajax_edit = function(commentId, newRating, newComment, callback){

		$.ajax({
		            type: "PUT",
		            data : {
		                comment : newComment,
		                rating : newRating
		            },
		            url: "/comments/"+commentId
		        }).done(function( msg ) {
		            callback(msg);
		        }).fail(function() {
		            alert('Vous avez déjà publiez pour ce site');
		        });

	}

}