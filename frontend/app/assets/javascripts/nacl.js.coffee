//=require jquery.easing
//=require images
//=require paper.js
//=require jquery.knob.js

window.TyfulNacl = new Object()
paper.install(window)

$(document).ready ->
  $(".knob").knob();

  $('.fontselect').fontselect();
  $('.fontselect').change ()->
    o = window.renderCanvas.getActiveObject()
    if(o)
      o.fontFamily = $(this).val().replace(/\+/g," ")
      window.renderCanvas.renderAll()
      window.TyfulNacl.dropPinOn(o)
      window.TyfulNacl.fixShape o
  
  window.TyfulNacl.fixedShapes = {}
  window.TyfulNacl.words = ["C-3PO", "橙子", "passion", "knob", "可笑可乐", "Circumstances\n do not make the man.\nThey reveal him.", "The self always\n comes through.", "Forgive me.\nYou have my soul and \n I have your money.", "War rages on\n in Africa.", "Quick fox", "Halo", "Service\nIndustry\nStandards", "Tyful", "Γαστριμαργία", "Πορνεία", "Φιλαργυρία", "Ὀργή", "compassion", "ice cream", "HIPPO", "inferno", "Your\nname", "To be\n or not to be", "床前明月光\n疑是地上霜\n举头望明月\n低头思故乡"]
  window.strokeColor = 'black'
  fabric.Canvas.prototype.getAbsoluteCoords = (object) ->
    left: object.left + @_offset.left
    top: object.top + @_offset.top

  $('#tyfulTabs a').click (e) ->
    e.preventDefault()
    $(this).tab 'show'
  $('#tyfulTabs a#adjustButton').on 'shown', (e) ->
    window.renderCanvas.calcOffset()

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
  # $("#sketch").sketch defaultSize:100
  paper.setup('sketch')
  project.colorLayer = project.activeLayer
  project.directionLayer = new Layer()
  project.directionVectorLayer = new Layer()
  project.directionLayer.setVisible false
  project.directionVectorLayer.setVisible false
  project.directionIndicatorLayer = new Layer()
  project.directionLayer.activate()

  tool = new Tool()
  path = null
  origin = null
  tool.onMouseDown = (event) ->
    origin = event.point
  tool.onMouseDrag = (event) ->
    unless path?
      path = new Path()
      path.strokeColor = window.strokeColor
      path.strokeWidth = 100
      path.add(origin)
    path.add(event.point)
  tool.onMouseUp = (event) ->
    if path?
      project.directionVectorLayer.addChild path
      window.TyfulNacl.resetRenderer()
      window.TyfulNacl.startRendering()
      #path.smooth()
      path = null

  if false
    $("#loader").load ->
      $('#sketch')[0].width = $("#loader").width()
      $('#sketch')[0].height = $("#loader").height()
      raster = new Raster('loader')
      raster.setPosition new Point(raster.width/2,raster.height/2)
      window.TyfulNacl.reloadCanvas()
      # $('#sketch')[0].getContext('2d').drawImage(this,0,0)
      window.TyfulNacl.resetRenderer()
      window.TyfulNacl.startRendering()

    $("#loader").attr "src","/templates/dog.png"
  else
    window.TyfulNacl.reloadCanvas()


  $("#render-editor").scroll (e) ->
    $.each window.TyfulNacl.fixedShapes,(key,value)->
      window.TyfulNacl.dropPinOn(value)

  # canvas.renderAll()

  #end onlonad
    

  $(".btnRegenerate").click ->
    window.TyfulNacl.resetRenderer()
    window.TyfulNacl.startRendering()
  $(".btnModify").click ->
    window.TyfulNacl.modifyCanvas()
  
  $("#sketch").on "touchend",()->
    window.TyfulNacl.resetRenderer()
    window.TyfulNacl.startRendering()

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
    # $("#sketch").sketch().color = pixelColor
    window.strokeColor = new RgbColor(pixel[0]/256,pixel[1]/256,pixel[2]/256,pixel[3]/256)

  $("#renderpreview").click (event) ->
    event.preventDefault()
    $("#tyfulTabs a#adjustButton").tab('show');

  # $('#tyful_nacl_client').on("load", ()->
  #   alert('loaded')
  # )

window.TyfulNacl.dropPinOn = (obj)->
  unless obj.hasOwnProperty("pin")
    obj.pin = document.createElement('img')
    # pinContent = document.createTextNode("PIN");
    # obj.pin.appendChild(pinContent)
    obj.pin.setAttribute 'src',image_path('pin.png')
    obj.pin.style.position = "absolute"
    $('#render-editor').append($(obj.pin))
    obj.setOpacity 1
    obj.on('moving', ->
      window.TyfulNacl.positionPin(obj)
    )
    window.TyfulNacl.positionPin(obj)

