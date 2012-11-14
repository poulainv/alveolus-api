

$(document).ready(function(){



    // Script to excecute when open popup to update info
    $(".websitetop").click(function () {
        var websiteId = $(this).attr("websiteId");
        $.ajax({
            type: "GET",
            url: "/webapps/"+websiteId+".json"
        }).done(function( msg ) {
            initialize_website_details(msg)      
        });
  
        // Increment nb_click_detail
        increment_nb_click(websiteId, "detail");

    });
});


function initialize_website_details(website){
    $("#detailWebsiteModalTitle").html(website.title)
    $("#detailWebsiteModalDescription").html(website.description)
    $("#detailWebsiteModalNbVues").html("Nombre de vues : "+website.nb_click_detail)
    $("#detailWebsiteModalCaption").html(website.caption)
    $("#detailWebsiteModalURL").html(website.url)
    $("#detailWebsiteModalURL").attr("href",website.url)
    $("#detailWebsiteModal").attr("websiteId",website.id)
    $("#detailWebsiteModalImage").attr("src",website.image)
    $("#detailWebsiteModalEdit").attr("href","/webapps/"+website.id+"/edit")
    $("#detailWebsiteModalTagsList").empty()

    for (x in website.tags)
    {
        $("<a/>", {
            "class": "btn btn-info btn-small",
            text: website.tags[x].name,
            type: "button",
            style: "color:white",
            href: "/webapps/tag/"+website.tags[x].name,
            click: function(){
                $('#detailWebsiteModal').modal("hide");
            }
        }).appendTo("#detailWebsiteModalTagsList");
        $("<br>").appendTo("#detailWebsiteModalTagsList");
        $("<br>").appendTo("#detailWebsiteModalTagsList");
    }

    // Listener when URL is clicked
    $(".websiteurl").click(function () {
        increment_nb_click(websiteId,"url")
    });
}