package com.settinghead.wexpression.client {
/*
 Copyright 2010 Daniel Bernier

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

	import com.settinghead.wexpression.client.BBPolarChildTree;
	import com.settinghead.wexpression.client.BBPolarRootTree;
	import com.settinghead.wexpression.client.NotImplementedError;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import org.as3commons.lang.Assert;

internal class BBPolarTreeBuilder {

	

	public static function makeTree(shape:ImageShape, swelling:int):BBPolarRootTree {
		var bounds:Rectangle= shape.getBounds2D();
		var minBoxSize:int= 1;
		// center
		var x:int= int((bounds.x + bounds.width / 2));
		var y:int= int((bounds.y + bounds.height / 2));
		// Assert.isTrue(x > 0);
		// Assert.isTrue(y > 0);

		var d:Number= (Math.sqrt(Math.pow(bounds.width / 2, 2)
				+ Math.pow(bounds.height / 2, 2)));

		var tree:BBPolarRootTree= new BBPolarRootTree(shape, x, y, d,
				minBoxSize);
		// makeChildren(tree, shape, minBoxSize, tree);
		// tree.swell(swelling);
		return tree;
	}

	protected static function makeChildren(tree:BBPolarTree, shape:ImageShape,
			minBoxSize:int, root:BBPolarRootTree):void {
		var type:SplitType= determineType(tree);

		var children:Vector.<BBPolarChildTree>= splitTree(tree, shape, minBoxSize, root, type);

		tree.addKids(children);
	}

	static function splitTree(tree:BBPolarTree, shape:ImageShape,
		 minBoxSize:int, root:BBPolarRootTree, type:SplitType):Vector.<BBPolarChildTree> {
		var result:Vector.<BBPolarChildTree>= new Vector.<BBPolarChildTree>();
		var r:BBPolarChildTree;

		switch (type) {
		case SplitType._3RAYS: {
			var r:Number= (tree.getR2(false) - tree.getR1(false)) / 4;
			var r1:Number= tree.getR1(false);
			var r2:Number= r1 + r;
			var r3:Number= r2 + r;
			var r4:Number= r3 + r;
			var r5:Number= tree.getR2(false);
			Assert.isTrue(r1 < r2 && r2 < r3 && r3 < r4 && r4 < r5);
			r = makeTree(shape, minBoxSize, r1, r2, tree.d1, tree.d2, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r2, r3, tree.d1, tree.d2, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r3, r4, tree.d1, tree.d2,root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r4, r5, tree.d1, tree.d2,root);
			if(r!=null) result.push(r);
		}
			break;

		case SplitType._2RAYS1CUT: {
			var r:Number= (tree.getR2(false) - tree.getR1(false)) / 3;
			var r1:Number= tree.getR1(false);
			var r2:Number= r1 + r;
			var r3:Number= r2 + r;
			var r4:Number= tree.getR2(false);
			var d1:Number= tree.d1;
			var d2:Number= tree.d1 + (tree.d2 - tree.d1) / 2;
			var d3:Number= tree.d2;
			Assert.isTrue(r1 < r2 && r2 < r3 && r3 < r4);
			r = makeTree(shape, minBoxSize, r1, r4, d1, d2, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r2, r3, d2, d3, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r3, r4, d2, d3, root);
			if(r!=null) result.push(r);
		}
			break;
		case SplitType._1RAY1CUT: {
			var r:Number= (tree.getR2(false) - tree.getR1(false)) / 2;
			var r1:Number= tree.getR1(false);
			var r2:Number= r1 + r;
			var r3:Number= tree.getR2(false);
			var d:Number= (tree.d2 - tree.d1) / 2;
			var d1:Number= tree.d1;
			var d2:Number= d1 + d;
			var d3:Number= tree.d2;
			Assert.isTrue(r1 < r2 && r2 < r3);

			r = makeTree(shape, minBoxSize, r1, r2, d1, d2, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r2, r3, d1, d2, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r2, r3, d2, d3, root);
			if(r!=null) result.push(r);
		}
			break;
		case SplitType._1RAY2CUTS: {
			var r:Number= (tree.getR2(false) - tree.getR1(false)) / 2;
			var r1:Number= tree.getR1(false);
			var r2:Number= r1 + r;
			var r3:Number= tree.getR2(false);
			var d:Number= (tree.d2 - tree.d1) / 3;
			var d1:Number= tree.d1;
			var d2:Number= d1 + d;
			var d3:Number= d2 + d;
			var d4:Number= tree.d2;
			Assert.isTrue(r1 < r2 && r2 < r3);

			r = makeTree(shape, minBoxSize, r1, r3, d1, d2, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r1, r3, d2, d3, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r1, r2, d3, d4, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r2, r3, d3, d4, root);
			if(r!=null) result.push(r);
		}
			break;
		case SplitType._3CUTS: {
			var r1:Number= tree.getR1(false);
			var r2:Number= tree.getR2(false);
			var d:Number= (tree.d2 - tree.d1) / 4;
			var d1:Number= tree.d1;
			var d2:Number= d1 + d;
			var d3:Number= d2 + d;
			var d4:Number= d3 + d;
			var d5:Number= tree.d2;
			Assert.isTrue(r1 < r2);

			r = makeTree(shape, minBoxSize, r1, r2, d1, d2, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r1, r2, d3, d4, root);
			if(r!=null) result.push(r);
			r = makeTree(shape, minBoxSize, r1, r2, d4, d5, root);
			if(r!=null) result.push(r);
		}
			break;
		}
		return result;
	}

	private static function determineType(tree:BBPolarTree):SplitType {
		var d:Number= (tree.d2 - tree.d1);
		var midLength:Number= ((tree.d2 + tree.d1)
				* (tree.getR2(false) - tree.getR1(false)) / 2);
		var factor:Number= d / midLength;
		// System.out.println("d=" + d + ", midLength=" + midLength + ",factor="
		// + factor);
		if (factor < 0.8)
			return SplitType._3RAYS;
		else if (factor > 1.2)
			return SplitType._3CUTS;
		else
			return SplitType._1RAY1CUT;
	}

	private static function makeTree(shape:ImageShape, minBoxSize:int,
			r1:Number, r2:Number, d1:Number, d2:Number, root:BBPolarRootTree):BBPolarTree {

		var tree:BBPolarTree= new BBPolarChildTree(r1, r2, d1, d2,
				root, minBoxSize);
		var r:Rectangle = shape.getBounds2D();
		var x:Number= tree.getX(false) + r.width / 2;
		var y:Number= tree.getY(false) + r.height / 2;
		var width:Number= tree.getRight(false) - tree.getX(false);
		var height:Number= tree.getBottom(false) - tree.getY(false);
		Assert.isTrue(width > 0);
		Assert.isTrue(height > 0);
		if (shape == null || shape.contains(x, y, width, height)) {
			return tree;
		} else {
			if (shape.intersects(x, y, width, height)) {
				return tree;
			} else { // neither contains nor intersects
				return null;
			}
		}
	}

	static var correctCount:int= 0;

	// To the best of my knowledge this code is correct.
	// If you find any errors or problems please contact
	// me at zunzun@zunzun.com.
	// James
	//
	// the code below was partially based on the fortran code at:
	// http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbisp.f
	// http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbspl.f

}
}