
$(document).ready(function(){

        var pathname = window.location.pathname;
        $(".navbar-fixed-top").find("li").removeClass("active");
        if(pathname.indexOf("suggestion")!=-1){
           $("#top-suggestion").addClass("active");
        }
        else if(pathname.indexOf("vote")!=-1){
          $("#top-vote").addClass("active");
        }
        else if(pathname.indexOf("about")!=-1){
          $("#top-valeurs").addClass("active");
        }
        else if(pathname.indexOf("random")!=-1){
          $("#top-aleatoire").addClass("active");
        }
        else {
           $("#top-home").addClass("active");
        }
});