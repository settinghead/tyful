# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.imagesloaded.min
//= require jquery.isotope.min.js

window.inviteFriendsOnFacebook = () ->
	opts = {method: 'apprequests', message: 'I used Tyful to create my own typography artwork. It\'s a simple and fun way to create beautiful artworks that uniquely describes you. You should give it a try, too!'};
	FB.ui(opts);
onLayoutFn = ($elems, instance) ->

$(document).ready ->
  $('.masonry-container').imagesLoaded ->
    iso_options = { itemSelector : ".item", onLayout:onLayoutFn}
    $('.masonry-container').isotope(iso_options);



