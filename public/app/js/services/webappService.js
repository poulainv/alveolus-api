'use strict';

/* Services WebApps */

angular.module('alveolus.webappService', ['ngResource']).
factory('WebappService', function($http,$resource) {

    var url = 'http://quiet-spire-4994.herokuapp.com';
    var service = $resource(url+'/webapps/:id', {id:'@id'}, {}, {
        //Ceci ne marche pas. Je ne sais pas si c'est possible en fait ou si c'est moi qui ai fait une erreur
        // new: {method:'GET', params:{id:'new'}}
    });

    service.new = function(callback){
        //Du coup obligé de faire comme ça
        return service.get({id:'new'},callback);
    }


    service.getMostRecent = function(callback){
        $http({method:'GET', url: url+'/webapps/trend/recent', cache: true}).
        success(function(data){callback(data);});
    }

    service.getMostShared = function(callback){
        $http({method:'GET', url: url+'/webapps/trend/shared', cache: true}).
        success(function(data){callback(data);});
    }

    service.getMostCommented =  function(callback){
        $http({method:'GET', url: url+'/webapps/trend/commented', cache: true}).
        success(function(data){callback(data);});
    }

    service.getBest = function(callback){
        $http({method:'GET', url: url+'/webapps/trend/rated', cache: true}).
        success(function(data){callback(data);});
    }

    service.getFeaturedApp = function(params,callback){
        $http({method:'GET', url: url+'/categories/'+params.catId+'/featured_webapp'}).
        success(function(data){callback(data);});
    }

    service.getFeaturedApps = function(params,callback){
        $http({method:'GET', url: url+'/categories/'+params.catId+'/featured_webapps'}).
        success(function(data){callback(data);});
    }

    service.getAppsFromCat = function(params,callback){
        $http({method:'GET', url: url+'/categories/'+params.catId+'/webapps'}).
        success(function(data){callback(data);});
    }

    return service;
});