# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.imagesloaded.min
//= require jquery.isotope.min.js

window.setTemplateUuid = (uuid) -> 
	$('#template_uuid').val(uuid)
window.submitForm = () ->
	$('form').submit()
onLayoutFn = ($elems, instance) ->


$(document).ready ->
  $('.masonry-container').imagesLoaded ->
    iso_options = { itemSelector : ".item", onLayout:onLayoutFn}
    $('.masonry-container').isotope(iso_options);




	
