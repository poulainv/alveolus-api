'use strict';

/* Services Notification */

angular.module('alveolus.notificationService', ['ngResource']).
factory('NotificationService', function($http,$resource,globals) {

    var service = {} ;

    service.query = function(callback){
        $http({method:'GET', url: globals.server_url+'/notifications/'}).
        success(function(data){callback(data);});
    };

    service.getUnread = function(callback){
        $http({method:'GET', url: globals.server_url+'/notifications/unread'}).
        success(function(data){callback(data);});
    };

    service.getLast = function(callback){
        $http({method:'GET', url: globals.server_url+'/notifications/last'}).
        success(function(data){callback(data);});
    };

    service.reading = function(callback){
       $http({method:'PUT', url: globals.server_url+'/notifications/reading'}).
        success(function(data){callback(data);});
    };

    return service;
});