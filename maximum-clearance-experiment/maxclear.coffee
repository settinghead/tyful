Object.size = (obj) ->
  size = 0
  key = undefined
  for key of obj
    size++  if obj.hasOwnProperty(key)
  size

$ ->
	$img = $("<img>",
        src: "wheel_v.png"
    )
	$img.load ->
		$('#source')[0].width = this.height
		$('#source')[0].height = this.height
		$('#source')[0].getContext('2d').drawImage this, 0,0,$('#source')[0].width,$('#source')[0].height
		window.maxClearance = new MaxClearance($('#source')[0],$('#main')[0])
		window.maxClearance.compute()
	$('#main').mousemove (e) ->
		xx = (e.offsetX - e.offsetX % window.maxClearance.unit)/window.maxClearance.unit
		yy = (e.offsetY - e.offsetY % window.maxClearance.unit)/window.maxClearance.unit
		$('#value_watch').html Object.size(window.maxClearance.V["#{xx*window.maxClearance.unit},#{yy*window.maxClearance.unit}"].crossers)
		# $('#value_watch').html window.maxClearance.distData[xx+yy*$('#main')[0].width]
		# $('#value_watch').html window.maxClearance.distData[xx+yy*$('#main')[0].width]
	$('#main').click (e) ->
		shape = document.createElement "canvas"
		shape.width = shape.height = 100
		scontext = shape.getContext '2d'
		scontext.beginPath()
		scontext.arc 50,50,50,0,2* Math.PI, false
		scontext.fillStyle = 'green'
		scontext.fill()

		xx = (e.offsetX - e.offsetX % window.maxClearance.unit)/window.maxClearance.unit
		yy = (e.offsetY - e.offsetY % window.maxClearance.unit)/window.maxClearance.unit

		context = $('#source')[0].getContext('2d')
		context.globalCompositeOperation = "destination-out"
		context.drawImage shape,e.offsetX-50, e.offsetY-50
		window.maxClearance.erase shape, e.offsetX-50, e.offsetY-50

