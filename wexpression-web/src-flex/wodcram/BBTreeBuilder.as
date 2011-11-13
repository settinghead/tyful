package wordcram {
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

import java.awt.Shape;
import java.awt.geom.Rectangle2D;


public class BBTreeBuilder {
	public function makeTree(shape:Shape, swelling:int):BBTree {
		var bounds:Rectangle2D= shape.getBounds2D();
		var minBoxSize:int= 1;
		var x:int= int(bounds.getX());
		var y:int= int(bounds.getY());
		var right:int= x + int(bounds.getWidth());
		var bottom:int= y + int(bounds.getHeight());
		
		var tree:BBTree= makeTree(shape, minBoxSize, x, y, right, bottom);
		tree.swell(swelling);
		return tree;
	}

	private function makeTree(shape:Shape, minBoxSize:int, x:int, y:int,
			right:int, bottom:int):BBTree {

		var width:int= right - x;
		var height:int= bottom - y;
		
		if (shape.contains(x, y, width, height)) {
			return new BBTree(x, y, right, bottom);
		}
		else if (shape.intersects(x, y, width, height)) {
			var tree:BBTree= new BBTree(x, y, right, bottom);

			var tooSmallToContinue:Boolean= width <= minBoxSize;
			if (!tooSmallToContinue) {
				var centerX:int= avg(x, right);
				var centerY:int= avg(y, bottom);

				// upper left
				var t0:BBTree= makeTree(shape, minBoxSize, x, y, centerX, centerY);
				// upper right
				var t1:BBTree= makeTree(shape, minBoxSize, centerX, y, right, centerY);
				// lower left
				var t2:BBTree= makeTree(shape, minBoxSize, x, centerY, centerX, bottom);
				// lower right
				var t3:BBTree= makeTree(shape, minBoxSize, centerX, centerY, right, bottom);

				tree.addKids(t0, t1, t2, t3);
			}
			
			return tree;
		}
		else {  // neither contains nor intersects
			return null;
		}
	}

	private function avg(a:int, b:int):int {
		// reminder: x >> 1 == x / 2
		// avg = (a+b)/2 = (a/2)+(b/2) = (a>>1)+(b>>1)
		return (a + b) >> 1;
	}
}
}