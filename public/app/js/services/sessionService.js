'use strict';

/* Services Session */


angular.module('alveolus.sessionService', ['ngResource']).
factory('SessionService', function($log, $cookieStore, $resource, $http, $rootScope,globals) {


    var authorized, getUser, getToken, sign_in, sign_out, service, user, token ;
    service = {};
    user = {}; 
    initTryToLogWithCookie();
    /**
    BROADCAST METHODS
    **/

    function broadcastLogged(){
        console.log("cast broadcastLogged");
        $rootScope.$broadcast('onLoggedSuccess');
    };

    function broadcastUnlogged(){
        console.log("cast broadcastUnlogged");
        $rootScope.$broadcast('onUnloggedSuccess');
    };

    /**
      PRIVATE METHODS TO SEND HTTP REQUEST FOR SIGNIN AND SIGNOUT
    **/   

    // Sign in : update user information, setHTTPProvider, set Cookies then broadcast event logged
    service.sign_in = function(data,callback){
        $http({
          method:'POST', 
          url: globals.server_url+'/sign_in.json',
          data: data,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        }).success(function(data){
          console.log("User logged");
          setUser({id : data.id, email : data.email, success: true });
          token = data.auth_token;
          setHttpProviderCommonHeaderToken(token);
          setSessionToken(token,data.id);
          broadcastLogged();
        })
        .error(function(data) {
          console.log("User not logged");
          setUser({id : data.id, email : data.email, success: false});
        });
    };

    // Sign out : update user info, unsetHttpProvider, removeCookie then broadcast event logged
    service.sign_out = function(user){
        $http({
          method:'DELETE',
          url: globals.server_url+'/sign_out.json?id='+user.id,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        }).success(function(data){
          console.log("User unlogged");
          resetUser();
          removeSessionToken();
          setHttpProviderCommonHeaderToken("");
          broadcastUnlogged();
        })
        .error(function(data) {
          console.log("Error sign_out");
          resetUser();
        });
    };


    function initTryToLogWithCookie(){
      console.log("Try to log with cookies ");
      var cookieToken = getTokenCookie();
        if(getTokenCookie()!=null && getTokenCookie()!=""){
          console.log("session cookie found");
          setUser({success: true, id : getUserIdCookie()});
          setHttpProviderCommonHeaderToken(getTokenCookie());
          broadcastLogged();
        }
        else{
          console.log("Session cookie not found");
           resetUser();
           broadcastUnlogged();
        }
    }

    function setUser(newUser){
      user.email = newUser.email ;
      user.id = newUser.id;
      user.authorized = newUser.success;
      console.log("setUser auth :"+newUser.success);
    }

    function resetUser(){
      user.email = null ;
      user.id = null;
      user.authorized = false;
 
    }

    function setHttpProviderCommonHeaderToken(token){
      $http.defaults.headers.common['X-AUTH-TOKEN'] = token;
    }


    function setSessionToken(token,id){
      console.log("set cookie token : "+token+" for userId :"+id);
      $cookieStore.put('alveolus-token',token)
      $cookieStore.put('alveolus-userId', id);
    }

    function getTokenCookie(){
      console.log('getCookie '+ $cookieStore.get('alveolus-token'))
      return $cookieStore.get('alveolus-token');
    }

    function getUserIdCookie(){
      return $cookieStore.get('alveolus-userId');
    }

    function removeSessionToken(){
      $cookieStore.remove('alveolus-token');
      $cookieStore.remove('alveolus-userId');
    }

    /*
    PUBLIC METHODS
    */
    authorized = function() {
      console.log("authorized????"+(user.authorized))
      return user.authorized;
    };

    sign_in = function(newUser) {
     var xsrf = $.param({
        remote: true,
        commit: "Sign in",
        utf8: "✓", 
        remember_me: 0,
        password: newUser.password, 
        email: newUser.email
      });
      // var data = { password : newUser.password, email : newUser.email};
      service.sign_in(xsrf);
    };
  
    var authFacebook = function(){
       $http({
          method:'GET',
          url: '/auth/facebook',
        }).success(function(data){
          console.log("User logged");
          setUser({id : data.id, email : data.email, success: true });
          token = data.auth_token;
          setHttpProviderCommonHeaderToken(token);
          setSessionToken(token,data.id);
          broadcastLogged();
        })
        .error(function(data) {
          console.log("Error sign_out");
          resetUser();
        });

    };

    sign_out = function() {
      service.sign_out(user);
    };

    getToken = function(){
      console.log("return token : "+token);
      return token;
    };

    getUser = function() {
      return user;
    };

    return {
      getToken : getToken,
      sign_in: sign_in,
      sign_out: sign_out,
      authorized: authorized,
      getUser: getUser,
      authFacebook : authFacebook
    };
  }
);
