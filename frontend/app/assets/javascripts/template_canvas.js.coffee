//= require jquery
//= require jquery-ui
(($)->
	$.fn.tsketch = (key, args...) ->
		tsketch = this.data('tsketch')
		if typeof(key) == 'string' && tsketch
			if tsketch[key]
				if typeof(tsketch[key]) == 'function'
					tsketch[key].apply tsketch, args
				else if args.length == 0
					tsketch[key]
				else if args.length == 1
					tsketch[key] = args[0]
			else
				$.error('TemplateSketch.js did not recognize the given command.')
		else if tsketch
			tsketch
		else
			this.data('tsketch', new TemplateSketch(this.get(0), key))
			this

	class TemplateSketch
		constructor: (canvasElement, opts)->
			@el = canvasElement
			@_main = $(canvasElement)
			@context = canvasElement.getContext '2d'
			@options = $.extend {
				toolLinks: true
				defaultTool: 'marker'
				defaultColor: '#000000'
				defaultSize: 50
			}, opts
			@painting = false
			@color = @options.defaultColor
			@size = @options.defaultSize
			@tool = @options.defaultTool
			@actions = []
			@action = []

			@_direction = document.createElement("canvas")
			@directionContext = @_direction.getContext('2d')
			@_color = document.createElement("canvas")
			@colorContext = @_color.getContext('2d')

			@_direction.width = @_color.width = @_main.width()
			@_direction.height = @_color.height = @_main.height()

			# tool = new @Tool()
			# path = null
			# origin = null
			# drawing = false

			# tool.onMouseUp = (event) ->
			# if path?
			# 	console.log path
			# 	path.smooth()
			# 	project.redrawTextIndicator path
			# 	project.directionLayer.addChild path.rasterize()
			# 	project.colorLayer.addChild path.rasterize()
			# 	project.directionVectorLayer.setVisible false
			# 	project.directionLayer.setVisible false
			# 	project.colorLayer.setVisible false
			# 	window.TyfulNacl.resetRenderer()
			# 	window.TyfulNacl.startRendering()
			# 	path = null

			@_main.bind 'click mousedown mouseup mousemove mouseleave mouseout touchstart touchmove touchend touchcancel', @onEvent
			if @options.toolLinks
				$('body').delegate "a[href=\"##{@_main.attr('id')}\"]", 'click', (e)->
					$this = $(this)
					$canvas = $($this.attr('href'))
					tsketch = $canvas.data('tsketch')
					for key in ['color', 'size', 'tool']
						if $this.attr("data-#{key}")
							tsketch.set key, $(this).attr("data-#{key}")
					if $(this).attr('data-download')
						tsketch.download $(this).attr('data-download')
					false

		set: (key, value)->
			this[key] = value
			@_main.trigger("tsketch.change#{key}", value)

		download: (format)->
			format or= "png"
			format = "jpeg" if format == "jpg"
			mime = "image/#{format}"
			window.open @el.toDataURL(mime)

		startPainting: ->
			@painting = true
			@action = {
				tool: @tool
				color: @color
				size: parseFloat(@size)
				events: []
			}
			# @origin = new Point(event.x,event.y)

		stopPainting: ->
			@actions.push @action if @action
			@painting = false
			@action = null
			@redraw()


		onEvent: (e)->
			if e.originalEvent && e.originalEvent.targetTouches
				e.pageX = e.originalEvent.targetTouches[0].pageX
				e.pageY = e.originalEvent.targetTouches[0].pageY
			$.tsketch.tools[$(this).data('tsketch').tool].onEvent.call($(this).data('tsketch'), e)
			e.preventDefault()
			false

		onEvent: (e)->
			if e.originalEvent && e.originalEvent.targetTouches
				e.pageX = e.originalEvent.targetTouches[0].pageX
				e.pageY = e.originalEvent.targetTouches[0].pageY
			$.tsketch.tools[$(this).data('tsketch').tool].onEvent.call($(this).data('tsketch'), e)
			e.preventDefault()
			false

		redraw: ->
			@el.width = @_main.width()
			@context = @el.getContext '2d'
			tsketch = this
			$.each @actions, ->
				if this.tool
					$.tsketch.tools[this.tool].draw.call tsketch, this
			$.tsketch.tools[@action.tool].draw.call tsketch, @action if @painting && @action


			# project.colorLayer = project.activeLayer
			# project.directionLayer = new Layer()
			# project.directionVectorLayer = new Layer()
			# project.colorLayer.setVisible false
			# project.directionVectorLayer.setVisible false
			# project.directionLayer.setVisible false
			# project.directionIndicatorLayer = new Layer()
			# project.directionIndicatorRaster = new Raster($('#directionIndicator')[0])
			# project.directionRaster = new Raster($('#direction')[0])
			# project.directionIndicatorRaster.remove()
			# project.directionRaster.remove()
			# project.directionIndicatorLayer.addChild project.directionIndicatorRaster
  # project.directionIndicatorLayer.setClipMask true
  # project.directionLayer.activate()

		# $(@_main).mousedown (event) ->
		# 	# project.directionVectorLayer.setVisible true
		# 	origin = event.point
		# $(@_main).mousedrag = (event) ->
		# 	unless path?
		# 		path = new Path()
		# 		path.remove()
		# 		path.strokeColor = window.strokeColor
		# 		path.strokeWidth = 100
		# 		path.strokeCap = 'round';
		# 	path.add(origin)
		# 	s = path.segments.length
		# 	path.add(event.point)
		# 	e = path.segments.length

	$.tsketch = { tools: {} }

	$.tsketch.tools.marker =
		onEvent: (e)->
			switch e.type
				when 'mousedown', 'touchstart'
					@startPainting()
				when 'mouseup', 'mouseout', 'mouseleave', 'touchend', 'touchcancel'
					@stopPainting()
			if @painting
				@action.events.push
					x: e.pageX - @_main.offset().left
					y: e.pageY - @_main.offset().top
					event: e.type
				@redraw()

		draw: (action)->
			@colorContext.lineJoin = @directionContext.lineJoin = "round"
			@colorContext.lineCap = @directionContext.lineCap = "round"
			@directionContext.beginPath()
			@colorContext.beginPath()
			@directionContext.strokeStyle = action.color
			@colorContext.strokeStyle = action.color
			@colorContext.lineWidth = @directionContext.lineWidth = action.size
			@context.font = "bold 11px Arial"

			@directionContext.moveTo action.events[0].x, action.events[0].y
			@colorContext.moveTo action.events[0].x, action.events[0].y

			previous = null
			maxX = maxY = 0
			minX = minY = 9007199254740992
			@context.globalCompositeOperation = "source-over"
			for event in action.events
				@directionContext.lineTo event.x, event.y
				@colorContext.lineTo event.x, event.y
				if previous
					startGridX = Math.min(event.x, previous.x)
					startGridX -= action.size/2
					startGridX -= startGridX % 11
					endGridX = Math.max(event.x, previous.x)
					endGridX += action.size/2
					startGridY = Math.min(event.y, previous.y)
					startGridY -= action.size/2
					startGridY -= startGridY % 11
					endGridY = Math.max(event.y, previous.y)
					endGridY += action.size/2
					# @context.clearRect startGridX, startGridY, endGridX-startGridX, endGridY-startGridY
					x = startGridX
					while x < endGridX
						y = startGridY
						while y < endGridY
							@context.moveTo(x,y)
							@context.fillText 'A',x,y
							y += 11
						x += 11
					minX = startGridX if startGridX < minX
					minY = startGridY if startGridY < minY
					maxX = endGridX if endGridX > maxX
					maxY = endGridY if endGridY > maxY
				previous = event

			@directionContext.stroke()
			@colorContext.stroke()
			@context.globalCompositeOperation = "source-in"
			@context.drawImage(@_color,0,0)
			@context.globalCompositeOperation = "destination-in"
			@context.drawImage(@_direction,0,0)



		redrawTextIndicator: (action,segStartIndex, segEndIndex) ->
			segStartIndex = 0 unless segStartIndex?
			segEndIndex = action.events.length unless segEndIndex?
			# segs = []
			# i = segStartIndex
			# while i < segEndIndex
			#   segs.push path.segments[i].point
			#   i++
			# subpath = new Path(segs)
			# subpath.strokeWidth = path.strokeWidth
			# startGridX = subpath.strokeBounds.left - subpath.strokeBounds.left % 11
			# startGridY = subpath.strokeBounds.top - subpath.strokeBounds.top % 11
			@_dicontext.clearRect(0,0,@el.width,@el.height)
			# @_dicontext.drawImage(@directionRaster.image,0,0,project.directionRaster.image.width,project.directionRaster.image.height)
			# startGridX = path.segments[segStartIndex].point.x - path.strokeWidth/2 - path.segments[segStartIndex].point.x % 11
			# startGridY = path.segments[segmentsgStartIndex].point.y - path.strokeWidth/2 - path.segments[segStartIndex].point.y % 11
			# x = startGridX
			x = 0
			# while x < path.segments[segEndIndex-1].point.x + path.strokeWidth
			while x < @_main.width()
				# y = startGridY
				y = 0
				# while y < path.segments[segEndIndex-1].point.y + path.strokeWidth
				while y < @_main.height()
					console.log "#{x},#{y}"
					# p = new Point(x, y)
					# if path.hitTest(p)
					@_dicontext.moveTo(x,y)
					@_dicontext.fillStyle = "blue"
					@_dicontext.font = "bold 11px Arial"
					@_dicontext.fillText 'A',x,y
					#console.log(text)
					y += 11
				x += 11

	$.tsketch.tools.magicmarker =
		onEvent: (e)->
			switch e.type
				when 'mousedown', 'touchstart'
					@startPainting()
				when 'mouseup', 'mouseout', 'mouseleave', 'touchend', 'touchcancel'
					@stopPainting()
			if @painting
				@action.events.push
					x: e.pageX - @_main.offset().left
					y: e.pageY - @_main.offset().top
					event: e.type

				@redraw()

		draw: (action)->
			#TODO

	$.tsketch.tools.eraser =
		onEvent: (e)->
			$.tsketch.tools.marker.onEvent.call this, e
		draw: (action)->
			oldcomposite = @context.globalCompositeOperation
			@context.globalCompositeOperation = "copy"
			action.color = "rgba(0,0,0,0)"
			$.tsketch.tools.marker.draw.call this, action
			@context.globalCompositeOperation = oldcomposite
)(jQuery)
