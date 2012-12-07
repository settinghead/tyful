# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require jquery.imagesloaded.min
//= require jquery.isotope.min.js
window.editing = false;

window.setTemplateUuid = (uuid) -> 
	$('#template_uuid').val(uuid)
window.submitForm = () ->
  if(!window.editing)
    $('form').submit()
	
onLayoutFn = ($elems, instance) ->

$(document).ready ->

  moduleDidLoad()

  container = document.getElementById("listener")
  container.addEventListener "message", handleMessage, true

  $("#see-gallery").click ->
    $("html,body").animate
      scrollTop: $(".masonry-container").offset().top
    , "slow"
  $('.masonry-container').imagesLoaded ->
    iso_options = { itemSelector : ".item", onLayout:onLayoutFn}
    $('.masonry-container').isotope(iso_options);

    #append colors
    $.each ["#f00", "#ff0", "#0f0", "#0ff", "#00f", "#f0f", "#000", "#fff"], ->
    $("#mainCanvas .tools").append "<a href='#sketch' data-color='" + this + "' style='width: 10px; background: " + this + ";'></a> "

    #append sizes
    $.each [10, 15, 30, 50], ->
      $("#mainCanvas .tools").append "<a href='#sketch' data-size='" + this + "' style='background: #ccc'>" + this + "</a> "
    $("#sketch").sketch()

    $("#btnRender").click ->
      canvas = $("#sketch")[0]
      canvasWidth = canvas.width
      canvasHeight = canvas.height
      ctx = canvas.getContext("2d")
      imageData = ctx.getImageData(0, 0, canvasWidth, canvasHeight)
      TyfulNaclCoreModule.postMessage "updateTemplate:" + canvasWidth + "," + canvasHeight
      TyfulNaclCoreModule.postMessage imageData.data.buffer
      TyfulNaclCoreModule.postMessage "startRender:"
      window.shapes = {}
      window.sid = 0
      window.initializing = false



	
