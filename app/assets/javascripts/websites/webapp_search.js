
$(document).ready(function(){
    var nbResult = '';
    var settings = new Object();
    var popupWebSite;
    settings.typeDisplay = "grid" // grid or list
    settings.windowSearch = "#search_result";
    settings.searchUrl = '/webapps/order/';
    settings.subtitleSearch = "#subtitle_search";
    settings.nbResultSearch = "#nbresult_search";
    settings.buttonGrid = "#btn_display_grid";
    settings.buttonList = "#btn_display_list";
    settings.resultText = " résultats...";
    settings.currentSorter = "recent";

    $(settings.buttonGrid).addClass('disabled');

    $(settings.buttonGrid).click(function(){
        $(settings.buttonList).removeClass('disabled');
        $(settings.buttonGrid).addClass('disabled');
        settings.typeDisplay='grid';
        loadPage();
    });

    $(settings.buttonList).click(function(){
        $(settings.buttonList).addClass('disabled');
        $(settings.buttonGrid).removeClass('disabled');
        settings.typeDisplay='list';
         loadPage();
    });
    $("#btn_sort_commented").click(function(){
      settings.currentSorter= 'commented';
       loadPage();
    });

    $("#btn_sort_rated").click(function(){
        settings.currentSorter= 'rated';
         loadPage();
    });

    $("#btn_sort_recent").click(function(){
       settings.currentSorter= 'recent';
        loadPage();
    });

    $("#btn_sort_trend").click(function(){
        settings.currentSorter= 'trend';
         loadPage();
    });

    var changeTitle = function(txt){
        $(settings.subtitleSearch).html(txt);
    }

    var loadPage = function(){
            delete popupWebSite;
        $(settings.windowSearch).load(settings.searchUrl+settings.currentSorter+'/'+ settings.typeDisplay,null,function(){
           // When we redisplay new results by ajax, we have to re-excecute js code to display popup
           popupWebSite = new PopupWebSite();
        });
        switch(settings.currentSorter){
            case "recent":
                changeTitle("Les plus récents"); break;
            case "commented":
                changeTitle("Les plus commentés"); break;
            case "rated":
                changeTitle("Les mieux notés");break;
            case "trend":
                changeTitle("Les plus consultés"); break;
                default : break;
        }
    }
});