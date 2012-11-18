

$(document).ready(function(){


    // Script to excecute when open popup to update info
    $(".websitetop").click(function () {

        $('#star_rating_user').raty({
            size      : 36,
            starHalf  : 'star-half-big.png',
            starOff   : 'star-off-big.png',
            starOn    : 'star-on-big.png',
            target     : '#target',
            targetText : '--',
            targetKeep : true
        });

        var websiteId = $(this).attr("websiteId");
        $("#messageTagSaved").hide();
        // Get info website
        $.ajax({
            type: "GET",
            url: "/webapps/"+websiteId+".json"
        }).done(function( msg ) {
            initialize_website_details(msg);
            ajaxGetTags(websiteId);
            initialize_website_comments(msg.comments);
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
        console.log('click add tag')
        var websiteId = $('#detailWebsiteModal').attr("websiteId");
        var newTag = $('#newTagField').val();
        $.ajax({
            type: "POST",
            data : {
                tag : newTag
            },
            url: "/webapps/"+websiteId+"/tags"
        }).done(function( msg ) {
            initialize_website_tags(msg);
            $("#messageTagSaved").show();
        });

    });

    $("#addCommentSendButton").click(function () {
        console.log('click add comment')
        var websiteId = $('#detailWebsiteModal').attr("websiteId");
        var newComment = $('#newCommentField').val();
        var newRating = $('#star_rating_user').raty('score');
        $.ajax({
            type: "POST",
            data : {
                comment : newComment,
                rating : newRating
            },
            url: "/webapps/"+websiteId+"/comments"
        }).done(function( msg ) {
            initialize_website_comments(msg);
        }).fail(function() {
            alert('Vous avez déjà publiez pour ce site');
        })

    });



});


function ajaxGetTags(websiteId){
    // Get list tag
    $.ajax({
        type: "GET",
        url: "/webapps/"+websiteId+"/tags"
    }).done(function( msg ) {
        initialize_website_tags(msg);
        
    });
}

function ajaxGetComments(websiteId){
    // Get list comment
    $.ajax({
        type: "GET",
        url: "/webapps/"+websiteId+"/comments"
    }).done(function( msg ) {
        initialize_website_comments(msg);
    });
}


// Update details website in popup detail
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
    $('#favicons_website').attr("src","http://www.google.com/s2/favicons?domain="+website.url.substring(7,website.url.length-1))
    initialize_website_tags(website.tags);

    // Listener when URL is clicked
    $(".websiteurl").click(function () {
        increment_nb_click(websiteId,"url")
    });
}

// Update tags in popup detail
function initialize_website_tags(tags){

    $("#addTagButton").show();
    $("#addTagField").hide();
    $("#detailWebsiteModalTagsList").html('');
    $("#newTagField").val('');
    for (x in tags)
    {
        $("<a/>", {
            "class": "btn btn-info btn-small tabBtn",
            text: tags[x].name,
            type: "button",
            style: "color:white",
            href: "/tags/"+tags[x].id+"/webapps",
            click: function(){
                $('#detailWebsiteModal').modal("hide");
            }
        }).appendTo("#detailWebsiteModalTagsList");
    }

    $(".tabBtn").after('<br></br>');


}

// Update comments in popup detail
// Ultra crade
function initialize_website_comments(comments){

    $("#detailWebsiteModalComments").html('')
    $("#newCommentField").val('');
     var comment ="";
    jQuery.each(comments, function(i, val) {
      
      
        comment = "<div class='row-fluid'>"+
        "<div class='span6'><em>"+
        val.user.email+
        "</em> </div>"+
        "<div class='span4'>"+
        multiplicateString(val.rating,"<img src='img/googlestar.png'></img>")+
        "</div>"+

        "</div>"+

        "<div class='row-fluid'>"+
        "<div class='span12' style=' border-bottom:1px dotted #999999;margin-bottom:5%;padding-bottom : 3%'>"+
        val.body
        "</div>"+
        "</div> "

        $("#detailWebsiteModalComments").append(comment);


    // /  $("<p/>", {
    //    "class" : "commentText custom_inline",
    //      text: val.body
    //    }).appendTo("#detailWebsiteModalComments")
    //      .before('<em>'+val.user.email+': </em>')
    //        .after("<img src='img/googlestar.png'></img>")

        

    });

}

  function multiplicateString(n,html){
        var res ="";
        var i =0;
        for(i=0;i<n;i++){
            res+=html;
        }
        return res;
    }