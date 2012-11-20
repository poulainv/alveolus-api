

function Websites(){
    this.ajax_get_by_id = function (websiteId,callback) {
        $.ajax({
            type: "GET",
            url: "/webapps/"+websiteId+".json"
        }).done(function( msg ) {
            callback(msg);
        });
    }

};