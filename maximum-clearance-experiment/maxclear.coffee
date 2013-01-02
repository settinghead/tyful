$ ->
	$img = $("<img>",
        src: "test.png"
    )
	$img.load ->
		$('#source')[0].width = this.height
		$('#source')[0].height = this.height
		$('#source')[0].getContext('2d').drawImage this, 0,0,$('#source')[0].width,$('#source')[0].height
		window.maxClearance = new MaxClearance($('#source')[0],$('#main')[0])
		window.maxClearance.compute()

Array.prototype.nearestVertex = (v) ->
	@[0]

class window.MaxClearance
	constructor: (sourceCanvasEl, destCanvasEl) ->
		@source = sourceCanvasEl; @main = destCanvasEl
		@sourceContext = @source.getContext '2d'
		@mainContext = @main.getContext '2d'
		@main.width = @source.width; @main.height = @source.height
		@data = @sourceContext.getImageData(0,0,main.width,main.height).data
	getAlpha : (x,y) ->
		v = @data[(y * main.width + x) * 4 + 3]
	compute: ->
		n = main.width
		@A = []
		@partitions = [1.7976931348623157e10308,-1.7976931348623157e10308]
		@distData = new Uint32Array(@main.width*@main.height)
		@maxdist = Math.sqrt(Math.pow(@main.width,2)+Math.pow(@main.height,2))
		i = 0
		xc = 0
		direction = MaxClearance.Direction.eastBound
		while xc < n
			#vertical pass 1: find new vertices
			y = 0
			newVertices = []
			while y < n
				alpha = @getAlpha(xc,y)
				if  alpha > 0
					v = new Vertex(xc,y)
					v.alpha = alpha
					@A[y] = v
					newVertices.push v
				y++
			#vertical pass 2: update stack
			for vj in @A
				if vj and not vj.isSubsumed() and not vj.isSelected()
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
								y = vj.getIntersectionY vk,xc,direction
								if vj.y > vk.y
									if y < vk.lowerBound
										pos = @subsume vk, vj
										where = MaxClearance.Where.self
										@updateBounds vj, xc, direction
										entered_range = true if not entered_range
									else if y < vk.upperBound
										# @update vj, vk, y
										pos = vk
										where = MaxClearance.Where.upper
										@updateBounds vj, xc, direction
										entered_range = true if not entered_range
									else if entered_range then break
								else if vj.y == vk.y
									pos = @subsume vk, vj
									where = MaxClearance.Where.self
									entered_range = true if not entered_range
								else # vj.y < vk.y
									if y > vk.upperBound
										pos = @subsume vk, vj
										where = MaxClearance.Where.self
										@updateBounds vj, xc, direction
										entered_range = true if not entered_range
									else if y > vk.lowerBound
										# @update vk, vj, y
										pos = vk
										where = MaxClearance.Where.lower
										@updateBounds vj, xc, direction
										entered_range = true if not entered_range
									else if entered_range then break
							vk = vk.lowerVertex
						if entered_range
							# console.assert(insert_pos!=undefined)
							# console.assert(@stack[insert_pos]==undefined or @stack[insert_pos].isSubsumed())
							# @stack[insert_pos] = vj
							@connect pos, vj, y, where
							@updateBounds vj, xc, direction
							vj.setSelected()
			#vertical pass 3: draw distance map
			y = 0
			v = @begin
			while y < @main.height
				if v
					v=v.upperVertex if y > v.upperBound and v.upperVertex
					dist =  @distance(xc,y,v.x,v.y)
					@distData[xc+y*main.width] = dist if not @distData[xc+y*main.width] or @distData[xc+y*main.width] > dist
					val = Math.round(dist/@maxdist * 255)
					@mainContext.fillStyle = "rgba(255,#{val},255,1)"
					@mainContext.fillRect xc,y,1,1
				y++
			#vertical pass 4: draw distance boundaries
			v = @begin
			while v
				@updateBounds v, xc, direction
				@mainContext.beginPath()
				@mainContext.moveTo xc,v.lowerBound
				@mainContext.lineTo xc+1,v.lowerBound
				@mainContext.moveTo xc,v.upperBound
				@mainContext.lineTo xc+1,v.upperBound
				@mainContext.stroke()
				v = v.upperVertex
			
			xc++
	@Direction = 
		eastBound: 0
		westBound: 1
	@Where = 
		upper: 0
		self: 1
		lower: 2

	updateBounds: (v,xc, direction) ->
		if v.upperVertex
			v.upperVertex.lowerBound = v.upperBound = v.getIntersectionY v.upperVertex, xc, direction
		if v.lowerVertex
			v.lowerVertex.upperBound = v.lowerBound = v.getIntersectionY v.lowerVertex, xc, direction
	connect: (pos,v,y,where) ->
		upper = lower = undefined
		switch where
			when MaxClearance.Where.upper
				if pos.upperVertex
					pos.upperVertex.lowerVertex = v
					v.upperVertex = pos.upperVertex
				upper = pos.upperVertex = v
				lower = v.lowerVertex = pos
				@end = v if @end == pos
			when MaxClearance.Where.self
				if pos.upperVertex
					lower = pos.upperVertex.lowerVertex = v 	
					v.upperVertex = pos.upperVertex
				if pos.lowerVertex
					upper = pos.lowerVertex.upperVertex = v
					v.lowerVertex = pos.lowerVertex
			when MaxClearance.Where.lower
				if pos.lowerVertex
					pos.lowerVertex.upperVertex = v
					v.lowerVertex = pos.lowerVertex
				lower = pos.lowerVertex = v
				upper = v.upperVertex = pos
				@begin = v if @begin == pos
	distance: (x1,y1,x2,y2) ->
		Math.sqrt(Math.pow(y2-y1,2)+Math.pow(x2-x1,2))

	subsume: (vk, vj) ->
		vk.setSubsumed()
		vk.upperVertex.lowerVertex = vk.lowerVertex if vk.upperVertex
		vk.lowerVertex.upperVertex = vk.upperVertex if vk.lowerVertex
		vj.upperBound = vk.upperBound
		vj.lowerBound = vk.lowerBound
		vk.subsumedBy = vj
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
			@upperBound = 1.7976931348623157e10308
			@lowerBound = -1.7976931348623157e10308
			@upperVertex = undefined
			@lowerVertex = undefined
		getIntersectionY: (vertex, x, direction) ->
			#calculate y coordinate of intersection
			if direction == MaxClearance.Direction.eastBound
				midY = (vertex.y + @y) / 2
				if(vertex.x == @x) 
					y = midY
				else
					midX = (vertex.x + @x) / 2;
					atanRatio = (vertex.y-@y)/(vertex.x-@x)
					y = midY - (x-midX) / atanRatio
				return y
			else if direction == MaxClearance.Direction.westBound
				#TODO
				alert('not implemented')
		isSubsumed: -> if @subsumed then true else false
		isSelected: -> if @selected then true else false
		setSubsumed: (v) ->
			console.assert(@selected)
			@subsumedBy = v
			@subsumed = true
		setSelected: -> @selected = true
		toString: -> "(#{@x},#{@y})"
