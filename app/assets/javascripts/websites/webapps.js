

function Websites(){
    this.ajax_get_by_id = function (websiteId,callback) {
        $.ajax({
            type: "GET",
            url: "/webapps/"+websiteId+".json"
        }).done(function( msg ) {
            callback(msg);
        });
    }

    this.ajax_get_for_tag_id = function (tagId,callback) {
        $.ajax({
            type: "GET",
            url: "/tags/"+tagId+"/webapps.json"
        }).done(function( msg ) {
            callback(msg);
        });
    }

    this.ajax_get_by_title = function (title,callback) {
        $.ajax({
            type: "GET",
            url: "/webapps.json?search="+title
        }).done(function( msg ) {
            callback(msg);
        });
    }

};