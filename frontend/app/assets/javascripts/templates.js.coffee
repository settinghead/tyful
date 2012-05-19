# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.masonry.min
//= require jquery.imagesloaded.min

window.setTemplateId = (id) -> 
	$('#template_uuid').val(id)
window.submitForm = () ->
	$('form').submit()

$('.masonry-container').imagesLoaded = () ->
  $container.masonry({
    itemSelector : '.item',
    columnWidth : 240,
    isAnimated: true,
    animationOptions: {
      duration: 750,
      easing: 'linear',
      queue: false
    }
	
  });
