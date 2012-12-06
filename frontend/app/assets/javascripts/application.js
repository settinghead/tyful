// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.hoverIntent
//= require jquery.purr
//= require notifications.js
//= require facebook
//= require_tree .
//= require uservoice.js
//= require ga.js
//= require sketch.js

window.resizeStuff = function (){
	$('#header-middle').css('right',
	    $('#header-right').outerWidth()+30+"px");
		$('#header-middle').css('right',
		    $('#header-right').outerWidth()+30+"px");
	$('#header-middle').css('min-height',$('#header-right').outerHeight+"px");
	var amount = $('#header').outerHeight()>$('#header-middle').outerHeight()
		?$('#header').outerHeight():$('#header-middle').outerHeight();
	$('#container').css("padding-top",amount+"px");
	$('#container').height($(window).height()-amount);
	$('#container').css("padding-top", amount+"px");
	$('#container').height($(window).height()-amount);
	
	
}
$(document).ready(window.resizeStuff);
$(window).resize(window.resizeStuff);
