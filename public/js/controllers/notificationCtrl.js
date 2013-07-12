'use strict';

/* Controleur des notifications */

angular.module('alveolus.notificationCtrl', []).
controller('NotificationCtrl', function($scope,$routeParams,SessionService,NotificationService,$location,$timeout) {

    var popoverNotifDisplayed = false ;
    if($scope.isLogged){
         getLastNotifications();
    }

    $scope.$on('onGetNotification', function() {
        getLastNotifications();
    });

    //Update notification on home page
    $scope.$on('onLoggedSuccess', function(event) {
        getLastNotifications();
    });

    function reading(){
        // $('#notifications').popover('destroy');
        NotificationService.reading(function(data){
            $scope.notifications = data;
            $scope.nbUnreadNotifications = countUnread();
        })
    }

    function getLastNotifications(){
        // $('#notifications').popover('destroy');
         NotificationService.getLast(function(data){
            $scope.notifications = data;
            $scope.nbUnreadNotifications = countUnread();
        }); 
    }

    function countUnread(){
        var nbUnread = 0;
        for(var i=0;i<$scope.notifications.length;i++){ 
            if(!$scope.notifications[i].is_readed){
                nbUnread++;        
            }
        }
        return nbUnread;
    }

    $scope.hideNotifications = function(){
        $("#notifications").popover("hide");
        popoverNotifDisplayed = false;
    }

    $scope.showNotifications = function($event){
        if(popoverNotifDisplayed){
            $scope.hideNotifications();
            return;
        }
        $('#notifications').popover('destroy');
        $('#notifications').popover({
            html : true,
            placement : "bottom",
            title : "Notifications ("+$scope.nbUnreadNotifications+")",
            trigger : 'manual',
            content : $("#notifications-content").html()
        });
        $('#notifications').popover("show");
        popoverNotifDisplayed = true;
        $("#notifications-content").css("display","");
        $('.popover').click(function(event){
            event.stopPropagation();
        });
        $event.stopPropagation();
    }

    $('body').click(function(){
        if(popoverNotifDisplayed){
            reading();
        }
        $scope.hideNotifications();
       
        
    });
});