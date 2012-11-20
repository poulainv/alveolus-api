$(function() {

	var popupClicked = false;

	//initialize login popover
	$('#login').popover({
		'animation': 	false,
		'placement': 	'bottom',
		'trigger'  : 	'manual',
		'title'    : 	function(){ return 'Connexion' },
		'content'  : 	function(){ return $('#loginHtml').html(); }
	})

	//Show login popover when login menu item clicked
	$('#login').click(function(e){
		e.stopPropagation();
		$('#register').popover('hide');
		$('#login').popover('show');
		$('#loginForm').find('input').first().focus();
	})

	//Don't remove popover when clicking inside it
	$('.popover').live('mouseenter',function(e){
		popupClicked = true;
	})
	$('.popover').live('mouseleave',function(e){
		popupClicked = false;
	})

	
	//Add tooltip
	$('html').tooltip({
		'title':'Bientôt...',
		'selector':'.soon'
	})

   


	//Remove popover when clicking outside of it
	$('body').click(function(){
		if(!popupClicked){
			$('#login').popover('hide');
		}
	})
})