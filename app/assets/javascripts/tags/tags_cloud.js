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

            var coeffSize = 100+tags[x].poid*tags[x].poid*20;
            console.log("cooef :"+coeffSize);
             // Geneate tag
            var tagP = $("<span/>", {
                "tagId": tags[x].id,
               'class':'tagCloud',
                html: "<span class='tagName'>"+tags[x].name+"</span>",
                style : "margin : 5% 5% 5% 5%; font-size:"+coeffSize+"%; padding-right:1%; ",
                click : function(event){
                    $(this).children(".btn-tag").show();
                    $(this).children('.tagName').hide(500);
                    buttonDisplayed = true;
                    event.stopPropagation();
                }
               
            }).appendTo(tagCloud);

         
             // Generate button Voir
            $("<span/>", {
                style : 'display:none; margin-left:1%;',
                "class" : "btn btn-small btn-tag custom_inline",
                text: 'Websites',
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
                'placement': 	'right',
                'html'      :         true,
                'trigger'  : 	'manual',
                'title'    :          'Websites associés',
                'content'  : 	function(){
                    return $('#websitesCloud').html()
                }
            });


            // Generate button Parcourir
            $("<span/>", {
                style : 'display:none; margin-left:1%;',
                "class" : "btn btn-small btn-tag custom_inline",
                text: 'Explorer',
                click : function(){

                        $('#tagsCloud').hide(600);
                        tag.ajax_get_tags_associated($(this).parent().attr('tagId'),cloudtags.init_tags_cloud)
                    }

                }).appendTo(tagP)
   if(x%3==0){
                tagP.append("<br>");
            }

        }

        $('#tagsCloud').show(600);
    });

    this.init_websites_list = (function(websites){

        var websiteCloud = $("#websitesCloud").html('')
        console.log('Init websites cloud...');

        for (x in websites)
        {

            var websitePreview =
                "<div class='row-fluid'>"+
                    "<div class='container-fluid websitePreview'>"+
                        "<div class='span6'>"+
                            "<img src='"+websites[x].preview+"'</img>"+
                        "</div>"+
                        "<div class='span6'>"+
                            "<div class='row-fluid>"+
                                "<div class='span12'><h5>"+
                                websites[x].title+
                                "</h5></div>"+
                            "</div>"+
//                            "<div class='row-fluid>"+
//                                "<div class='span12'>"+
//                                websites[x].caption+
//                                "</div>"+
//                             "</div>"+
                         "</div>"+
                    "</div>"+
             "</div>"+
             "<div class='line-separator-dashed'> </div>";


            websiteCloud.append(websitePreview);
//             $("#websitesCloud:last-child").click(function(){
//                 alert('sdf');
//             })
        }
    })


    tag.ajax_get_tags(this.init_tags_cloud);

      var popupClicked = false;
      var buttonDisplayed = false;
        $('body').click(function(){
		if(popupClicked){
			$('.btn-tag').popover('hide');
		}
                    if(buttonDisplayed){

                    $(".btn-tag").hide(200);
                    $('.tagName').show();
                        buttonDisplayed=false;
                    }
	})


});
