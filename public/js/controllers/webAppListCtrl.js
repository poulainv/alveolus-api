'use strict';

/* Controleur de la home page */

angular.module('alveolus.webAppListCtrl', []).
controller('WebAppListCtrl', function($scope,$routeParams,$location,WebappService,CategoryService,$window,TagService) {


	// $('#headerCarousel').hide();
	init();

	//[Fix#2]
	$scope.changeSubcat = function(subcat){
		if(subcat.isCat === true){
			var cat = {
				id: subcat.alveoles[0].category_id,
				webapps: subcat.alveoles,
				name: subcat.name
			};
			$scope.changeCat(cat);
		}
	};

	/**
	* On change de catégorie
	**/
	$scope.changeCat = function(cat){
		$window._gaq.push(['_trackPageview', '/'+cat.name]);
		$scope.subcats = [] ;
		$scope.subTitle = cat.name;

		// Get featured app for category 'cat'
		$scope.subcats.push({ isCat : false, name : 'Sélection de l\'équipe', alveoles : cat.webapps});

		// Get all apps for category 'cat'
		WebappService.getAppsFromCat({catId: cat.id}, function(data){
			$scope.subcats.push({ isCat : false, name : 'Toutes les alvéoles', alveoles : data});
		});
	};


	/**
	* On change de feature
	**/
	$scope.changeFeat = function(catFeat){
		$window._gaq.push(['_trackPageview', '/'+catFeat.name]);
		$scope.subTitle = catFeat.name;
		$scope.subcats = [] ;
		
		switch(catFeat.id){
			case 1:
			//Sélection de l'équipe
			for(var i in $scope.cats){
				$scope.subcats.push({ isCat : true, name : $scope.cats[i].name, alveoles : $scope.cats[i].webapps});
			}
			break;
			case 2:
			//Les plus commentéees
			WebappService.getMostCommented(function(data){
				$scope.subcats.push({name : '', alveoles : data});

			});
			break;
			case 3:
			//Les mieux notées
			WebappService.getBest(function(data){
				$scope.subcats.push({name : '', alveoles : data});
			});
			break;
			case 4:
			//Les plus récentes
			WebappService.getMostRecent(function(data){
				$scope.subcats.push({name : '', alveoles : data});
			});
			break;
			case 5:
			//Les plus partagées
			WebappService.getMostShared(function(data){
				$scope.subcats.push({name : '', alveoles : data});
			});
			break;
			default:
			break;
		}
	};

	$scope.search = function(content){
		$location.path('/alveoles/search/'+content);
	};

	$scope.searchResults = function(content){
		$scope.subTitle = content;
		$scope.subcats = [] ;
		WebappService.search({'content':content}, function(data){
			$scope.subcats.push({ name : 'Résultats de la recherche', alveoles : data});
		});
	}

	/**
	* Initialiase les variables au chargement de la page (une seule fois)
	**/
	function init(){

		// console.log("init()");

		$scope.subcats = [];
		initSelectionCats();
		var idCat = CategoryService.getIdCatSelected();

		// On commence par charger les catégories
		CategoryService.getCategoriesWithFeaturedApps(function(data){
			//Si l'utilisateur arrive sur la page directement depuis l'url, on le met sur les staff picks
			$scope.cats = data;
			if($routeParams.content){
				$scope.searchResults($routeParams.content);
			} else if(idCat){
				$scope.changeCat($scope.cats[idCat-1]);				
			} else {
				$scope.changeFeat($scope.selectionCats[0]);
			}
		});

		// tags

		$scope.tags = TagService.query();

	}


	/**
	* On initialise la liste des sélections
	**/
	function initSelectionCats(){
		// console.log("setSelectionCats()");
		$scope.selectionCats = [
		{
			'name':'Sélection de l\'équipe',
			'id':1
		},
		{
			'name':'Les plus commentés',
			'id':2
		},
		{
			'name':'Les mieux notés',
			'id':3
		},
		{
			'name':'Les plus récents',
			'id':4
		},
		{
			'name':'Les plus partagés',
			'id':5
		}
		];
	}

});