class window.MaxClearance
	@Direction = 
		eastBound: 1
		westBound: -1
	@Where = 
		upper: 0
		self: 1
		lower: 2
	constructor: (sourceCanvasEl, destCanvasEl) ->
		@source = sourceCanvasEl; @main = destCanvasEl
		@sourceContext = @source.getContext '2d'
		@mainContext = @main.getContext '2d'
		@main.width = @source.width; @main.height = @source.height
		@data = @sourceContext.getImageData(0,0,main.width,main.height).data
		@unit = 5
		@V = {}
	erase: (shape,topLeftX,topLeftY) ->
		data = shape.getContext('2d').getImageData(0,0,shape.width,shape.height).data
		x = topLeftX + @unit - topLeftX % @unit
		while x < topLeftX + shape.width
			y = topLeftY + @unit - topLeftY % @unit
			while y < topLeftY + shape.height
				# if data[(x+y*shape.width)*4] == 0
				@erasePointAt x,y
				y += @unit
			x += @unit
		@printGradientMap()
	erasePointAt: (x,y) ->
		v = @V["#{x},#{y}"]
		v.alpha = 0
		@distData[v.x/@unit+v.y/@unit*Math.round(@main.width/@unit)] = 0
		for k,v0 of v.crossers
			delete v.crossers[k]
			#TODO delete invalid crossers
			newDist = @distance x,y,v0.x,v0.y
			index = v0.x/@unit+v0.y/@unit*Math.round(@main.width/@unit)
			# console.log "#{v0.x},#{v0.y}: #{@distData[index]}, #{newDist}"
			if @distData[index] > newDist
				@distData[index] = newDist

	getAlpha : (x,y) ->
		v = @data[(y * main.width + x) * 4 + 3]
	compute: ->
		@reach = []
		@distData = new Uint32Array(Math.round(@main.width/@unit)*Math.round(@main.height))
		@maxdist = 0
		@sweep  MaxClearance.Direction.eastBound
		@sweep  MaxClearance.Direction.westBound
		@updateCrossers()
		@printBoundaries()
		@printGradientMap()
	sweep: (direction) ->
		@A = []
		xc = if direction > 0 then 0 else main.width - main.width%@unit
		nn = if direction > 0 then main.width else 0
		while xc*direction < nn
			#vertical pass 1: find new vertices
			y = 0
			# newVertices = []
			while y < main.height
				alpha = @getAlpha(xc,y)
				v = new Vertex(xc,y)
				@V[v.key] = v
				v.alpha = alpha
				@A[y/@unit] = v
				# newVertices.push v
				y+=@unit
			#vertical pass 2: update stack
			for vj in @A
				if vj.alpha == 0 and not vj.isSubsumed() and not vj.isSelected()
					if not @begin
						@begin = @end = vj
						vj.setSelected()
					else
						in_range = true
						entered_range = false
						pos = undefined
						where = undefined
						vk = @end
						while vk
							if not vk.isSubsumed()
								y = vj.getIntersectionY vk,xc
								if vj.y > vk.y
									if y < vk.lowerBound
										pos = @subsume vk, vj
										where = MaxClearance.Where.self
										# @updateBounds vj, xc
										entered_range = true if not entered_range
									else if y < vk.upperBound
										# @update vj, vk, y
										pos = vk
										where = MaxClearance.Where.upper
										@updateBounds vj, xc
										entered_range = true if not entered_range
									else if entered_range then break
								else if vj.y == vk.y
									pos = @subsume vk, vj
									# @updateBounds vj, xc
									where = MaxClearance.Where.self
									entered_range = true if not entered_range
								else # vj.y < vk.y
									if y > vk.upperBound
										pos = @subsume vk, vj
										where = MaxClearance.Where.self
										# @updateBounds vj, xc
										entered_range = true if not entered_range
									else if y > vk.lowerBound
										# @update vk, vj, y
										pos = vk
										where = MaxClearance.Where.lower
										# @updateBounds vj, xc
										entered_range = true if not entered_range
									else if entered_range then break
							vk = vk.lowerVertex
						if entered_range
							# console.assert(insert_pos!=undefined)
							# console.assert(@stack[insert_pos]==undefined or @stack[insert_pos].isSubsumed())
							# @stack[insert_pos] = vj
							@connect pos, vj, where
							@updateBounds vj, xc
							vj.setSelected()
			#vertical pass 3: store distance values
			if @begin
				y = 0
				v = @begin
				while y < @main.height
					v=v.upperVertex if y > v.upperBound and v.upperVertex
					dist =  @distance xc,y,v.x,v.y
					minBorderDist = @getMinBorderDistance(xc,y)
					if minBorderDist < dist then dist = minBorderDist
					@maxdist = dist if dist > @maxdist
					index = xc/@unit + y/@unit*Math.round(main.width/@unit)
					@distData[index] = dist if not @distData[index] or @distData[index] > dist
					v0 = @V["#{xc},#{y}"]
					console.assert v0
					@reach[v0] = v
					y+=@unit
			# #vertical pass 4: draw distance boundaries
			# v = @begin
			# while v
			# 	@updateBounds v, xc, direction
			# 	@mainContext.beginPath()
			# 	@mainContext.moveTo xc,v.lowerBound
			# 	@mainContext.lineTo xc+1,v.lowerBound
			# 	@mainContext.moveTo xc,v.upperBound
			# 	@mainContext.lineTo xc+1,v.upperBound
			# 	@mainContext.stroke()
			# 	v = v.upperVertex
			xc+=direction*@unit
	updateCrossers: ->
		xc = 0
		while xc < @main.width
			y = 0
			while y < @main.height
				v0 = @V["#{xc},#{y}"]
				if v0.alpha > 0
					index = xc/@unit + y/@unit*Math.round(main.width/@unit)
					vd = @reach[v0]
					@addCrossers v0,vd.x,vd.y
				y += @unit
			xc += @unit
	addCrossers: (v,x,y) ->
		x0 = v.x; y0=v.y
		dx = Math.abs(x - x0)
		dy = Math.abs(y - y0)
		if x0 < x then sx = @unit else sx = -@unit
		if y0 < y then sy = @unit else sy = -@unit
		err = dx - dy
		while true
			key = "#{x0},#{y0}"
			@V[key].crossers["#{v.x},#{v.y}"] = v
			if x0 == x and y0 == y
				break
			e2 = 2 * err
			if e2 > -dy
				err -= dy
				x0 += sx
			if e2 < dx
				err += dx
				y0 += sy

	getMinBorderDistance: (x,y) ->
		if x > @main.width / 2 then minXBorderDist = @main.width - x else minXBorderDist = x
		if y > @main.height / 2 then minYBorderDist = @main.height - y else minYBorderDist = y
		if minXBorderDist < minYBorderDist then minXBorderDist else minYBorderDist
	printBoundaries: ->
		xc = 0
		while xc < main.width
			xc++
	printGradientMap: ->
		@mainContext.clearRect 0,0,@main.width,@main.height
		xc = 0
		while xc < main.width
			y = 0
			while y < @main.height
				xx = (xc - xc % @unit)/@unit
				yy = (y - y % @unit)/@unit
				val = 255 - Math.round(@distData[xx+yy*Math.round(main.width/@unit)]/@maxdist * 255)
				@mainContext.fillStyle = "rgba(255,#{val},255,1)"
				@mainContext.fillRect xc,y,@unit,@unit
				y+=@unit
			xc+=@unit
	updateBounds: (v,xc) ->
		if v.upperVertex
			v.upperVertex.lowerBound = v.upperBound = v.getIntersectionY v.upperVertex, xc
		if v.lowerVertex
			v.lowerVertex.upperBound = v.lowerBound = v.getIntersectionY v.lowerVertex, xc
	connect: (pos,v,where) ->
		switch where
			when MaxClearance.Where.upper
				if pos.upperVertex
					pos.upperVertex.lowerVertex = v
					v.upperVertex = pos.upperVertex
				pos.upperVertex = v
				v.lowerVertex = pos
				@end = v if @end == pos
			when MaxClearance.Where.self
				if pos.upperVertex
					pos.upperVertex.lowerVertex = v 	
					v.upperVertex = pos.upperVertex
				if pos.lowerVertex
					pos.lowerVertex.upperVertex = v
					v.lowerVertex = pos.lowerVertex
			when MaxClearance.Where.lower
				if pos.lowerVertex
					pos.lowerVertex.upperVertex = v
					v.lowerVertex = pos.lowerVertex
				pos.lowerVertex = v
				v.upperVertex = pos
				@begin = v if @begin == pos
	distance: (x1,y1,x2,y2) ->
		Math.sqrt(Math.pow(y2-y1,2)+Math.pow(x2-x1,2))

	subsume: (vk, vj) ->
		vk.setSubsumed()
		vk.upperVertex.lowerVertex = vk.lowerVertex if vk.upperVertex
		vk.lowerVertex.upperVertex = vk.upperVertex if vk.lowerVertex
		vj.upperBound = vk.upperBound
		vj.lowerBound = vk.lowerBound
		@begin = vj if @begin == vk
		@end = vj if @end == vk
		vk
	printStack: ->
		s = ""
		v = @begin
		while v
			if v and not v.isSubsumed()
				s += v.toString() + ", "
			v = v.upperVertex
		console.log s

	distanceInfo: []

	class Vertex
		constructor: (x,y) ->
			@x = x; @y = y
			@key = "#{x},#{y}"
			@upperBound = 1.7976931348623157e10308
			@lowerBound = -1.7976931348623157e10308
			@upperVertex = undefined
			@lowerVertex = undefined
			@crossers = {}
		getIntersectionY: (vertex, x) ->
			#calculate y coordinate of intersection
			midY = (vertex.y + @y) / 2
			if(vertex.x == @x) 
				y = midY
			else
				midX = (vertex.x + @x) / 2;
				atanRatio = (vertex.y-@y)/(vertex.x-@x)
				y = midY - (x-midX) / atanRatio
			return y
		isSubsumed: -> if @subsumed then true else false
		isSelected: -> if @selected then true else false
		setSubsumed: ->
			# console.assert(@selected)
			@subsumed = true
		setSelected: -> @selected = true
		toString: -> "(#{@x},#{@y})"