window.TyfulNacl.reloadCanvas = () ->
  window.renderCanvas.dispose() if window.renderCanvas
  $('#renderpreview')[0].width = $("#sketch")[0].width
  $('#renderpreview')[0].height = $("#sketch")[0].height
  # $("#renderpreview")[0].height = $("#renderpreview").height()
  # $("#renderpreview")[0].width = $("#renderpreview").width()

  $('#renderer')[0].width = $("#sketch")[0].width
  $('#renderer')[0].height = $("#sketch")[0].height
  window.renderCanvas = new fabric.Canvas('renderer',
      hoverCursor: "pointer"
      selection: false
    )
    # window.renderCanvas.HOVER_CURSOR = 'pointer';
  window.renderCanvas.on
    "object:modified": (e) ->
      window.TyfulNacl.fixShape e.target

window.TyfulNacl.fixShape = (shape) ->
  shape.bringToFront()
  window.TyfulNacl.dropPinOn(shape)
  console.log("feeding shape from fixShape.")
  window.TyfulNacl.feedShape shape
  # window.TyfulNacl.TyfulNaclCoreModule.postMessage "fixShape:" + shape.sid + "," + shape.getLeft() + "," + shape.getTop() + "," + (-shape.getAngle()*Math.PI*2/360) + ","+shape.scaleX+","+shape.scaleY+","
  window.TyfulNacl.TyfulNaclCoreModule.postMessage "fixShape " + shape.sid + " " + shape.getLeft() + " " + shape.getTop() + " " + (-shape.getAngle()*Math.PI*2/360) + " 1 1"
  # window.TyfulNacl.fixedShapes[e.target.sid] = e.target
  window.TyfulNacl.fixedShapes[shape.sid] = shape
  console.log shape.sid
  window.TyfulNacl.redrawShoppingWindows()

window.TyfulNacl.positionPin = (obj) ->

  absCoords = window.renderCanvas.getAbsoluteCoords(obj)
  obj.pin.style.left = (absCoords.left) + 'px'
  finalTop = (absCoords.top) - 40
  finalLeft = (absCoords.left) - 20

  unless obj.pin.animated
    obj.pin.style.top = 'ppx'
    obj.pin.style.left = (absCoords.left) + absCoords.top * Math.tan(0.523) + 'px'
    $(obj.pin).animate(
      top: finalTop
      left: finalLeft
    ,
      duration: "fast"
      # easing: "easeOutBounce"
    )
    obj.pin.animated = true
  obj.pin.style.top = finalTop + 'px'
  obj.pin.style.left = finalLeft + 'px'

window.TyfulNacl.resetShoppingWindows = ->
  $(".shopping-window").each ->
    this.getContext('2d').clearRect(0,0,this.width,this.height)
  window.renderCanvas.forEachObject((obj)->
    window.renderCanvas.remove obj unless obj and obj.hasOwnProperty("pin")
  )
    

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

window.TyfulNacl.modifyCanvas = ->
  window.TyfulNacl.TyfulNaclCoreModule.postMessage "modifyCanvas "
  #remove colliding shapes
  $.each window.TyfulNacl.fixedShapes,(key,value)->
    for shape in window.TyfulNacl.shapes[key].overlaps
      window.TyfulNacl.shapes[shape.sid] = undefined
      window.renderCanvas.remove shape
  window.renderCanvas.renderAll()


window.TyfulNacl.resetRenderer = ->
  canvas = $("#sketch")[0]
  window.TyfulNacl.shapes = {}
  window.TyfulNacl.slapLater = []
  window.TyfulNacl.sid = 0
  window.TyfulNacl.initializing = false
  renderCanvas = $("#renderpreview")[0]
  renderCanvas.getContext("2d").clearRect 0,0,renderCanvas.width, renderCanvas.height
  window.TyfulNacl.resetShoppingWindows()

window.TyfulNacl.startRendering = ->
  window.TyfulNacl.status = "updating"
  canvas = $("#sketch")[0]
  canvasWidth = canvas.width
  canvasHeight = canvas.height
  window.TyfulNacl.TyfulNaclCoreModule.postMessage "updateTemplate " + canvasWidth + " " + canvasHeight


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
window.TyfulNacl.feedShapeMethodPrefix = "feedShape"
window.TyfulNacl.initCompletePrefix = "initComplete:"
window.TyfulNacl.templateDataReceivedPrefix = "templateDataReceived:"
window.TyfulNacl.obscureSidsMethodPrefix = "obscureSids:"
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
      useNative: true
      fontWeight: "bold"
    )

    tF.setTop tF.height/2
    tF.setLeft tF.width/2
    tF.lockUniScaling = true
    #add fixed shapes
    $.each window.TyfulNacl.fixedShapes, (key,value)->
      window.TyfulNacl.shapes[key] = value
    loop
      window.TyfulNacl.sid++
      break unless window.TyfulNacl.shapes[window.TyfulNacl.sid]
    tF.sid = window.TyfulNacl.sid
    console.assert(window.TyfulNacl.shapes[tF.sid]==undefined)
    window.TyfulNacl.shapes[tF.sid] = tF
    window.TyfulNacl.feedShape tF, shrinkage
    # console.log feedCommandStr

    i++

