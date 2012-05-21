# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.imagesloaded.min
//= require jquery.isotope.min.js

window.setTemplateId = (id) -> 
	$('#template_uuid').val(id)
window.submitForm = () ->
	$('form').submit()


$(document).ready ->
  $('.masonry-container').imagesLoaded ->
    iso_options = {itemSelector : ".item", animationEngine : "best-available"}
    $('.masonry-container').isotope(iso_options);



	
