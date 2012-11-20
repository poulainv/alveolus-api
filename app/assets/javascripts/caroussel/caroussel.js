$(document).ready(function(){

// Si on veut faire apparaitre le caption seulement
//  au passage de la souris sur l'image'
        $(".carousel-caption").hide();
        $(".item").mouseover(function () {
            $(".carousel-caption").show(0);
        });
        $(".item").mouseout(function () {
            $(".carousel-caption").hide(0);
        });

});