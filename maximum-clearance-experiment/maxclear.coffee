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
	[0]

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
		@stack = []
		@distData = new Uint32Array(@main.width*@main.height)
		@maxdist = Math.sqrt(Math.pow(@main.width,2)+Math.pow(@main.height,2))
		x = 0
		while x < n
			#vertical pass 1: find new vertices
			y = 0
			newVertices = []
			while y < n
				alpha = @getAlpha(x,y)
				if  alpha > 0
					v = new Vertex(x,y)
					v.alpha = alpha
					@A[y] = v
					newVertices.push v
				y++
			#vertical pass 2: update stack
			if not @stack.length
				#first timer; init
				for vj in newVertices
					if @stack.length
						vTop = @stack[@stack.length - 1]
						y = vj.getIntersectionY(vTop,vj.x,MaxClearance.Direction.eastBound)
						vTop.upperBound = vj.lowerBound = y
					@stack.push vj
					vj.setSelected()
			else
				for vj in newVertices
					if vj and not vj.isSubsumed() and not vj.isSelected()
						vk = @stack[@stack.length-1]
						y = vj.getIntersectionY(vk,x,MaxClearance.Direction.eastBound)
						while vj.y >= vk.y
							console.assert(not vk.isSubsumed())
							if y <= vk.lowerBound or vj.y == vk.y
								v = @stack.pop() #pop vk
								console.assert(v==vk)
								vk.setSubsumed(vj)
								vk = @stack[@stack.length-1]
								y = vj.getIntersectionY(vk,x,MaxClearance.Direction.eastBound)
							else
								vj.upperBound = 1.7976931348623157e10308
								vk.upperBound = vj.lowerBound = y
								@stack.push vj
								vj.setSelected()
								break
			#vertical pass 3: draw distance map
			y = 0
			while y < n
				v = @stack.nearestVertex(y)
				dist =  @distance(x,y,v.x,v.y)
				@distData[x+y*main.width] = dist
				@mainContext.fillStyle = "rgb(255,255,#{dist/@maxdist})"
				@mainContext.rect x,y,1,1
				y++
			x++
	@Direction = 
		eastBound: 0
		westBound: 1

	distance: (x1,y1,x2,y2) ->
		Math.sqrt(Math.pow(y2-y1)+Math.pow(x2-x1))


class window.Vertex
	constructor: (x,y) ->
		@x = x; @y = y
		@upperBound = 1.7976931348623157e10308; @lowerBound = -1.7976931348623157e10308
	getIntersectionY: (vertex, x, direction) ->
		#calculate y coordinate of intersection
		if direction == MaxClearance.Direction.eastBound
			midY = (vertex.y + @y) / 2
			if(vertex.x == @x) 
				y = midY
			else
				midX = (vertex.x + @x) / 2;
				atanRatio = (vertex.y-@y)/(vertex.x-@x)
				y = (midX - x) * atanRatio + midY
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
