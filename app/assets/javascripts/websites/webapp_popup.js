

$(document).ready(function(){
    popupWebSite = new PopupWebSite();
});

function PopupWebSite(){
    var popup = this
    var comments = new Comments();
    var websites = new Websites();
    var tags = new Tags();
    this.current_website_id = 0 ;
    this.current_comment_id = 0 ;
    this.website_info = null;
 
    // Script to excecute when open popup to update info
    this.listenerWebSiteTitle = function(){
        console.log("listener");
        $('.spinner').show();

        popup.current_comment_id = 0 ;
        popup.current_website_id = $(this).attr("websiteId");
        // Init star rating
        popup.init_star_rating();
        $("#messageTagSaved").hide();
        $("#messageCommentSaved").hide();

        // Get info website
        websites.ajax_get_by_id(popup.current_website_id,function (msg){
            popup.website_info = msg ;
            popup.initialize_website_details(msg);
            popup.initialize_website_comments(popup.current_website_id);
            popup.initialize_website_tags(msg.best_tags);
            $('.spinner').hide();
            $('#detailWebsiteModal').modal('show');
        });

        this.ajax_get_comment_for_current_user = (function(){
            comments.ajax_get_by_website_id_for_user_sign_in(popup.current_website_id,1 ,function(msg){
                popup.initialize_own_comment(msg);
            });
        })();
        // Increment nb_click_detail
        // => now is automaticly increment when method show of webapp controller is called
       // increment_nb_click(popup.current_website_id, "detail");
    }

    this.listenerFacebookButton = (function (){
        console.log("sharing on facebook...");
        $('#share_facebook').click(function(){
            // We have to change attribute's name 'preview' into 'shared' in database
              increment_nb_click(popup.current_website_id,"shared");
            FB.ui(
            {
                method: 'feed',
                name: popup.website_info.title,
                link:  popup.website_info.url,
                picture: popup.website_info.photo,
                caption: popup.website_info.caption,
                message: "J'ai découvert ça sur EnjoyTheWeb, ça peut vous intéresser !"
            });
        });


        // Listener for website title click => open/show POPUP detail
        $(".websiteTitle").click(popup.listenerWebSiteTitle);


        // Init tooltip for Facebook
        $('#share_facebook').tooltip({
            title	: "Partager ce site sur Facebook",
            placement : 'bottom'
        });

    })();


    this.listenerGooglePlusButton = (function (){
        // Init tooltip for Facebook
        $('#share_google').tooltip({
            title	: "Bientôt...",
            placement : 'bottom'
        });

    })();


    this.listenerTwitterButton = (function (){
        // Init tooltip for Facebook
        $('#share_twitter').tooltip({
            title	: "Bientôt...",
            placement : 'bottom'
        });

    })();

	
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
    this.listener_send_tag = (function(){
        $("#addTagSendButton").click(function () {
            console.log('click add tag')
            var newTag = $('#newTagField').val();
            if(newTag!='' || newTag.length > 30){
                tags.ajax_post(popup.current_website_id,newTag,function(msg){
                    popup.initialize_website_tags(msg);
                    $("#messageTagSaved").show();
                })
            } else {
                alert("Etes-vous sûr que c'est un tag correct ?")
            }
        });
    })();

    // Send to server NEW comment
    this.listener_send_comment_post = (function(){
        $("#addCommentSendButton").click(function () {
            var newComment = $('#newCommentField').val();
            var newRating = $('#star_rating_user').raty('score');
            console.log('click add new comment')
            if(popup.check_star_rating(newRating) == false) return;
            comments.ajax_post(popup.current_website_id, newRating,newComment,popup.initialize_website_comments);
            $("#messageCommentSaved").show();
            // $('#addCommentEditButton').show();
            $('#newCommentField').hide();
            $(this).hide();
        });
    })();

    // Send to server comment edited
    this.listener_send_comment_put = (function(){
        $("#addCommentSendButtonPut").click(function () {
            console.log('click edit comment')
            var newComment = $('#newCommentField').val();
            var newRating = $('#star_rating_user').raty('score');
            if(popup.check_star_rating(newRating) == false) return;
            comments.ajax_edit(popup.current_comment_id, newRating,newComment,popup.initialize_website_comments);
            $("#messageCommentSaved").show();
            $('#addCommentEditButton').show();
            $('#newCommentField').hide();
            $(this).hide();
        });
    })();

    // Listener to edit an old comment
    this.listener_edit_comment = (function(){
        $("#addCommentEditButton").click(function () {
            $('#addCommentSendButtonPut').show();
            $("#messageCommentSaved").hide();
            $('#newCommentField').show();
            $(this).hide();
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

        // Init tooltip for error
        $('#star_rating_user').tooltip({
            title	: "Vous devez obligatoirement laissez une note",
            trigger : 'manual'
        });
		
        // Hide tooltip when mouse over
        $('#star_rating_user').mouseover(function(){
            $(this).tooltip('hide');
        });
	
    }

    this.initialize_own_comment = function(comment){
        // If current have already commented
        if(comment!="" && comment != null && comment != undefined){
            console.log("already commented => init for edit");
            popup.current_comment_id = comment.id
            $('#addCommentSendButton').hide();
            $('#addCommentSendButtonPut').hide();
            $('#newCommentField').hide();
            $('#addCommentEditButton').show();
            $('#star_rating_user').raty('score',comment.rating);
            $('#newCommentField').val(comment.body);
        }
        // If he didn't comment
        else{
            popup.current_comment_id = 0;
            console.log("not commented => init for add")
            $('#newCommentField').val('');
            $('#addCommentSendButton').show();
            $('#addCommentSendButtonPut').hide();
            $('#newCommentField').show();
            $('#addCommentEditButton').hide();
        }
    }

    // Update comments in popup detail
    // Ultra crade
    this.initialize_website_comments = function(websiteId){
    if(websiteId==null){
        websiteId=popup.current_website_id;
    }
        $("#detailWebsiteModalComments").html('')
        $("#detailWebsiteModalComments").load("webapps/"+websiteId+"/comments");
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
        $('#detailWebsiteModalRating').append("<em> ("+website.nb_rating+")</em>");

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
	
    this.check_star_rating = function(score){
        if(score==null || undefined == score){
            // Display tooltip
            $('#star_rating_user').tooltip('show');
            return false;
        }
        else{
            return true;
        }
    }
}


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