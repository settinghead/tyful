package com.settinghead.wenwentu.client.model.vo {
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

	import com.settinghead.wenwentu.client.NotImplementedError;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import org.as3commons.lang.Assert;

internal class BBPolarTreeBuilder {

	private static const STOP_COMPUTE_TREE_THRESHOLD:Number = 20;


	public static function makeTree(shape:IImageShape, swelling:int):BBPolarRootTreeVO {
		var minBoxSize:int= 1;
		// center
		var x:int= int((shape.width / 2));
		var y:int= int((shape.height / 2));
		// Assert.isTrue(x > 0);
		// Assert.isTrue(y > 0);

		var d:Number= (Math.sqrt(Math.pow(shape.width / 2, 2)
				+ Math.pow(shape.height / 2, 2)));

		var tree:BBPolarRootTreeVO= new BBPolarRootTreeVO(shape, x, y, d,
				minBoxSize);
		// makeChildren(tree, shape, minBoxSize, tree);
//		tree.swell(swelling);
		return tree;
	}

	public static function makeChildren(tree:BBPolarTreeVO, shape:IImageShape,
			minBoxSize:int, root:BBPolarRootTreeVO):void {
		var type:int= determineType(tree);

		var children:Vector.<BBPolarChildTreeVO>= splitTree(tree, shape, minBoxSize, root, type);
//		 if(children.length==0) 
//			 tree.setLeaf(true);
//		 else
			tree.addKids(children);
	}

	static function splitTree(tree:BBPolarTreeVO, shape:IImageShape,
		 minBoxSize:int, root:BBPolarRootTreeVO, type:int):Vector.<BBPolarChildTreeVO> {
		var result:Vector.<BBPolarChildTreeVO>= new Vector.<BBPolarChildTreeVO>();
		var re:BBPolarChildTreeVO;
		var r:Number, r1:Number, r2:Number, r3:Number, r4:Number, r5:Number;
		var d:Number, d1:Number, d2:Number, d3:Number, d4:Number, d5:Number;
		
		switch (type) {
		case SplitType._3RAYS: {
			r = (tree.getR2(false) - tree.getR1(false)) / 4;
			r1 = tree.getR1(false);
			r2 = r1 + r;
			r3 = r2 + r;
			r4 = r3 + r;
			r5 = tree.getR2(false);
			Assert.isTrue(r1 < r2 && r2 < r3 && r3 < r4 && r4 < r5);
			re = makeChildTree(shape, minBoxSize, r1, r2, tree.d1, tree.d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, tree.d1, tree.d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r3, r4, tree.d1, tree.d2,root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r4, r5, tree.d1, tree.d2,root);
			if(re!=null) result.push(re);
		}
			break;

		case SplitType._2RAYS1CUT: {
			r = (tree.getR2(false) - tree.getR1(false)) / 3;
			r1 = tree.getR1(false);
			r2 = r1 + r;
			r3 = r2 + r;
			r4 = tree.getR2(false);
			d1 = tree.d1;
			d2 = tree.d1 + (tree.d2 - tree.d1) / 2;
			d3 = tree.d2;
			Assert.isTrue(r1 < r2 && r2 < r3 && r3 < r4);
			re = makeChildTree(shape, minBoxSize, r1, r4, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r3, r4, d2, d3, root);
			if(re!=null) result.push(re);
		}
			break;
		case SplitType._1RAY1CUT: {
			r = (tree.getR2(false) - tree.getR1(false)) / 2;
			r1 = tree.getR1(false);
			r2 = r1 + r;
			r3 = tree.getR2(false);
			d= (tree.d2 - tree.d1) / 2;
			d1 = tree.d1;
			d2 = d1 + d;
			d3 = tree.d2;
			Assert.isTrue(r1 < r2 && r2 < r3);

			re = makeChildTree(shape, minBoxSize, r1, r2, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, d2, d3, root);
			if(re!=null) result.push(re);
		}
			break;
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
			Assert.isTrue(r1 < r2 && r2 < r3);

			re = makeChildTree(shape, minBoxSize, r1, r3, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r3, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d3, d4, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r2, r3, d3, d4, root);
			if(re!=null) result.push(re);
		}
			break;
		case SplitType._3CUTS: {
			r1 = tree.getR1(false);
			r2 = tree.getR2(false);
			d= (tree.d2 - tree.d1) / 4;
			d1 = tree.d1;
			d2 = d1 + d;
			d3 = d2 + d;
			d4 = d3 + d;
			d5 = tree.d2;
			Assert.isTrue(r1 < r2);

			re = makeChildTree(shape, minBoxSize, r1, r2, d1, d2, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d3, d4, root);
			if(re!=null) result.push(re);
			re = makeChildTree(shape, minBoxSize, r1, r2, d4, d5, root);
			if(re!=null) result.push(re);
		}
			break;
		}
		return result;
	}

	private static function determineType(tree:BBPolarTreeVO):int {
		var d:Number= (tree.d2 - tree.d1);
		var midLength:Number= ((tree.d2 + tree.d1)
				* (tree.getR2(false) - tree.getR1(false)) / 2);
		var factor:Number= d / midLength;
		// System.out.println("d=" + d + ", midLength=" + midLength + ",factor="
		// + factor);
		if (factor < 0.7)
			return SplitType._3RAYS;
		else if (factor > 1.3)
			return SplitType._3CUTS;
		else
			return SplitType._1RAY1CUT;
	}

	private static function makeChildTree(shape:IImageShape, minBoxSize:int,
			r1:Number, r2:Number, d1:Number, d2:Number, root:BBPolarRootTreeVO):BBPolarChildTreeVO {

		var tree:BBPolarChildTreeVO= new BBPolarChildTreeVO(r1, r2, d1, d2,
				root, minBoxSize);
		var x:Number= tree.getX(false) +  shape.width / 2;
		if(x>shape.width) return null;
		var y:Number= tree.getY(false) + shape.height / 2;
		if(y>shape.height) return null;
		var width:Number= tree.getRight(false) - tree.getX(false);
//		if(width<1) return null;
		if(x+width<0) return null;
		var height:Number= tree.getBottom(false) - tree.getY(false);
//		if(height<1) return null;
		if(y+height<0) return null;
		Assert.isTrue(width > 0);
		Assert.isTrue(height > 0);
		if (shape == null || shape.contains(x, y, width, height,false)) {
			return tree;
		} else {
			if (shape.intersects(x, y, width, height,false)) {
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