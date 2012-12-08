
window.TyfulNacl = new Object()

$(document).ready ->


  $('#tyfulTabs a').click (e) ->
    e.preventDefault()
    $(this).tab 'show'

  window.TyfulNacl.moduleDidLoad()
  # window.renderCanvas = new fabric.Canvas('renderpreview',
  #   hoverCursor: "pointer"
  #   selection: false
  # )
  container = document.getElementById("listener")
  container.addEventListener "message", window.TyfulNacl.handleMessage, true

  $("#renderpreview").bind "click", (e) ->
    e.preventDefault()
    $(this).toggleClass "hover_effect"

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
    $('#renderpreview')[0].width = img.width
    $('#renderpreview')[0].height = img.height
    $('#renderer')[0].width = img.width
    $('#renderer')[0].height = img.height
    window.renderCanvas = new fabric.Canvas('renderer',
      hoverCursor: "pointer"
      selection: false
    )
    $('#sketch')[0].getContext('2d').drawImage(this,0,0)
    window.TyfulNacl.startRendering()

  $("#btnRender").click ->
    window.TyfulNacl.startRendering()

    #register render click event
  $("#sketch").on("mouseup",window.TyfulNacl.startRendering)
  $("#sketch").on("touchend",window.TyfulNacl.startRendering)

  #construct color pallette
  canvasColor = document.getElementById("color")
  ctxColor = canvasColor.getContext("2d")
  window.TyfulNacl.drawGradients ctxColor, canvasColor
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

  $("#renderpreview").click (event) ->
    event.preventDefault()
    $("#tyfulTabs a#adjustButton").tab('show');


window.TyfulNacl.resetShoppingWindows = ->
  $(".shopping-window").each ->
    this.getContext('2d').clearRect(0,0,this.width,this.height)

# window.TyfulNacl.determineFontHeight = (text,fontStyle) ->
#   body = document.getElementsByTagName("body")[0]
#   dummy = document.createElement("div")
#   dummyText = document.createTextNode(text)
#   dummy.appendChild dummyText
#   dummy.setAttribute "style", "font: " + fontStyle + ";"
#   body.appendChild dummy
#   result = dummy.offsetHeight
#   body.removeChild dummy
#   result

window.TyfulNacl.startRendering = ->
  canvas = $("#sketch")[0]
  canvasWidth = canvas.width
  canvasHeight = canvas.height
  ctx = canvas.getContext("2d")
  imageData = ctx.getImageData(0, 0, canvasWidth, canvasHeight)
  window.TyfulNacl.shapes = {}
  window.TyfulNacl.slapLater = []
  window.TyfulNacl.sid = 0
  window.TyfulNacl.initializing = false
  window.TyfulNacl.words = ["Know Thyself", "m'hi", "Xiyang", "mlol"]
  renderCanvas = $("#renderpreview")[0]
  renderCanvas.getContext("2d").clearRect 0,0,renderCanvas.width, renderCanvas.height
  window.TyfulNacl.resetShoppingWindows()
  window.TyfulNacl.TyfulNaclCoreModule.postMessage "updateTemplate:" + canvasWidth + "," + canvasHeight
  window.TyfulNacl.TyfulNaclCoreModule.postMessage imageData.data.buffer
  window.TyfulNacl.TyfulNaclCoreModule.postMessage "startRender:"

window.TyfulNacl.drawGradients = (ctxColor, canvasColor)->
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

window.TyfulNacl.TyfulNaclCoreModule = null # Global application object
window.TyfulNacl.statusText = "NO-STATUS"

# Indicate load success.
window.TyfulNacl.moduleDidLoad = ->
  window.TyfulNacl.TyfulNaclCoreModule = document.getElementById("tyful_nacl_client")
  window.TyfulNacl.updateStatus "SUCCESS"


# The 'message' event handler.  This handler is fired when the NaCl module
# posts a message to the browser by calling PPB_Messaging.PostMessage()
# (in C) or pp::Instance.PostMessage() (in C++).  This implementation
# simply displays the content of the message in an alert panel.

# If the page loads before the Native Client module loads, then set the
# status message indicating that the module is still loading.  Otherwise,
# do not change the status message.
window.TyfulNacl.pageDidLoad = ->
  unless TyfulNaclCoreModule?
    updateStatus "LOADING..."
  else
    
    # It's possible that the Native Client module onload event fired
    # before the page's onload event.  In this case, the status message
    # will reflect 'SUCCESS', but won't be displayed.  This call will
    # display the current message.
    updateStatus()


# Set the global status message.  If the element with id 'statusField'
# exists, then set its HTML to the status message as well.
# opt_message The message test.  If this is null or undefined, then
# attempt to set the element with id 'statusField' to the value of
# |statusText|.
window.TyfulNacl.updateStatus = (opt_message) ->
  statusText = opt_message  if opt_message
  statusField = document.getElementById("status_field")
  statusField.innerHTML = statusText  if statusField

