

$(document).ready(function(){
    var popup = this
    var comments = new Comments();
    var websites = new Websites();
    var tags = new Tags();
    this.current_website_id = 0 ;

    // Script to excecute when open popup to update info
    $(".websiteTitle").click(function () {
        popup.current_website_id = $(this).attr("websiteId");
        // Init star rating
        popup.init_star_rating();
        $("#messageTagSaved").hide();
     
        // Get info website
        websites.ajax_get_by_id(popup.current_website_id,function (msg){
            popup.initialize_website_details(msg);
            tags.ajax_get_by_website_id(popup.current_website_id,popup.initialize_website_tags);
            popup.initialize_website_comments(msg.comments);
        });
        // Increment nb_click_detail
        increment_nb_click(popup.current_website_id, "detail");

    });
  
	
    // Si on veut faire apparaitre le caption seulement
    //  au passage de la souris sur l'image'
    this.listener_add_tag = (function(){
        $("#addTagButton").mouseover(function () {
            $("#addTagField").show();
            $("#addTagButton").hide();
            $("#messageTagSaved").hide();
        });
    })();
	
    // Send to server new Tag listener button
    this.listeneer_send_tag = (function(){
        $("#addTagSendButton").click(function () {
            console.log('click add tag')
            var newTag = $('#newTagField').val();
            tags.ajax_post(popup.current_website_id,newTag,function(msg){
                popup.initialize_website_tags(msg);
                $("#messageTagSaved").show();
            })
        });
    })();
    
    this.listener_send_comment = (function(){
        $("#addCommentSendButton").click(function () {
            console.log('click add comment')
            var newComment = $('#newCommentField').val();
            var newRating = $('#star_rating_user').raty('score');
            comments.ajax_post(popup.current_website_id, newRating,newComment,popup.initialize_website_comments);
        });
    })();

    // METHODS DECLARATION
	
    this.init_star_rating = function(){
        $('#star_rating_user').raty({
            size      : 36,
            starHalf  : 'star-half-big.png',
            starOff   : 'star-off-big.png',
            starOn    : 'star-on-big.png',
            target     : '#target',
            targetText : '--',
            targetKeep : true
        });
    }
	
    // Update comments in popup detail
    // Ultra crade
    this.initialize_website_comments = function(comments){

        $("#detailWebsiteModalComments").html('')
        $("#newCommentField").val('');
        var comment ="";
        jQuery.each(comments, function(i, val) {
            comment = "<div class='row-fluid'>"+
            "<div class='span6'><em>"+
            val.user.email+
            "</em> </div>"+
            "<div class='span4'>"+
            manage_star_rating(val.rating,"/img/googlestar.png","/img/googlestar-off.png")+
            "</div>"+
            "</div>"+
            "<div class='row-fluid'>"+
            "<div class='span12' style=' border-bottom:1px dotted #999999;margin-bottom:5%;padding-bottom : 3%'>"+
            val.body
            "</div>"+
            "</div> "

            $("#detailWebsiteModalComments").append(comment);

        });

    }

    // Update details website in popup detail
    this.initialize_website_details = function(website){
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
        $('#detailWebsiteModalRating').html(manage_star_rating(website.average_rate,"/img/googlestar.png","/img/googlestar-off.png"));
        // Listener when URL is clicked
        $(".websiteurl").click(function () {
            increment_nb_click(websiteId,"url")
        });
    }

    // Update tags in popup detail
    this.initialize_website_tags = function(tags){
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
});


function manage_star_rating(n,path_on,path_off){
    var res ="";
    var title = "Note moyenne obtenue : "+n;
    var star_on = "<img class='custom_inline' src='"+path_on+"' title='"+title+"'></img>";
    var star_off = "<img class='custom_inline' src='"+path_off+"' title='"+title+"'></img>";
    var i =0;
    for(i=0;i<5;i++){
        if(i<Math.round(n)){
            res+=star_on;
        }
        else{
            res+=star_off;
        }
    }
    return res;
}