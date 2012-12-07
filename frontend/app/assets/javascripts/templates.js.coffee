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
  window.words = ["The self always <br />comes through.", "mhi", "mXiyang", "mlol"]
  renderCanvas = $("#renderer")[0]
  renderCanvas.getContext("2d").clearRect 0,0,renderCanvas.width, renderCanvas.height
  resetShoppingWindows()

  TyfulNaclCoreModule.postMessage "updateTemplate:" + canvasWidth + "," + canvasHeight
  TyfulNaclCoreModule.postMessage imageData.data.buffer
  TyfulNaclCoreModule.postMessage "startRender:"

drawGradients = (ctxColor, canvasColor)->
  grad = ctxColor.createLinearGradient(20, 0, canvasColor.width - 20, 0)
  grad.addColorStop 0, "red"
  grad.addColorStop 1 / 6, "orange"
  grad.addColorStop 2 / 6, "yellow"
  grad.addColorStop 3 / 6, "green"
  grad.addColorStop 4 / 6, "aqua"
  grad.addColorStop 5 / 6, "blue"
  grad.addColorStop 1, "purple"
  ctxColor.fillStyle = grad
  ctxColor.fillRect 0, 0, canvasColor.width, canvasColor.height

resetShoppingWindows = ->
  $(".shopping-window").each ->
    this.getContext('2d').clearRect(0,0,this.width,this.height)

$(document).ready ->

  moduleDidLoad()

  container = document.getElementById("listener")
  container.addEventListener "message", handleMessage, true

  $("#renderer").bind "click", (e) ->
    e.preventDefault()
    $(this).toggleClass "hover_effect"

  $("#see-gallery").click ->
    $("html,body").animate
      scrollTop: $(".masonry-container").offset().top
    , "slow"
  $('.masonry-container').imagesLoaded ->
    iso_options = { itemSelector : ".item", onLayout:onLayoutFn}
    $('.masonry-container').isotope(iso_options);

    #append colors
    # $.each ["#f00", "#ff0", "#0f0", "#0ff", "#00f", "#f0f", "#000", "#fff"], ->
      # $("#mainCanvas .tools").append "<a href='#sketch' data-color='" + this + "' style='width: 10px; display: inline-block; background: " + this + ";'>&nbsp;</a> "

    #append sizes
    $.each [30, 50, 100, 150], ->
      $("#mainCanvas .tools").append "<a href='#sketch' data-size='" + this + "' style='background: #ccc; display: inline-block;'>" + this + "</a> "
    $("#sketch").sketch defaultSize:100

    img = new Image()
    img.src= "/templates/egg.png"
    img.onload = ->
      $('#sketch')[0].width = img.width
      $('#sketch')[0].height = img.height
      $('#renderer')[0].width = img.width
      $('#renderer')[0].height = img.height
      $('#sketch')[0].getContext('2d').drawImage(this,0,0)
      window.startRendering()


    $("#btnRender").click ->
      window.startRendering()

      #register render click event
    $("#sketch").on("mouseup",window.startRendering)
    $("#sketch").on("touchend",window.startRendering)

    #construct color pallette
    canvasColor = document.getElementById("color")
    ctxColor = canvasColor.getContext("2d")
    drawGradients ctxColor, canvasColor
    $("#color").mousemove (e) -> # mouse move handler
      canvasOffset = $(canvasColor).offset()
      canvasX = Math.floor(e.pageX - canvasOffset.left)
      canvasY = Math.floor(e.pageY - canvasOffset.top)
      imageData = ctxColor.getImageData(canvasX, canvasY, 1, 1)
      pixel = imageData.data
      pixelColor = "rgba(" + pixel[0] + ", " + pixel[1] + ", " + pixel[2] + ", " + pixel[3] + ")"
      $("#preview").css "backgroundColor", pixelColor

    $("#color").click (e) -> # mouse click handler
      canvasOffset = $(canvasColor).offset()
      canvasX = Math.floor(e.pageX - canvasOffset.left)
      canvasY = Math.floor(e.pageY - canvasOffset.top)
      imageData = ctxColor.getImageData(canvasX, canvasY, 1, 1)
      pixel = imageData.data
      pixelColor = "rgba(" + pixel[0] + ", " + pixel[1] + ", " + pixel[2] + ", " + pixel[3] + ")"
      $("#pick").css "backgroundColor", pixelColor
      $.fn.sketch.color = pixelColor



	
