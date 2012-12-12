$(document).ready(function(){

    var settings = new Object();
    settings.video = "#carousel-video";
    settings.image = "#carousel-image";
    settings.buttonVideo = ".carousel-video-button";
    settings.carousel = "#carousel_main";
    var websiteId;
 
    $(settings.buttonVideo).click(function(){
        websiteId = $(this).data('website');
 
        if(!$(settings.video+''+websiteId).is(':visible')){
            $(settings.image+''+websiteId).hide();
            $(settings.video+''+websiteId).show();
            $(settings.carousel).carousel('pause');
        }
//        else{
//            $(settings.image+''+websiteId).show();
//            $(settings.video+''+websiteId).hide();
//            $(settings.carousel).carousel('play');
//        }
    });



});