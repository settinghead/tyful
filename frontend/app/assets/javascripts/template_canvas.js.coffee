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
				defaultDirection: 0
				defaultSize: 100
			}, opts
			@painting = false
			@color = @options.defaultColor
			@direction = @options.defaultDirection
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

			@_main.bind 'click mousedown mouseup mousemove mouseleave mouseout touchstart touchmove touchend touchcancel', @onEvent
			if @options.toolLinks
				$('body').delegate "a[href=\"##{@_main.attr('id')}\"]", 'click', (e)->
					$this = $(this)
					$canvas = $($this.attr('href'))
					tsketch = $canvas.data('tsketch')
					for key in ['color', 'direction', 'size', 'tool']
						if $this.attr("data-#{key}")
							tsketch.set key, $(this).attr("data-#{key}")
					if $(this).attr('data-download')
						tsketch.download $(this).attr('data-download')
					false

		set: (key, value)->
			this[key] = value
			@_main.trigger("tsketch.change#{key}", value)

		getWidth: ->
			@_main[0].width
		getHeight: ->
			@_main[0].height

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
				direction: @direction
				size: parseFloat(@size)
				events: []
			}
			# @origin = new Point(event.x,event.y)

		stopPainting: ->
			@actions.push @action if @action
			@painting = false
			@action = null
			@redraw()

		angleToRGBColor: (angle) ->
			h = -angle/360
			s = 0.5
			l = 0.5
			r = undefined
			g = undefined
			b = undefined
			if s is 0
				r = g = b = l # achromatic
			else
				hue2rgb = (p, q, t) ->
					t += 1	if t < 0
					t -= 1	if t > 1
					return p + (q - p) * 6 * t	if t < 1 / 6
					return q	if t < 1 / 2
					return p + (q - p) * (2 / 3 - t) * 6	if t < 2 / 3
					p
				q = (if l < 0.5 then l * (1 + s) else l + s - l * s)
				p = 2 * l - q
				r = hue2rgb(p, q, h + 1 / 3)
				g = hue2rgb(p, q, h)
				b = hue2rgb(p, q, h - 1 / 3)
			"rgba(#{Math.floor(r * 255)},#{Math.floor(g * 255)},#{Math.floor(b*255)},255)"


		onEvent: (e)->
			if e.originalEvent && e.originalEvent.targetTouches
				e.pageX = e.originalEvent.targetTouches[0].pageX
				e.pageY = e.originalEvent.targetTouches[0].pageY
			$.tsketch.tools[$(this).data('tsketch').tool].onEvent.call($(this).data('tsketch'), e)
			e.preventDefault()
			false

		loadImage: (img) ->
			w = img.width
			h = img.height
			if w > 1000
				ratio = w / h
				w = 1000
				h = w / ratio
			if h > 2000
				ratio = w / h
				h = 2000
				w = h * ratio
			if w < 800
				ratio = w / h
				w = 800
				h = w / ratio
			if h < 600
				ratio = w / h
				h = 600
				w = h * ratio
			@_direction.width = @_color.width = @_main[0].width = w
			@_direction.height = @_color.height = @_main[0].height = h
			@colorContext.drawImage img, 0,0, w, h
			@directionContext.fillStyle = "#FFFFFF"
			@directionContext.fillRect 0,0,w,h
			@_main[0].getContext('2d').drawImage img,0,0,w,h

		redraw: ->
			# @el.width = @_main.width()
			@context = @el.getContext '2d'
			tsketch = this
			# $.each @actions, ->
				# if this.tool
					# $.tsketch.tools[this.tool].draw.call tsketch, this
			$.tsketch.tools[@action.tool].draw.call tsketch, @action if @painting && @action

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
			@colorContext.beginPath()
			# @directionContext.strokeStyle = @angleToRGBColor(action.direction)
			@colorContext.strokeStyle = action.color
			@colorContext.lineWidth = @directionContext.lineWidth = action.size
			@context.font = "bold 11px Arial"
			@directionContext.moveTo action.events[0].x, action.events[0].y
			@colorContext.moveTo action.events[0].x, action.events[0].y
			# rad = action.direction * Math.PI * 2 / 360
			previous = null
			maxX = maxY = 0
			minX = minY = 9007199254740992
			@context.globalCompositeOperation = "source-over"
			i = action.events.length - 2
			i = 0 if i < 0
			while i < action.events.length
				event = action.events[i]
				if previous
					# rad = action.direction * Math.PI * 2 / 360
					rad = Math.atan (event.y-previous.y)/(event.x-previous.x)
					@directionContext.beginPath()
					@directionContext.moveTo previous.x, previous.y
					@colorContext.moveTo previous.x, previous.y
					@directionContext.strokeStyle = @angleToRGBColor(rad*360/Math.PI/2)
					@directionContext.lineTo event.x, event.y
					@colorContext.lineTo event.x, event.y
					@directionContext.stroke()
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
							if Math.sqrt(Math.pow(y-event.y,2)+Math.pow(x-event.x,2)) <= action.size / 2
								# @context.clearRect x,y,11,11
								@context.moveTo(x,y)
								@context.save()
								@context.translate x,y
								@context.rotate rad
								@context.translate -x, -y
								@context.fillText 'A',x,y
								@context.restore()
							y += 11
						x += 11
					minX = startGridX if startGridX < minX
					minY = startGridY if startGridY < minY
					maxX = endGridX if endGridX > maxX
					maxY = endGridY if endGridY > maxY
				previous = event
				i++

				# @context.clearRect minX, minY, maxX-minX, maxY-minY
				# x = minX
				# while x < maxX
				# 	y = minY
				# 	while y < maxY
				# 		@context.moveTo(x,y)
				# 		@context.save()
				# 		@context.translate x+11/2,y+11/2
				# 		@context.rotate rad
				# 		@context.translate -x-11/2, -y-11/2
				# 		@context.fillText 'A',x,y
				# 		@context.restore()
				# 		y += 11
				# 	x += 11

			@colorContext.stroke()
			@context.globalCompositeOperation = "source-in"
			@context.drawImage(@_color,0,0)
			@context.globalCompositeOperation = "destination-in"
			@context.drawImage(@_direction,0,0)

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
