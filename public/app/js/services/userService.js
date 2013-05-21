'use strict';

/* Services Users */

angular.module('alveolus.userService', ['ngResource']).
factory('UserService', function($http,$resource) {

    var url = 'http://quiet-spire-4994.herokuapp.com';

    var service = $resource(url+'/users/:id', {id:'@id'}, {});

    service.getComments = function(params,callback){
        $http({method:'GET', url: url+'/users/'+params.catId+'/comments', cache:true}).
        success(function(data){callback(data);});
    }

    service.alreadyCommented = function(params,callback){
        $http({method:'GET', url: url+'/users/'+params.userId+'/webapps/'+params.webAppId+'/comments', cache:true}).
        success(function(data){callback(data);});
    }

    return service;
});