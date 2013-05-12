'use strict';


// Declare app level module which depends on filters, and services
angular.module('alveolus', ['alveolus.filters', 'alveolus.services', 'alveolus.directives', 'alveolus.homeCtrl', 'alveolus.webAppDescCtrl', 'alveolus.userCtrl', 'ui.bootstrap']).
  config(['$routeProvider', function($routeProvider) {
  $routeProvider.
      when('', {templateUrl: 'partials/home.html',   controller: 'HomeCtrl'}).
      when('/webapp/:webAppId', {templateUrl: 'partials/webAppDesc.html',   controller: 'WebAppDescCtrl'}).
      when('/webappModal/:webAppId', {templateUrl: 'partials/webAppModal.html',   controller: 'WebAppDescCtrl'}).
      when('/user/:userId', {templateUrl: 'partials/user.html',   controller: 'UserCtrl'}).
      otherwise({redirectTo: ''});
  }]);

