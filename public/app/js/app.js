'use strict';


// Declare app level module which depends on filters, and services
angular.module('alveolus', 
    ['alveolus.filters',
    'alveolus.services',
    'alveolus.webappService', 
    'alveolus.categoryService', 
    'alveolus.commentService', 
    'alveolus.socialService', 
    'alveolus.userService', 
    'alveolus.directives', 
    'alveolus.homeCtrl', 
    'alveolus.webappCtrl', 
    'alveolus.addWebappCtrl', 
    'alveolus.userCtrl', 
    'alveolus.webAppListCtrl', 
    'ui.bootstrap'
    ]).
config(
  ['$routeProvider', function($routeProvider) {
    $routeProvider.
    when('', {templateUrl: 'partials/home.html',   controller: 'HomeCtrl'}).
    when('/alveoles/new', {templateUrl: 'partials/addWebapp.html',   controller: 'AddWebappCtrl'}).
    when('/alveoles/:webAppId', {templateUrl: 'partials/webAppDesc.html',   controller: 'WebappCtrl'}).
    when('/webappModal/:webAppId', {templateUrl: 'partials/webAppModal.html',   controller: 'WebappCtrl'}).
    when('/alveoles/categorie/:catId', {templateUrl: 'partials/webAppList.html', controller: 'WebAppListCtrl'}).
    when('/alveoles/featured/:selectionId', {templateUrl: 'partials/webAppList.html', controller: 'WebAppListCtrl'}).
    when('/alveoles/search/:content', {templateUrl: 'partials/webAppList.html', controller: 'WebAppListCtrl'}).
    when('/user/:userId', {templateUrl: 'partials/user.html',   controller: 'UserCtrl'}).
    otherwise({redirectTo: ''});
}],["$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
}]);
