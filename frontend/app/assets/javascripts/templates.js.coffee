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

window.determineFontHeight = (text,fontStyle) ->
  body = document.getElementsByTagName("body")[0]
  dummy = document.createElement("div")
  dummyText = document.createTextNode(text)
  dummy.appendChild dummyText
  dummy.setAttribute "style", "font: " + fontStyle + ";"
  body.appendChild dummy
  result = dummy.offsetHeight
  body.removeChild dummy
  result

window.startRendering = ->
  canvas = $("#sketch")[0]
  canvasWidth = canvas.width
  canvasHeight = canvas.height
  ctx = canvas.getContext("2d")
  imageData = ctx.getImageData(0, 0, canvasWidth, canvasHeight)
  window.shapes = {}
  window.slapLater = []
  window.sid = 0
  window.initializing = false
  window.words = ["mhello", "mhi", "mXiyang", "mlol"]
  renderCanvas = $("#renderer")[0]
  renderCanvas.getContext("2d").clearRect 0,0,renderCanvas.width, renderCanvas.height

  TyfulNaclCoreModule.postMessage "updateTemplate:" + canvasWidth + "," + canvasHeight
  TyfulNaclCoreModule.postMessage imageData.data.buffer
  TyfulNaclCoreModule.postMessage "startRender:"

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
      $("#mainCanvas .tools").append "<a href='#sketch' data-color='" + this + "' style='width: 10px; display: inline-block; background: " + this + ";'>&nbsp;</a> "

    #append sizes
    $.each [30, 50, 100, 150], ->
      $("#mainCanvas .tools").append "<a href='#sketch' data-size='" + this + "' style='background: #ccc; display: inline-block;'>" + this + "</a> "
    $("#sketch").sketch defaultSize:100

    img = new Image()
    img.src= "/templates/egg.png"
    img.onload = ->
      $('#sketch')[0].getContext('2d').drawImage(this,0,0)


    $("#btnRender").click ->
      window.startRendering()

    $("#sketch").on("mouseup",window.startRendering)
    $("#sketch").on("touchend",window.startRendering)



	
