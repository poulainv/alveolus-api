
var popupWebSite;
$(document).ready(function(){
    popupWebSite = new PopupWebSite();
});

function PopupWebSite(){
    var popup = this
    var comments = new Comments();
    var bookmarks = new Bookmarks();
    var tags = new Tags();
    var settings = new Object();
    var facebookApi = new Facebook_API();

    settings.bookmark_star = "#bookmark";
    settings.bookmarked = false ;
    settings.bookmark_image = "/img/star-on-big"
    settings.modal = "#website-modal" ;
    settings.messageTagSaved = "#messageTagSaved";
    settings.messageCommentSaved = "#messageCommentSaved";
    settings.star_rating_user = "#star_rating_user";
    settings.websiteTitle = ".websiteTitle";
    settings.facebook_like = "#nb-fb-like"
    settings.facebookId = "";

    this.current_website_id = 0 ;
    this.current_comment_id = 0 ;
    this.website_info = null;
    
    // Listener for website title click => open/show POPUP detail
    this.main = function(){$(settings.websiteTitle).click(function(){
        $('.spinner').show();
     
      
        // Get website ID
        popup.current_comment_id = 0 ;
        popup.current_website_id = $(this).attr("websiteId");

        $("#detailWebsiteModalTEST").load("/webapps/"+popup.current_website_id,null,function(){
             $('.spinner').hide();
             $(settings.modal).modal('show');
            popup.listenerWebSiteTitle();
            popup.listener_send_tag();
            popup.initialize_buttons_tags();
            popup.listener_edit_comment();
            popup.listener_send_comment_put();
            popup.listener_send_comment_post();
            popup.listenerTwitterButton();
            popup.listenerFacebookButton();
            popup.listenerGooglePlusButton();
            popup.listenerUrl();
            popup.listener_bookmark();
            popup.displayLikeFaceBook();
           
      
        })
    });

    };
    // Script to excecute when open popup to update info
    this.listenerWebSiteTitle = function(){

        // Init star rating
        popup.init_star_rating();
        
        $(settings.messageTagSaved).hide();
        $(settings.messageCommentSaved).hide();

        this.ajax_get_comment_for_current_user = (function(){
            comments.ajax_get_by_website_id_for_user_sign_in(popup.current_website_id,1 ,function(msg){
                popup.initialize_own_comment(msg);
            });
        })();
    }

    
    this.listenerFacebookButton = function (){
        console.log("lister FB");
        $('#share_facebook').click(function(){
            // We have to change attribute's name 'preview' into 'shared' in database
            increment_nb_click(popup.current_website_id,"shared");
            FB.ui(
            {
                method: 'feed',
                name: $(settings.modal).data("title"),
                link:  $(settings.modal).data("url"),
                caption: $(settings.modal).data("caption"),
                message: "J'ai découvert ça sur EnjoyTheWeb, ça peut vous intéresser !"
            });
        });
        // Init tooltip for Facebook
        $('#share_facebook').tooltip({
            title	: "Partager ce site sur Facebook",
            placement : 'bottom'
        });

    };

    this.listenerGooglePlusButton = function (){
        // Init tooltip for Facebook
        $('#share_google').tooltip({
            title	: "Bientôt...",
            placement : 'bottom'
        });

    };

    this.listenerTwitterButton = function (){
        // Init tooltip for Facebook
        $('#share_twitter').tooltip({
            title	: "Bientôt...",
            placement : 'bottom'
        });

    };

    this.displayLikeFaceBook = function (){
        settings.facebookId = $(settings.facebook_like).data('facebook-id');
        if(settings.facebookId!=""){
            facebookApi.ajax_get_for_name(settings.facebookId, function(msg){
                $(settings.facebook_like).html(JSON.parse(msg.responseText).likes);
            })}
    };

    this.listener_bookmark = function (){
        //  Listener
        if($(settings.bookmark_star).attr('src')== settings.bookmark_image){
            settings.bookmark = true;
        }else {
            settings.bookmark=false;
        }
        $(settings.bookmark_star).click(function(){
            console.log("bookmarked");
            if(settings.bookmarked == false){
                bookmarks.ajax_post(popup.current_website_id, function(){
                    $(settings.bookmark_star).attr('src',"/img/star-on-big.png")
                    settings.bookmarked = true;
                });
            }
            else {
                bookmarks.ajax_delete(popup.current_website_id, function(){
                    $(settings.bookmark_star).attr('src',"/img/star-off-big.png")
                    settings.bookmarked = false;
                });
            }
        });

    };


    // Send to server new Tag listener button
    this.listener_send_tag = function(){
        $("#addTagSendButton").click(function () {
            console.log('click add tag')
            var newTag = $('#newTagField').val();
            if(newTag!='' || newTag.length > 30){
                tags.ajax_post(popup.current_website_id,newTag,function(msg){
                    popup.initialize_buttons_tags(msg);
                    $("#messageTagSaved").show();
                })
            } else {
                alert("Etes-vous sûr que c'est un tag correct ?")
            }
        });
        
        $("#addTagButton").mouseover(function () {
            $("#addTagField").show();
            $("#addTagButton").hide();
            $("#messageTagSaved").hide();
        });
    }

    // Send to server NEW comment
    this.listener_send_comment_post = function(){
        $("#addCommentSendButton").click(function () {
            var newComment = $('#newCommentField').val();
            var newRating = $('#star_rating_user').raty('score');
            console.log('click add new comment')
            if(popup.check_star_rating(newRating) == false) return;
            comments.ajax_post(popup.current_website_id, newRating,newComment,function(msg){
      
                $("#detailWebsiteModalComments").html(msg)
            });
            $("#messageCommentSaved").show();
            // $('#addCommentEditButton').show();
            $('#newCommentField').hide();
            $(this).hide();
        });
    };

    // Send to server comment edited
    this.listener_send_comment_put = function(){
        $("#addCommentSendButtonPut").click(function () {
            console.log('click edit comment')
            var newComment = $('#newCommentField').val();
            var newRating = $('#star_rating_user').raty('score');
            if(popup.check_star_rating(newRating) == false) return;
            comments.ajax_edit(popup.current_comment_id, newRating,newComment,function(msg){
                $("#detailWebsiteModalComments").html(msg)
            });
            $("#messageCommentSaved").show();
            $('#addCommentEditButton').show();
            $('#newCommentField').hide();
            $(this).hide();
        });
    };

    // Listener to edit an old comment
    this.listener_edit_comment = function(){
        $("#addCommentEditButton").click(function () {
            $('#addCommentSendButtonPut').show();
            $("#messageCommentSaved").hide();
            $('#newCommentField').show();
            $(this).hide();
        });
    };


    // METHODS DECLARATION
    this.init_star_rating = function(){
        console.log("raty STARING")
        $(settings.star_rating_user).raty({
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

    this.listenerUrl = function(){
        // Listener when URL is clicked
        $(".websiteurl").click(function () {
            increment_nb_click(popup.current_website_id,"url")
        });
    }

    // Update tags in popup detail
    this.initialize_buttons_tags = function(){
        $("#addTagButton").show();
        $("#addTagField").hide();
        $("#detailWebsiteModalTagsList").html('');
        $("#newTagField").val('');
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


    this.main();
    
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
