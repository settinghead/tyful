
import flash.display.Graphics;
import flash.display.Shader;

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


public class BBTree {
	
	private var x:int;
	private var y:int;
	private var right:int;
	private var bottom:int;
	public var kids:Vector.<BBTree>;

	private var rootX:int;
	private var rootY:int;

	BBTree(var x:int, var y:int, var right:int, var bottom:int) {
		this.x = x;
		this.y = y;
		this.right = right;
		this.bottom = bottom;
	}


	function addKids( ... _kids):void {
		var kidList: Vector.<BBTree> = new Vector.<BBTree>();
		for (var i:Number =0; i<kidList.length; i++) {
			if (kidList[i]) {
				kidList.push(kidList[i]);
			}
		}

		this.kids =kidList;
	}

	function setLocation(x:int, y:int):void {
		this.rootX = x;
		this.rootY = y;
		
		if (!isLeaf()) {
			for (var kid:BBTree in this.kids) {
				this.kid.setLocation(x, y);
			}
		}
	}

	function overlaps(otherTree:BBTree):Boolean {
		if (rectCollide(this, otherTree)) {
			if (this.isLeaf() && otherTree.isLeaf()) {
				return true;
			}
			else if (this.isLeaf()) {  // Then otherTree isn't a leaf.
				for (BBTree otherKid : otherTree.kids) {
					if (this.overlaps(otherKid)) {
						return true;
					}
				}
			}
			else {
				for (var myKid:BBTree in this.kids) {
					if (otherTree.overlaps(myKid)) {
						return true;
					}
				}
			}
		}
		return false;
	}

	public function getPoints():Array {
		return new Array (
				this.rootX - swelling + this.x,
				this.rootY - swelling + this.y,
				this.rootX + swelling + this.right,
				this. rootY + swelling + this.bottom
		);
	}

	private function rectCollide(aTree:BBTree, bTree:BBTree):Boolean {
		var a:Array= aTree.getPoints();
		var b:Array= bTree.getPoints();
		
		return a[3] > b[1] && a[1] < b[3] && a[2] > b[0] && a[0] < b[2];
	}

	public function isLeaf():Boolean {
		return (this.kids == null);
	}

	var swelling:int= 0;
	function swell(extra:int):void {
		swelling += extra;
		if (!isLeaf()) {
			for (var i:int= 0; i < this.kids.length; i++) {
				this.kids[i].swell(extra);
			}
		}
	}

	function draw(g:Graphics):void {
//		g.pushStyle();
//		g.noFill();

		var shader: Shader = new Shader();
		g.lineStyle(null, 0xFFFF00, 0.3);		
		drawLeaves(g);
			
//		g.popStyle();
	}

	private function drawLeaves(g:Graphics):void {
		if (this.isLeaf()) {
			drawBounds(g, getPoints());
		} else {
			for (var i:int= 0; i < this.kids.length; i++) {
				this.kids[i].drawLeaves(g);
			}
		}
	}

	private function drawBounds(g:Graphics, rect:Array):void {
		g.drawRect(rect[0], rect[1], rect[2], rect[3]);
	}
}
}