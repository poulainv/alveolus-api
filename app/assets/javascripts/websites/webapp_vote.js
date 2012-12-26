$(document).ready(function(){

    var self = this;
    var settings = new Object();
    settings.message = ".msg-voting";
    settings.buttonAjax = ".ajax_trigger";

    this.updateWebSite = function(data_website){
        var website = $(".website").filter(function () {
            return  $(this).attr("data-id") == data_website.id;
        });
        website.find(".score_voting_up").html(" "+data_website.count_positive+" ");
        website.find(".score_voting_down").html(" "+data_website.count_negative+" ");
        website.find(".msg-voting").show();
        website.find(".img-spinner").hide();
    }

    this.switchButton = function(website,type){
        if(type=="down"){
            website.find(".btn-up").removeClass("disabled");
            website.find(".btn-down").addClass("disabled");
        }
        else{
            if(type=="up"){
                website.find(".btn-down").removeClass("disabled");
                website.find(".btn-up").addClass("disabled");
            }
        }
    }

    $(settings.buttonAjax).bind("ajax:success",
        function(evt, data, status, xhr){
            self.updateWebSite(data);
        }).bind("ajax:error", function(evt, data, status, xhr){
        alert(data);
    }).bind("ajax:beforeSend", function(evt, xhr, settings){
        var url = settings.url;
        var websiteId=url.match(/[1234567890]/g).toString().replace(',','');
        var website = $(".website").filter(function () {
            return  $(this).attr("data-id") == websiteId;
        });
        website.find(".img-spinner").show();

        // Switch buttons like/dislike
        if(url.indexOf("up")!=-1){
            self.switchButton(website,"up");
        }
        else{
            self.switchButton(website,"down");
        }
        
    });
});