

function Bookmarks(){
    this.ajax_get_by_website_id = function(websiteId,callback1,callback2){
        // Get list tag
        $.ajax({
            type: "GET",
            url: "/webapps/"+websiteId+"/bookmarks"
        }).done(function(msg) {
        //    callback1();
        }).fail(function(msg) {
          //  callback2();
        });
    }

    this.ajax_post = function (websiteId,callback){
        $.ajax({
            type: "POST",
            url: "/webapps/"+websiteId+"/bookmarks"
        }).done(function( msg ) {
            callback();
        }).fail(function(){
            alert("Tag déjà enregisté pour ce website ou non valide")
        });
    }

 this.ajax_delete = function (websiteId,callback){
        $.ajax({
            type: "DELETE",
            url: "/webapps/"+websiteId+"/bookmarks/1"
        }).done(function() {
            callback();
        }).fail(function(){
            alert("Tag déjà enregisté pour ce website ou non valide")
        });
    }

//    this.ajax_get_tags = function(callback){
//        $.ajax({
//            type: "GET",
//            url: "/tags/index.json"
//        }).done(function( msg ) {
//            callback(msg)
//        });
//    }


}

