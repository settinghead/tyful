# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.imagesloaded.min
//= require jquery.isotope.min.js
//= require nacl

window.editing = false;

window.setTemplateUuid = (uuid) -> 
	$('#template_uuid').val(uuid)
window.submitForm = () ->
  if(!window.editing)
    $('form').submit()
	
onLayoutFn = ($elems, instance) ->

$(document).ready ->
  $("#see-gallery").click ->
    $("html,body").animate
      scrollTop: $(".masonry-container").offset().top
    , "slow"
  $('.masonry-container').imagesLoaded ->
    iso_options = { itemSelector : ".item", onLayout:onLayoutFn}
    $('.masonry-container').isotope(iso_options);

  
window.decodeAndPostMessage = (base64str) ->
  ab = Base64Binary.decodeArrayBuffer(base64str)
  TyfulNaclCoreModule.postMessage ab
	
