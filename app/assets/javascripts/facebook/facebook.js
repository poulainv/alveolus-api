function Facebook_API() {

    this.ajax_get_for_name = function (name,callback) {
        $.ajax({
            type: "GET",
            url: "https://graph.facebook.com/"+name
        }).fail(function(msg) {
            callback(msg );
        })
        .done(function(msg) {
            callback("Oops");
        });
    }


}
