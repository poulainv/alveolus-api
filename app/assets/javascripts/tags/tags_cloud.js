$(document).ready(function(){

    var cloudtags = this
    var tag = new Tags();
    var website = new Websites();
   

    this.init_tags_cloud = (function(tags){
        var tagCloud = $("#tagsCloud").html('')
        var tagElement;
        console.log('Init cloud...');
        for (x in tags)
        {

            var coeffSize = 100+tags[x].poid*60;
            console.log("cooef :"+coeffSize);
             // Geneate tag
            var tagP = $("<span/>", {
                "tagId": tags[x].id,
                "class" : "tagCloud",
                text: tags[x].name,
                style : "margin-right : 5%; font-size:"+coeffSize+"%;",
                mouseover : function(){
                    $(this).children(".btn-tag").show();                  
                },
                mouseout : function(){
                    $(this).children(".btn-tag").hide();
                }
            }).appendTo(tagCloud);

            if(x%3==0){
                tagP.append("<br>");
            }

             // Generate button Voir
            $("<div/>", {
                style : 'display:none; margin-left:1%;',
                "class" : "btn btn-mini btn-tag",
                text: 'V',
                click : function(){
                   
                    tagElement =   $(this);
                    website.ajax_get_for_tag_id($(this).parent().attr('tagId'),function(msg){
                    cloudtags.init_websites_list(msg);
                    tagElement.popover('show');
                    popupClicked = true;
                    });

                },
                mouseout : function(){
                  
                }

            }).appendTo(tagP)
            .popover({
                'animation': 	false,
                'placement': 	'bottom',
                'html'      :         true,
                'trigger'  : 	'manual   ',
                'title'    :          'Les websites associés',
                'content'  : 	function(){
                    return $('#websitesCloud').html()
                }
            });


            // Generate button Parcourir
            $("<div/>", {
                style : 'display:none; margin-left:1%;',
                "class" : "btn btn-mini btn-tag",
                text: 'P',
                click : function(){
                        tag.ajax_get_tags_associated($(this).parent().attr('tagId'),cloudtags.init_tags_cloud)
                    }

                }).appendTo(tagP)

        }
    });

    this.init_websites_list = (function(websites){

        var websiteCloud = $("#websitesCloud").html('')
        console.log('Init websites cloud...');

        for (x in websites)
        {

            var websitePreview =
                "<div class='row-fluid'>"+
                    "<div class='container-fluid'>"+
                        "<div class='span6'>"+
                            "<img src='"+websites[x].preview+"'</img>"+
                        "</div>"+
                        "<div class='span6'>"+
                            "<div class='row-fluid>"+
                                "<div class='span12'><small>"+
                                websites[x].title+
                                "</small></div>"+
                            "</div>"+
//                            "<div class='row-fluid>"+
//                                "<div class='span12'>"+
//                                websites[x].caption+
//                                "</div>"+
//                             "</div>"+
                         "</div>"+
                    "</div>"+
             "</div>";

            websiteCloud.append(websitePreview);
        }
    })


    tag.ajax_get_tags(this.init_tags_cloud);

      var popupClicked = false;
        $('body').click(function(){
		if(popupClicked){
			$('.btn-tag').popover('hide');
		}
	})


});
