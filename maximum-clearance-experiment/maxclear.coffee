Object.size = (obj) ->
  size = 0
  key = undefined
  for key of obj
    size++  if obj.hasOwnProperty(key)
  size

$ ->
	$img = $("<img>",
        src: "swift.png"
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

class window.MaxClearance
	constructor: (sourceCanvasEl, destCanvasEl) ->
		@source = sourceCanvasEl; @main = destCanvasEl
		@sourceContext = @source.getContext '2d'
		@mainContext = @main.getContext '2d'
		@main.width = @source.width; @main.height = @source.height
		@data = @sourceContext.getImageData(0,0,main.width,main.height).data
		@unit = 5
		@V = {}
	getAlpha : (x,y) ->
		v = @data[(y * main.width + x) * 4 + 3]
	compute: ->
		@distData = new Uint32Array(@main.width*@main.height)
		@maxdist = 0
		@sweep  MaxClearance.Direction.eastBound
		@sweep  MaxClearance.Direction.westBound
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
			while y < main.width
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
					index = xc/@unit + y/@unit*main.width
					@distData[index] = dist if not @distData[index] or @distData[index] > dist
					@addCrossers v,xc,y
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
	@Direction = 
		eastBound: 1
		westBound: -1
	@Where = 
		upper: 0
		self: 1
		lower: 2
	addCrossers: (v,x,y) ->
		x0 = v.x; x1 = x; y0=v.y; y1=y
		dx = Math.abs(x1 - x0)
		dy = Math.abs(y1 - y0)
		if x0 < x1 then sx = @unit else sx = -@unit
		if y0 < y1 then sy = @unit else sy = -@unit
		err = dx - dy
		while true
			key = "#{x0},#{y0}"
			@V[key].crossers["#{x},#{y}"] = v
			if x0 == x1 and y0 == y1
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
		xc = 0
		while xc < main.width
			y = 0
			while y < @main.height
				xx = (xc - xc % @unit)/@unit
				yy = (y - y % @unit)/@unit
				val = 255 - Math.round(@distData[xx+yy*main.width]/@maxdist * 255)
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
