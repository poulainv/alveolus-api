

$(document).ready(function(){


    // Script to excecute when open popup to update info
    $(".websitetop").click(function () {
        var websiteId = $(this).attr("websiteId");
         $("#messageTagSaved").hide();
        // Get info website
        $.ajax({
            type: "GET",
            url: "/webapps/"+websiteId+".json"
        }).done(function( msg ) {
            initialize_website_details(msg)
        });

        // Get list tag
        $.ajax({
            type: "GET",
            url: "/webapps/"+websiteId+"/tagslist"
        }).done(function( msg ) {
            initialize_website_tags(msg)
        });

  
        // Increment nb_click_detail
        increment_nb_click(websiteId, "detail");

    });
  
    // Si on veut faire apparaitre le caption seulement
    //  au passage de la souris sur l'image'
    $("#addTagButton").mouseover(function () {
        $("#addTagField").show();
        $("#addTagButton").hide();
        $("#messageTagSaved").hide();
    });


    $("#addTagSendButton").click(function () {
        console.log('click add')
        var websiteId = $('#detailWebsiteModal').attr("websiteId");
        var newTag = $('#newTagField').val();
        $.ajax({
            type: "POST",
            url: "/webapps/"+websiteId+"/addtag/"+ newTag
        }).done(function( msg ) {
            initialize_website_tags(msg);
            $("#messageTagSaved").show();
        });

    });



});


function initialize_website_details(website){
    $("#detailWebsiteModalTitle").html(website.title);
    $("#detailWebsiteModalDescription").html(website.description);
    $("#detailWebsiteModalNbVues").html("Nombre de vues : "+website.nb_click_detail);
    $("#detailWebsiteModalCaption").html(website.caption);
    $("#detailWebsiteModalURL").html(website.url);
    $("#detailWebsiteModalURL").attr("href",website.url);
    $("#detailWebsiteModal").attr("websiteId",website.id);
    $("#detailWebsiteModalImage").attr("src",website.image);
    $("#detailWebsiteModalEdit").attr("href","/webapps/"+website.id+"/edit");
    $("#detailWebsiteModalTagsList").empty();

    initialize_website_tags(website.tags);

    // Listener when URL is clicked
    $(".websiteurl").click(function () {
        increment_nb_click(websiteId,"url")
    });
}

function initialize_website_tags(tags){

    $("#addTagButton").show();
    $("#addTagField").hide();
    $("#detailWebsiteModalTagsList").html('');
    $("#newTagField").val('');
    for (x in tags)
    {
        $("<a/>", {
            "class": "btn btn-info btn-small",
            text: tags[x].name,
            type: "button",
            style: "color:white",
            href: "/webapps/tag/"+tags[x].name,
            click: function(){
                $('#detailWebsiteModal').modal("hide");
            }
        }).appendTo("#detailWebsiteModalTagsList");
        $("<br>").appendTo("#detailWebsiteModalTagsList");
        $("<br>").appendTo("#detailWebsiteModalTagsList");
    }

}