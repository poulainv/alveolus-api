'use strict';

/* Controleur de la home page */

angular.module('alveolus.webappCtrl', []).
controller('WebappCtrl', function($scope,$location,$routeParams, WebappService, SocialService, UserService, CommentService, CategoryService) {

	var alertNewComment = {type : 'success', msg : 'Merci d\'avoir commenté cette alvéole ! '};
	var alertSubmitComment = {type : 'info', msg : 'Votre commentaire a bien été modifié.'};
	var alertDeleteComment = {type : 'info', msg : 'Votre commentaire a bien été supprimé.'};
	var alertSubmitTag = {type : 'success', msg : "Votre tag a bien été soumis. Il sera validé si d'autres personnes l'ajoutent aussi."};
	var alertErrorAlreadyTagged = {type : 'error', msg : "Vous avez déjà proposé ce tag pour cette alvéole ! Votre tag n'a pas été ajouté."};


	$scope.canEdit = false;

	$scope.webAppId=$routeParams.webAppId;
	$scope.webapp=WebappService.get({id: $routeParams.webAppId}, function(data){

		console.log("test "+$.isEmptyObject(data.comments));
		if($.isEmptyObject(data.comments)){
			$scope.webappHaveComments=false;
		}
		else{
			$scope.webappHaveComments=true;
		}
		console.log("isEmptyObject:"+$.isEmptyObject(data.comments));
		console.log("webappHaveComments:"+$scope.webappHaveComments);

		if($scope.user.id){
			//user connecté
			UserService.alreadyCommented({webAppId : $scope.webAppId, userId : $scope.user.id}, function(data){
				if($.isEmptyObject(data)){
					$scope.canComment=true;
				}
				else{
					$scope.canComment=false;
					$scope.commentUser=data;
					if($scope.webapp.comments.length==1)
						$scope.webappHaveComments=false;
				}
				
			});
			// $scope.user.id=2;	
			console.log($scope.webapp);
			console.log($scope.user);
			if($scope.user.id == $scope.webapp.user_id){
				$scope.canEdit = true;
			}
		}else{
			$scope.canComment=false;
		}

		$scope.$on('onLoggedSuccess', function() {
			if($scope.user.id){
				UserService.alreadyCommented({webAppId : $scope.webAppId, userId : $scope.user.id}, function(data){
					if($.isEmptyObject(data)){
						$scope.canComment=true;
					}
					else{
						$scope.canComment=false;
						$scope.commentUser=data;
					}
				});
			}else{
				$scope.canComment=false;
			}
		});

		if($scope.webapp.facebook_id){
			SocialService.getFacebookData($scope.webapp.facebook_id,function(data){$scope.facebook=data}); 
		} else { 
			$scope.facebook=null; 
		}

		
		if($scope.webapp.twitter_id){
			SocialService.getTwitterData($scope.webapp.twitter_id,function(data){$scope.twitter=data});
		} else { 
			$scope.twitter=null;
		}

		// A voir récupération données google+ ???
		// if($scope.webapp.gplus_id)
		// 	WebappTwitter.get($scope.webapp.gplus_id,function(data){$scope.twitter=data});
		// else $scope.twitter=null; 

	});



$scope.submitComment = function(comment) {
	CommentService.addComment({webappId : $scope.webAppId, comment : comment.body, 
		rating : comment.rating}, function(data){
			$scope.commentUser=data;
			$scope.canComment=false;
			$scope.addAlert(alertNewComment);
		});
};

$scope.submitEditComment=function(comment){
	CommentService.updateComment({commentId : comment.id, comment : comment.body, 
		rating : comment.rating}, function(data){
			$scope.commentUser=data;
			$scope.editComment=false;
			$scope.addAlert(alertSubmitComment);
		});
}

$scope.deleteComment=function(comment){
	CommentService.deleteComment({commentId : comment.id}, function(data){
		$scope.canComment=true;
		$scope.commentUser=null;
		$scope.addAlert(alertDeleteComment);
	});
}

$scope.bookmark=function(){
	WebappService.bookmark({id : $scope.webAppId}, function(data){
		$scope.webapp.bookmarked=true;	    			
	});
}
$scope.unbookmark=function(){
	WebappService.unbookmark({id : $scope.webAppId}, function(data){
		$scope.webapp.bookmarked=false;
	});
}

$scope.trackSharing = function(){
	WebappService.tracker({id : $scope.webAppId, type : 'shared'});
}

$scope.changeView = function(url){
	console.log('changeView ' + url);
	CategoryService.setIdCatSelected($scope.webapp.category_id);
	$location.path(url);
}

$scope.submitTag = function(newTag) {
    WebappService.addTag({id : $routeParams.webAppId, tagName : newTag.name}, function(data){
    		console.log("callback without errors");
    		$scope.addAlert(alertSubmitTag);
    		$scope.webapp.tags=data;
    		$scope.userAddTag=false;
    		$scope.newTag.name="";
    	},
    	function(data){
    		console.log("callback with errors");
    		$scope.addAlert(alertErrorAlreadyTagged);
    	}
    );
};

$scope.goToEditWebappPage = function(){
	if($scope.isLogged){
		$location.path('/alveoles/'+$routeParams.id+'/edit');
	} else {
		$scope.openModalLogin();
	}  		
}

$scope.shareOnFb=function(){
	 console.log("share");
	FB.ui({
          method: 'feed',
          name: "title",
          link:  "http://alveolus.fr",
          caption: "caption",
          message: "J'ai découvert ça sur EnjoyTheWeb, ça peut vous intéresser !"
      },function(response) {
      console.log("response:"+response);
    });
}



});