window.TyfulNacl.slapShapeMethodPrefix = "slapShape:"
window.TyfulNacl.feedMeMethodPrefix = "feedMe:"
window.TyfulNacl.feedShapeMethodPrefix = "feedShape:"
window.TyfulNacl.feedShapes = (num, shrinkage) ->
  canvas = $("#sketch")[0]
  # ctx = canvas.getContext("2d")
  i = 0

  while i < num
    fontSize = 10 + 100 * shrinkage
    # fontStyle = "bold " + fontSize + "px sans-serif"
    # ctx.font = fontStyle
    # ctx.textBaseline = "top"
    str = window.TyfulNacl.words[Math.floor(Math.random() * window.TyfulNacl.words.length)]
    # dimensions = ctx.measureText(str)
    # dimensions.height = window.TyfulNacl.determineFontHeight(str, ctx.font)
    shapeCanvas = document.createElement("canvas")
    # shapeCanvasF = new fabric.Canvas(shapeCanvas,
    #   perPixelTargetFind: true
    # )
    tF = new fabric.Text(str, 
      fontFamily: "Arial"
      fill: "#000000"
      fontSize: fontSize
      # scaleX: shrinkage*0.9+0.1
      # scaleY: shrinkage*0.9+0.1
      top: 0
      left: 0
      fontWeight: "bold"
      useNative: true
    )
    tF.top = tF.height/2
    tF.left = tF.width/2
    window.TyfulNacl.sid++
    window.TyfulNacl.shapes[window.TyfulNacl.sid] = tF

    shapeCanvas.setAttribute "width", tF.width*tF.scaleX
    shapeCanvas.setAttribute "height", tF.height*tF.scaleY
    context = shapeCanvas.getContext("2d")
    
    # context.fillStyle = '#ffffff';
    # context.fillRect(0,0,shapeCanvas.width, shapeCanvas.height);
    # context.fillStyle = "#ff00ff"
    # context.font = fontStyle
    # context.textBaseline = "top"
    # context.fillText str, 0, 0

    # shapeCanvasF.add tF
    tF.render(context,true)
    # console.log 'sid: '+window.TyfulNacl.sid+"w: "+shapeCanvas.width+", h:"+shapeCanvas.height
    # shapeCanvasF.renderAll(true)
    window.TyfulNacl.TyfulNaclCoreModule.postMessage window.TyfulNacl.feedShapeMethodPrefix + (window.TyfulNacl.sid) + "," + shapeCanvas.width + "," + shapeCanvas.height
    window.TyfulNacl.TyfulNaclCoreModule.postMessage shapeCanvas.getContext('2d').getImageData(0, 0, shapeCanvas.width, shapeCanvas.height).data.buffer
    i++


# document.body.appendChild(shapeCanvas);

# console.log("shape fed from server. w: "+shapeCanvas.width + ",h: "+ shapeCanvas.height);
window.TyfulNacl.slap = (sid, x, y, rotation, layer, color, failureCount) ->
  sid = parseInt(sid)
  x = parseInt(x)
  y = parseInt(y)
  rotation = parseFloat(rotation)
  layer = parseInt(layer)
  color = parseInt(color)
  failureCount = parseInt(failureCount)

  context = document.getElementById("renderpreview").getContext("2d")
  shape = window.TyfulNacl.shapes[sid]
  
  #check for null because the rendering process may have 
  #been interrupted
  if shape
    # width = shape.width
    # height = shape.height
    # context.save()
    # context.translate x + width / 2, y + height / 2
    # context.rotate -rotation
    # context.translate -x - width / 2, -y - height / 2
    # context.drawImage shape, x, y, shape.width, shape.height
    # context.restore()
    shape.left = x+shape.width/2
    shape.top = y+shape.height/2
    shape.setColor "#"+(color&0x00FFFFFF).toString(16)
    shape.setAngle(-rotation/Math.PI/2*360)
    window.renderCanvas.add shape
  window.TyfulNacl.redrawShoppingWindows()

window.TyfulNacl.redrawShoppingWindows = ->
  context = $('#renderpreview')[0].getContext("2d")
  context.drawImage($('#renderer')[0],0,0)
  $(".shopping-window").each ->
    context = @getContext("2d")
    context.drawImage $("#renderer")[0], 0, 0


window.TyfulNacl.handleMessage = (message_event) ->
  if message_event.data
    
    # console.log(message_event.data);
    if message_event.data.indexOf(window.TyfulNacl.slapShapeMethodPrefix) is 0
      params = message_event.data.substring(window.TyfulNacl.slapShapeMethodPrefix.length)
      
      # try{
      eval "window.TyfulNacl.slap(" + params + ");"
    
    # }
    # catch(e){
    # console.log("Slap error: '"+params+"'");
    # window.TyfulNacl.slapLater.push(params);
    # }
    else if message_event.data.indexOf(window.TyfulNacl.feedMeMethodPrefix) is 0
      params = message_event.data.substring(window.TyfulNacl.feedMeMethodPrefix.length)
      eval "window.TyfulNacl.feedShapes(" + params + ");"