# First of all thanks David for the pointer. I believe his citation addresses the original formulation, but requires (1) a grid based on integer (or linear-time sortable) coordinates, and (2) a way to take the (non-gridded) Voronoi result and convert to the distance assignment for the grid vertices.
# I feel uneasy about that, and in parallel I've been working on the approach I suggested at the end of my original question (it was more of a thinking-out-loud). It does solve the problem in linear time (in the size of the grid), and does not require integer or linear-time sortable coordinates, so I mark this as the answer.
# I'll run this in two passes: a East-bound pass and a West-bound pass. The coordinates are x1, x2, ..., xN, and y1, y2, ..., yN.
# WLOG in the East-bound pass, I'll process column by column but will only look at obstacle vertices on or to the left of the column.
# I maintain an array A of obstacle vertices of size N. Suppose now I am processing column c (x = xc). The kth element in A stores the obstacle vertex with the largest x-coordinate s.t. y = yk and x <= xc, or null if there is no such obstacle vertex. Note that if there are multiple obstacle vertices with the same y coordinates, all but the East-most one are guaranteed not to matter.
# Now, I want to partition the vertical line x = xc into ranges closest to the same obstacle vertex. Each partition pi is associated with an index i such that A[i] is the obstacle vertex closest to this partition. Similar to the argument behind Fortune's Voronoi algorithm, it is easy to see that the yi's are strictly ordered. Furthermore, the first and last non-null vertices in A (could be the same) both have their own associated ranges, since the first owns [-infinity, ...] and the last owns [..., +infinity].
# So we go through the array A and process all non-null vertices in order. We use a stack to represent the current ranges and process the vertices one by one. The stack represents the current partitioning of the line using all vertices considered so far. Each vertex vi in the stack owns a range [LBi, UBi]. Initially, the first vertex owns the range [-infinity, +infinity].
# Let's say we consider the next vertex vj, and the current top-of-stack vertex is vk (note that vk has the range [LBk, +infinity]). We compute the bisector between vj and vk. This bisector will intersect with the line x = xc at y (guaranteed to hit, because vj and vk have different y coordinates). If y < LBk, we know that vk is subsumed by its neighbors -- meaning every point in the line x = xc is closer to some other vertices than vk. In this case, we say vk is "subsumed" and we simply remove vk from the stack.
# Once vk is removed, we have to repeat this exercise, because it is possible that new top-of-stack vertex can be proven to be subsumed. We repeat this until the top-of-stack vertex vk is not "subsumed" (and we're guaranteed to find such vertex, because the bottom-most vertex has a range [-infinity, ...]), and we simply update the upper bound of the range of vk to y, and then push vj onto the stack, with a range of [y, +infinity].
# The stack may grow and shrink, but the runtime is O(N) per column by amortization. At each point within the column processing, the stack is guaranteed to not contain any "subsumed" vertices considering all the vertices seen so far. Therefore, at the end of the processing, no vertices are subsumed (for the purist this may require a more rigorous proof by contradiction). Once the column is process, we simply revisit the ranges on the stack and assign the distance accordingly.
# Last but not least, I talked in terms of an NxN grid. The argument holds just the same for an MxN grid, namely there is an O(MxN)-time algorithm to compute the maximum clearance for each grid point. Moreover, the grid can also be non-uniform (in edge lengths).

$ ->
	$img = $("<img>",
        src: "pbs.png"
    )
	$img.load ->
		$('#source')[0].width = this.height
		$('#source')[0].height = this.height
		$('#source')[0].getContext('2d').drawImage this, 0,0,$('#source')[0].width,$('#source')[0].height
		window.maxClearance = new MaxClearance($('#source')[0],$('#main')[0])

class window.MaxClearance
	constructor: (sourceCanvasEl, destCanvasEl) ->
		@source = sourceCanvasEl; @main = destCanvasEl
		@sourceContext = @source.getContext '2d'
		@mainContext = @main.getContext '2d'
		@main.width = @source.width; @main.height = @source.height
		@data = @sourceContext.getImageData(0,0,main.width,main.height).data
	getAlpha : (x,y) ->
		@data[(y * main.width + x) * 4 + 3]
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
				if @getAlpha(x,y) > 0
					v = new Vertice(x,y)
					A[y] = v
					newVertices.push v
				y++
			#vertical pass 2: update stack
			for vj in A
				if vj and not vj.isSubsumed()
					if not @stack.length
						@stack.push vj
						vj.upperBound = 1.7976931348623157e10308; vj.loweBound = -1.7976931348623157e10308
					else
						while true
							vk = @stack[0]
							y = vj.getIntersectionY(vk,x,MaxClearance.Direction.eastBound)
							if y < vk.lowerBound
								@stack.pop() #pop vk
								vk.setSubsumed()
							else
								vj.upperBound = 1.7976931348623157e10308
								vk.upperBound = vj.lowerBound = y
								@stack.push vj
								break
			#vertical pass 3: draw distance map
			y = 0
			while y < n
				v = stack.nearestVertix(y)
				dist =  distance(x,y,v.x,v.y)
				distData[x+y*main.width] = dist
				@mainConext.fillStyle = "rgb(255,255,#{dist/@maxdist})"
				@mainContext.rect x,y,1,1
				y++
			x++
	@Direction = 
		eastBound: 0
		westBound: 1

Array.prototype.nearestVertex = (v) ->

class window.Vertex
	constructor: (x,y) ->
		@x = x; @y = y
	getIntersectionY: (vertex, x, direction) ->
		#calculate y coordinate of intersection
		if direction == MaxClearance.Direction.eastBound
			midX = (vertex.x + @x) / 2; midY = (vertex.y + @y) / 2
			atanRatio = (vertex.y-@y)/(vetex.x-@x)
			y = (midX - x) * atanRatio + midY
			return y
		else if direction == MaxClearance.Direction.westBound
			#TODO
			alert('not implemented')
	isSubsumed: -> if @subsumed then true else false
	setSubsumed: -> @subsumed = true