window.TyfulNacl.feedShape = (shape, shrinkage) ->
  shrinkage = 0 if not shrinkage
  shapeCanvas = document.createElement("canvas")
  shapeCanvas.setAttribute "width", shape.width*shape.scaleX
  shapeCanvas.setAttribute "height", shape.height*shape.scaleY
  context = shapeCanvas.getContext("2d")
  angle = shape.getAngle()
  top = shape.getTop()
  left = shape.getLeft()
  shape.setAngle(0)
  shape.setTop shape.getHeight()/2
  shape.setLeft shape.getWidth()/2
  shape.render(context,true)
  feedCommandStr = window.TyfulNacl.feedShapeMethodPrefix + " " + (shape.sid) + " " + shapeCanvas.width + " " + shapeCanvas.height+" "+shrinkage

  unless window.TyfulNacl.status
    window.TyfulNacl.status = "feeding"
    window.TyfulNacl.TyfulNaclCoreModule.postMessage feedCommandStr
    window.TyfulNacl.TyfulNaclCoreModule.postMessage shapeCanvas.getContext('2d').getImageData(0, 0, shapeCanvas.width, shapeCanvas.height).data.buffer
    window.TyfulNacl.status = undefined

  shape.setAngle(angle)
  shape.setTop(top)
  shape.setLeft(left)

window.TyfulNacl.decimalColorToHTMLcolor = (number) ->
  
  #converts to a integer
  intnumber = number - 0
  
  # isolate the colors - really not necessary
  red = undefined
  green = undefined
  blue = undefined
  
  # needed since toString does not zero fill on left
  template = "#000000"
  
  # in the MS Windows world RGB colors
  # are 0xBBGGRR because of the way Intel chips store bytes
  blue = (intnumber & 0x0000ff) << 16
  green = intnumber & 0x00ff00
  red = (intnumber & 0xff0000) >>> 16
  
  # mask out each color and reverse the order
  intnumber = red | green | blue
  
  # toString converts a number to a hexstring
  HTMLcolor = intnumber.toString(16)
  
  #template adds # for standard HTML #RRGGBB
  HTMLcolor = template.substring(0, 7 - HTMLcolor.length) + HTMLcolor
  HTMLcolor



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
    shape.set
      top: y
      left: x
      angle: -rotation/Math.PI/2*360
    c = window.TyfulNacl.decimalColorToHTMLcolor color
    c = "#eeeeee" if c == "#FFFFFF"
    shape.setColor c
    window.renderCanvas.add shape
    shape.sendToBack()
    $.each window.TyfulNacl.fixedShapes, (key,value)->
      value.sendToBack()
  window.TyfulNacl.redrawShoppingWindows()

window.TyfulNacl.redrawShoppingWindows = ->
  context = $('#renderpreview')[0].getContext("2d")
  context.clearRect(0,0,$('#renderpreview')[0].width,$('#renderpreview')[0].height)
  context.drawImage($('#renderer')[0],0,0, $("#renderpreview")[0].width, $("#renderpreview")[0].height)
  $(".shopping-window").each ->
    context = @getContext("2d")
    context.clearRect(0,0,@width,@height)
    context.drawImage window.renderCanvas.lowerCanvasEl, 0, 0
    window.renderCanvas.calcOffset()


window.TyfulNacl.handleMessage = (message_event) ->
  if message_event.data
    # console.log(message_event.data) if message_event.data.indexOf("DEBUG_POSTMESSAGE") is 0
    # console.log(message_event.data) 
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
    else if message_event.data.indexOf(window.TyfulNacl.initCompletePrefix) is 0
      #received init canvas complete message; updating binary
      canvas = $("#sketch")[0]
      canvasWidth = canvas.width
      canvasHeight = canvas.height
      $('#sketchBuffer')[0].width = canvasWidth
      $('#sketchBuffer')[0].height = canvasHeight
      ctx = $('#sketchBuffer')[0].getContext('2d')
      # ctx = canvas.getContext("2d")
      l = project.directionLayer
      l.draw(ctx,{})
      # ctx = r.context
      imageData = ctx.getImageData(0, 0, canvasWidth, canvasHeight)
      window.TyfulNacl.TyfulNaclCoreModule.postMessage imageData.data.buffer
      window.TyfulNacl.status = undefined
      # console.log('Template data transferred.')
    else if message_event.data.indexOf(window.TyfulNacl.templateDataReceivedPrefix) is 0
      window.TyfulNacl.TyfulNaclCoreModule.postMessage "startRender "
    else if message_event.data.indexOf(window.TyfulNacl.obscureSidsMethodPrefix) is 0
      sids = message_event.data.substring(window.TyfulNacl.obscureSidsMethodPrefix.length).split(",")
      this_sid = parseInt(sids[0])
      #restore opacity
      shape = window.TyfulNacl.shapes[this_sid]
      if shape.overlaps
        for o in shape.overlaps
          o.setOpacity 1
      sids = sids.slice(1,sids.length)
      window.TyfulNacl.shapes[this_sid].overlaps = []
      for sid in sids
        if(sid.length>0)
          sid = parseInt(sid)
          console.log sid
          shape = window.TyfulNacl.shapes[sid]
          window.TyfulNacl.shapes[this_sid].overlaps.push shape
          # shape.setOpacity 0.15 if not window.TyfulNacl.fixedShapes[sid]
          shape.setOpacity 0.15
      window.renderCanvas.renderAll()

