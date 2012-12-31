var Cloud = function(){

    var cloudtags = this
    var tag = new Tags();
    var website = new Websites();
    var settings = new Object();
    settings.behaviorSelected = "websites";
    settings.radioWebsites = "#optionWeb";
    settings.radioTags = "#optionTag";

    this.keycuts_manager = (function(){
        $("body").keydown(function(event) {
            // alert(event.which);
            if(event.which==80){
                $(settings.radioWebsites).attr('checked',undefined);
                $(settings.radioTags).attr('checked','checked');
            }
        });
        $("body").keyup(function(event) {
            if(event.which==80){
                $(settings.radioTags).attr('checked',undefined);
                $(settings.radioWebsites).attr('checked','checked');
            }
        });
    })();

    this.init_tags_cloud = (function(tags){
        var tagCloud = $("#tagsCloud").html('')
        var tagElement;
        console.log('Init cloud...');
        fisherYates(tags);
        var temp = 0 ;
        for (x in tags)
        {

            var coeffSize = 100+tags[x].poid*tags[x].poid*20;
           if(coeffSize>300){
               coeffSize=300;
           }
            // Geneate tag
            var tagP = $("<span/>", {
                "tagId": tags[x].id,
                'class':'tagCloud',
                html: "<span class='tagName'>"+tags[x].name+"</span>",
                style : "margin : 5% 5% 5% 5%; font-size:"+coeffSize+"%; padding-right:1%; ",
                click : function(event){

                    if($(settings.radioWebsites).attr('checked')=="checked"){
                        cloudtags.displayWebsites(this);
                    }else{
                        cloudtags.displayTags(this);
                    }
                }
               
            }).appendTo(tagCloud).popover({
                'animation': 	false,
                'placement': 	'right',
                'html'      :         true,
                'trigger'  : 	'manual',
                'title'    :          'Websites associés',
                'content'  : 	function(){
                    return $('#websitesCloud').html()
                }
            });

            if(x%3==0){
                tagP.append("<br>");
                 temp = 0;
            }
            else if(tags[x-1] != undefined && tags[x-1] != null){
               //  console.log("sum :"+coeffSize+temp);
                if(coeffSize+temp>550){
                    console.log("tag too big");
                    tagP.append("<br>");
                   
                }
                else{
                    temp = coeffSize;
                }
            }
           
            

        }

        $('#tagsCloud').show(600);
    });

    this.displayWebsites = function(tag){
        tagElement =   $(tag);
        website.ajax_get_for_tag_id($(tag).attr('tagId'),function(msg){
           
            cloudtags.init_websites_list(msg);
            tagElement.popover('show');
            popupWebSite.initialize(".websitePr");
            popupClicked = true;
        });
    }

    this.displayTags = function(current_tag){
        $('#tagsCloud').hide(600);
        tag.ajax_get_tags_associated($(current_tag).attr('tagId'),cloudtags.init_tags_cloud)
    }

    this.init_websites_list = (function(websites){

        var websiteCloud = $("#websitesCloud").html('')
        console.log('Init websites cloud...');

        for (x in websites)
        {

            var websitePreview =
            "<div class='row-fluid websitePr' websiteId='"+websites[x].id+"'>"+

            "<div class='span6'>"+
            "<img src='"+websites[x].preview+"'</img>"+
            "</div>"+
            "<div class='span6'>"+
            "<h5 class='btn btn-link'>"+
            websites[x].title+
            "</h5></div>"+
            "</div>"+
            //                            "<div class='row-fluid>"+
            //                                "<div class='span12'>"+
            //                                websites[x].caption+
            //                                "</div>"+
            //                             "</div>"+

            "<div class='line-separator-dashed'> </div>";


            websiteCloud.append(websitePreview);


        }
    })


    tag.ajax_get_tags(this.init_tags_cloud);

    var popupClicked = false;
    var buttonDisplayed = false;
    $('body').click(function(){
        if(popupClicked){
            $('.tagCloud').popover('hide');
        }
        if(buttonDisplayed){

            $(".tagCloud").hide(200);
            $('.tagName').show();
            buttonDisplayed=false;
        }
    })

    function fisherYates ( myArray ) {
        var i = myArray.length;
        if ( i == 0 ) return false;
        while ( --i ) {
            var j = Math.floor( Math.random() * ( i + 1 ) );
            var tempi = myArray[i];
            var tempj = myArray[j];
            myArray[i] = tempj;
            myArray[j] = tempi;
        }
    }
};
