package com.settinghead.groffle.client.model.algo.tree;	

class BBPolarTreeBuilder {

	private static inline var STOP_COMPUTE_TREE_THRESHOLD:Float = 20;
	
	static function assert( cond : Bool, ?pos : haxe.PosInfos ) {
	      if( !cond )
	          haxe.Log.trace("Assert in "+pos.className+"::"+pos.methodName,pos);
	   }

	public static inline function makeTree(shape:IImageShape, swelling:Int):BBPolarRootTreeVO {
		var minBoxSize:Int= 1;
		// center
		var x:Int= Std.int(shape.getWidth() / 2);
		var y:Int= Std.int((shape.getHeight() / 2));
		// assert(x > 0);
		// assert(y > 0);

		var d:Float= (Math.sqrt(Math.pow(shape.getWidth() / 2, 2)
				+ Math.pow(shape.getHeight() / 2, 2)));

		var tree:BBPolarRootTreeVO= new BBPolarRootTreeVO(shape, x, y, d,
				minBoxSize);
		// makeChildren(tree, shape, minBoxSize, tree);
//		tree.swell(swelling);
		return tree;
	}

	public static inline function makeChildren(tree:BBPolarTreeVO, shape:IImageShape,
			minBoxSize:Int, root:BBPolarRootTreeVO):Void {
		var type:Int= determineType(tree);

		var children:Array<BBPolarChildTreeVO>= splitTree(tree, shape, minBoxSize, root, type);
//		 if(children.length==0) 
//			 tree.setLeaf(true);
//		 else
			tree.addKids(children);
	}

	public static inline function splitTree(tree:BBPolarTreeVO, shape:IImageShape,
		 minBoxSize:Int, root:BBPolarRootTreeVO, type:Int):Array<BBPolarChildTreeVO> {
		var result:Array<BBPolarChildTreeVO>= new Array<BBPolarChildTreeVO>();
		var re:BBPolarChildTreeVO;
		var r:Float, r1:Float, r2:Float, r3:Float, r4:Float, r5:Float;
		var d:Float, d1:Float, d2:Float, d3:Float, d4:Float, d5:Float;
		
		switch (type) {
		case SplitType._3RAYS: {
			r = (tree.getR2(false) - tree.getR1(false)) / 4;
			r1 = tree.getR1(false);
			r2 = r1 + r;
			r3 = r2 + r;
			r4 = r3 + r;
			r5 = tree.getR2(false);
			assert(r1 < r2 && r2 < r3 && r3 < r4 && r4 < r5);
			re = makeChildTree(shape, minBoxSize, r1, r2, tree.d1, tree.d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, tree.d1, tree.d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r3, r4, tree.d1, tree.d2,root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r4, r5, tree.d1, tree.d2,root);
			if(re!=null) result.push(re);
		}

		case SplitType._2RAYS1CUT: {
			r = (tree.getR2(false) - tree.getR1(false)) / 3;
			r1 = tree.getR1(false);
			r2 = r1 + r;
			r3 = r2 + r;
			r4 = tree.getR2(false);
			d1 = tree.d1;
			d2 = tree.d1 + (tree.d2 - tree.d1) / 2;
			d3 = tree.d2;
			assert(r1 < r2 && r2 < r3 && r3 < r4);
			re = makeChildTree(shape, minBoxSize, r1, r4, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r3, r4, d2, d3, root);
			if(re!=null) result.push(re);
		}
		case SplitType._1RAY1CUT: {
			r = (tree.getR2(false) - tree.getR1(false)) / 2;
			r1 = tree.getR1(false);
			r2 = r1 + r;
			r3 = tree.getR2(false);
			d= (tree.d2 - tree.d1) / 2;
			d1 = tree.d1;
			d2 = d1 + d;
			d3 = tree.d2;
			assert(r1 < r2 && r2 < r3);

			re = makeChildTree(shape, minBoxSize, r1, r2, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, d2, d3, root);
			if(re!=null) result.push(re);
		}
		case SplitType._1RAY2CUTS: {
			r = (tree.getR2(false) - tree.getR1(false)) / 2;
			r1 = tree.getR1(false);
			r2 = r1 + r;
			r3 = tree.getR2(false);
			d= (tree.d2 - tree.d1) / 3;
			d1 = tree.d1;
			d2 = d1 + d;
			d3 = d2 + d;
			d4 = tree.d2;
			assert(r1 < r2 && r2 < r3);

			re = makeChildTree(shape, minBoxSize, r1, r3, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r3, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d3, d4, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, d3, d4, root);
			if(re!=null) result.push(re);
		}
		case SplitType._3CUTS: {
			r1 = tree.getR1(false);
			r2 = tree.getR2(false);
			d= (tree.d2 - tree.d1) / 4;
			d1 = tree.d1;
			d2 = d1 + d;
			d3 = d2 + d;
			d4 = d3 + d;
			d5 = tree.d2;
			assert(r1 < r2);

			re = makeChildTree(shape, minBoxSize, r1, r2, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d3, d4, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d4, d5, root);
			if(re!=null) result.push(re);
		}
		}
		return result;
	}

	private static inline function determineType(tree:BBPolarTreeVO):Int {
		var d:Float= (tree.d2 - tree.d1);
		var midLength:Float= ((tree.d2 + tree.d1)
				* (tree.getR2(false) - tree.getR1(false)) / 2);
		var factor:Float= d / midLength;
		// System.out.println("d=" + d + ", midLength=" + midLength + ",factor="
		// + factor);
		if (factor < 0.7)
			return SplitType._3RAYS;
		else if (factor > 1.3)
			return SplitType._3CUTS;
		else
			return SplitType._1RAY1CUT;
	}

	private static inline function makeChildTree(shape:IImageShape, minBoxSize:Int,
			r1:Float, r2:Float, d1:Float, d2:Float, root:BBPolarRootTreeVO):BBPolarChildTreeVO {

		var tree:BBPolarChildTreeVO= new BBPolarChildTreeVO(r1, r2, d1, d2,
				root, minBoxSize);
		var x:Float= tree.getX(false) +  shape.getWidth() / 2;
		if(x>shape.getWidth()) tree = null;
		else{
			var y:Float= tree.getY(false) + shape.getHeight() / 2;
			if(y>shape.getHeight()) tree = null;
			else{
				var width:Float= tree.getRight(false) - tree.getX(false);
		//		if(width<1) return null;
				if(x+width<0) tree = null;
				else{
					var height:Float= tree.getBottom(false) - tree.getY(false);
			//		if(height<1) return null;
					if(y+height<0) tree =  null;
					else{
						assert(width > 0);
						assert(height > 0);
						if (shape == null || shape.contains(x, y, width, height, 0, false)) {
						} else {
							if (shape.intersects(x, y, width, height,false)) {
							} else { // neither contains nor intersects
								tree = null;
							}
						}
						
					}
				}
			}
		}
		return tree;
	}

	public static var correctCount:Int= 0;

	// To the best of my knowledge this code is correct.
	// If you find any errors or problems please contact
	// me at zunzun@zunzun.com.
	// James
	//
	// the code below was partially based on the fortran code at:
	// http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbisp.f
	// http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbspl.f

}