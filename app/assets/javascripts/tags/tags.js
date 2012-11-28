

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
        }).fail(function(){
            alert("Tag déjà enregisté pour ce website ou non valide")
        });
    }

    this.ajax_get_tags = function(callback){
        $.ajax({
            type: "GET",
            url: "/tags/index.json"
        }).done(function( msg ) {
            callback(msg)
        });
    }


    this.ajax_get_tags_associated = function(tagId,callback){
        $.ajax({
            type: "GET",
            url: "/tags/"+tagId+"/associated.json"
        }).done(function( msg ) {
            callback(msg)
        });
    }
}

