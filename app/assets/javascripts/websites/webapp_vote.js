$(document).ready(function(){

    var self = this;
    var settings = new Object();
    settings.message = ".msg-voting";
    settings.buttonAjax = ".ajax_trigger";


    this.updateWebSite = function(data_website){
        var website = $('.website').filter(function () {
            return  $(this).attr("data-id") == data_website.id;
        });
        website.find(".score_voting_up").html(" "+data_website.count_positive+" ");
        website.find(".score_voting_down").html(" "+data_website.count_negative+" ");
        self.switchButton(website);
        website.find(".msg-voting").show();
    }

    this.switchButton = function(website){
        //        alert(website.find(".btn-up").hasClass('disabled'));
        if(website.find(".btn-up").hasClass('disabled')){
            website.find(".btn-up").removeClass("disabled");
            website.find(".btn-down").addClass("disabled");
        }
        else{
            if(website.find(".btn-down").hasClass('disabled')){
                website.find(".btn-down").removeClass("disabled");
                website.find(".btn-up").addClass("disabled");
            }
        }
    }

    $(settings.buttonAjax).bind("ajax:success",
        function(evt, data, status, xhr){
            self.updateWebSite(data);
        }).bind("ajax:error", function(evt, data, status, xhr){
        //do something with the error here
        $("div#errors p").text(data);
    });



});