'use strict';

/* Controleur de la user page */

angular.module('alveolus.userCtrl', []).
controller('UserCtrl', function($scope, $routeParams, $location, $rootScope, UserService, SessionService, CategoryService) {

	$scope.user=UserService.get({id: $routeParams.userId});
		
	$scope.changeView = function(url){
		console.log('changeView ' + url);
		$location.path(url);
	}

});