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
	
	import org.as3commons.lang.Assert;
	
	public class BBPolarTree {
		
		public static const HALF_PI:Number= ((Math.PI / 2));
		public static const TWO_PI:Number= ((Math.PI * 2));
		public static const PI:Number = (Math.PI);
		public static const ONE_AND_HALF_PI:Number= ((Math.PI + HALF_PI));
		
		protected var rStamp:Number;
		
		protected var _x:Number, _y :Number, _right:Number, _bottom:Number;
		
		public var _r1:Number, d1:Number, _r2:Number, d2:Number;
		protected var _kids:Vector.<BBPolarChildTree>;
		protected var _computedR1:Number= Number.NaN, _computedR2:Number = Number.NaN;
		private var pointsStamp:Number;
		private var _points:Array= null;
	
		public function BBPolarTree( r1:Number,  r2:Number, d1:Number, d2:Number, minBoxSize:int) {
			this._r1 = r1;
			this._r2 = r2;
			this.d1 = d1;
			this.d2 = d2;
			var r:Number= r2 - r1;
			var d:Number=  BBPolarTree.PI * (d1+d2) * r / BBPolarTree.TWO_PI;
	
			var tooSmallToContinue:Boolean= d <= minBoxSize || d2 - d1 < minBoxSize;
			if (tooSmallToContinue)
				this.setLeaf(true);
		}
	
		function addKids(kidList:Vector.<BBPolarChildTree>):void {
			_kids = kidList;
		}
	
		 function getRootX():int {
			throw new NotImplementedError();
		 }
	
		function getRootY():int {
			throw new NotImplementedError();
		}
	
		function overlaps(otherTree:BBPolarTree):Boolean {
	
			if (this.rectCollide(otherTree)) {
				if (this.isLeaf() && otherTree.isLeaf()) {
					return true;
				} else if (this.isLeaf()) { // Then otherTree isn't a leaf.
					for each (var otherKid:BBPolarTree in otherTree.getKids()) {
						if (this.overlaps(otherKid)) {
							return true;
						}
					}
				} else {
					for each (var myKid:BBPolarTree  in this.getKids()) {
						if (otherTree.overlaps(myKid)) {
							return true;
						}
					}
				}
			}
			return false;
		}
	
		private function getKids():Vector.<BBPolarChildTree> {
			if ((!this.isLeaf()) && this._kids == null)
				BBPolarTreeBuilder.makeChildren(this, getShape(), getMinBoxSize(),
						getRoot());
			return this._kids;
		}
	
		 function getRoot():BBPolarRootTree {
			 throw new NotImplementedError();
		 }
	
		 function getMinBoxSize():int {
			 throw new NotImplementedError();
		 }
	
		 function getShape():ImageShape {
			 throw new NotImplementedError();
		 }
	
		function overlapsCoord(x:Number, y:Number, right:Number, bottom:Number):Boolean {
	
			if (this.rectCollideCoord(x, y, right, bottom)) {
				if (this.isLeaf()) {
					return true;
				} else {
					for each (var myKid:BBPolarChildTree in this.getKids()) {
						if (myKid.overlapsCoord(x, y, right, bottom)) {
							return true;
						}
					}
				}
			}
			return false;
		}
	
		public function contains(x:Number, y:Number, right:Number, bottom:Number):Boolean {
	
			if (this.rectContain(x, y, right, bottom)) {
				if (this.isLeaf())
					return true;
				else {
					for each (var myKid:BBPolarTree in this.getKids()) {
						if (myKid.contains(x, y, right, bottom)) {
							return true;
						}
					}
					return false;
				}
			} else
				return false;
		}
	
		 function computeX(rotate:Boolean):Number {throw new NotImplementedError();}
		 function computeY(rotate:Boolean):Number  {throw new NotImplementedError();}
		 function computeRight(rotate:Boolean):Number  {throw new NotImplementedError();}
		 function computeBottom(rotate:Boolean):Number  {throw new NotImplementedError();}
	
		public function getR1(rotate:Boolean):Number {
			if (rotate) {
				checkRecompute();
				return this._computedR1;
			} else
				return this._r1;
		}
	
		public function getR2(rotate:Boolean):Number {
			if (rotate) {
				checkRecompute();
				return this._computedR2;
			} else
				return this._r2;
		}
	
		function checkRecompute():void {
			if (this.rStamp != this.getCurrentStamp()) {
				computeR1();
				computeR2();
				this.rStamp = this.getCurrentStamp();
			}
		}
	
		private function computeR1():void {
			_computedR1 = this._r1 + getRotation();
			if (_computedR1 > TWO_PI)
				this._computedR1 = this._computedR1 % TWO_PI;
	
		}
	
		private function computeR2():void {
			this._computedR2 = this._r2 + getRotation();
			if (this._computedR2 > TWO_PI)
				this._computedR2 = this._computedR2 % TWO_PI;
	
		}
	
		private function getPoints():Array {
			if (this.pointsStamp != this.getCurrentStamp()) {
				this._points = new Array( getRootX() - swelling + getX(true),
						getRootY() - swelling + getY(true),
						getRootX() + swelling + getRight(true),
						getRootY() + swelling + getBottom(true) );
				this.pointsStamp = this.getCurrentStamp();
			}
			return this._points;
		}
	
		private function rectCollide(bTree:BBPolarTree):Boolean {
			var b:Array= bTree.getPoints();
	
			return rectCollideCoord(b[0], b[1], b[2], b[3]);
		}
	
		private function rectContain(x:Number, y:Number, right:Number, bottom:Number):Boolean {
			var a:Array= this.getPoints();
			return a[0] <= x && a[1] <= y && a[2] >= right && a[3] >= bottom;
		}
	
		private function rectCollideCoord(x:Number, y:Number, right:Number, bottom:Number):Boolean {
			var a:Array= this.getPoints();
	
			Assert.isTrue(a[0] < a[2]);
			Assert.isTrue(a[1] < a[3]);
			Assert.isTrue(x < right);
			Assert.isTrue(y < bottom);
	
			return a[3] > y && a[1] < bottom && a[2] > x && a[0] < right;
		}
	
		function isLeaf():Boolean {
			return _leaf;
		}
	
		var swelling:int= 0;
		private var xStamp:Number, yStamp:Number, rightStamp:Number, bottomStamp:Number;
		private var _leaf:Boolean= false;
		private var _relativeX:Number= Number.NaN, _relativeY:Number = Number.NaN,
				_relativeRight:Number = Number.NaN, _relativeBottom:Number = Number.NaN;
	
		function swell(extra:int):void {
			swelling += extra;
			if (!isLeaf()) {
				for (var i:int= 0; i < getKids().length; i++) {
					getKids()[i].swell(extra);
				}
			}
		}
	
		
	
		function draw(g:Graphics):void {
			drawLeaves(g);
		}
	
		private function drawLeaves(g:Graphics):void {
			if (this.isLeaf()) {
				drawBounds(g);
			} else {
				for (var i:int= 0; i < getKids().length; i++) {
					getKids()[i].drawLeaves(g);
				}
			}
		}
	
	
		private function drawBounds(g:Graphics):void {
			var x1:int, x2:int, x3:int, x4:int, y1:int, y2:int, y3:int, y4:int;
			x1 = int((this.getRootX() + this.d1 * Math.cos(getR1(true))));
			y1 = int((this.getRootY() - this.d1 * Math.sin(getR1(true))));
			x2 = int((this.getRootX() + this.d1 * Math.cos(getR2(true))));
			y2 = int((this.getRootY() - this.d1 * Math.sin(getR2(true))));
			x3 = int((this.getRootX() + this.d2 * Math.cos(getR1(true))));
			y3 = int((this.getRootY() - this.d2 * Math.sin(getR1(true))));
			x4 = int((this.getRootX() + this.d2 * Math.cos(getR2(true))));
			y4 = int((this.getRootY() - this.d2 * Math.sin(getR2(true))));
	
			var r:Number= this.getR2(true) - this.getR1(true);
			if (r < 0)
				r = TWO_PI + r;
			Assert.isTrue(r < PI);
	
			drawArc(g, this.getRootX(),
					this.getRootY(), this.d2,
					 this.getR1(true), this.getR2(true), 1);
			drawArc(g, this.getRootX(),
					this.getRootY(), this.d1,
					 this.getR1(true), this.getR2(true), 1);
			g.moveTo(x1,y1);
			g.lineTo(x3,y3);
			g.moveTo(x2,y2);
			g.lineTo(x4,y4);
		}

		public function drawArc(g:Graphics,center_x:Number,center_y:Number,
								 radius:Number,angle_from:Number,angle_to:Number,precision:Number):void {
			var angle_diff:Number=angle_to-angle_from;
			var steps:Number=Math.round(angle_diff*precision);
			if(steps==0) steps = 1;
			var angle:Number=angle_from;
			var px:Number=center_x+radius*Math.cos(angle);
			var py:Number=center_y-radius*Math.sin(angle);
			g.moveTo(px,py);
			for (var i:int=1; i<=steps; i++) {
				angle=angle_from+angle_diff/steps*i;
				g.lineTo(center_x+radius*Math.cos(angle),center_y-radius*Math.sin(angle));
			}
		}
	
		public function getWidth(rotate:Boolean):Number {
			return this.getRight(rotate) - this.getX(rotate);
		}
	
		public function getHeight(rotate:Boolean):Number {
			return this.getBottom(rotate) - this.getY(rotate);
		}
	
		/**
		 * @param rotation
		 *            the rotation to set
		 */
	
		private function checkComputeX():void {
			if (this.xStamp != this.getCurrentStamp()) {
				this._x = computeX(true);
				this.xStamp = this.getCurrentStamp();
			}
		}
	
		private function checkComputeY():void {
			if (this.yStamp != this.getCurrentStamp()) {
				this._y = computeY(true);
				this.yStamp = this.getCurrentStamp();
			}
	
		}
	
		private function checkComputeRight():void {
			if (this.rightStamp != this.getCurrentStamp()) {
				this._right = computeRight(true);
				this.rightStamp = this.getCurrentStamp();
			}
		}
	
		private function checkComputeBottom():void {
			if (this.bottomStamp != this.getCurrentStamp()) {
				this._bottom = computeBottom(true);
				this.bottomStamp = this.getCurrentStamp();
			}
		}
	
		private function getRelativeX():Number {
			if (isNaN(this._relativeX))
				this._relativeX = computeX(false);
			return this._relativeX;
		}
	
		private function getRelativeY():Number {
			if (isNaN(this._relativeY))
				this._relativeY = computeY(false);
			return this._relativeY;
		}
	
		private function getRelativeRight():Number {
			if (isNaN(this._relativeRight))
				this._relativeRight = computeRight(false);
			return this._relativeRight;
		}
	
		private function getRelativeBottom():Number {
			if (isNaN(this._relativeBottom))
				this._relativeBottom = computeBottom(false);
			return this._relativeBottom;
		}
	
		public function getX(rotate:Boolean):Number {
			if (rotate) {
				checkComputeX();
				return _x;
			} else
				return getRelativeX();
		}
	
		public function getY(rotate:Boolean):Number {
			if (rotate) {
				checkComputeY();
				return _y;
			} else
				return getRelativeY();
		}
	
		public function getRight(rotate:Boolean):Number {
			if (rotate) {
				checkComputeRight();
				return _right;
			} else
				return getRelativeRight();
		}
	
		public function getBottom(rotate:Boolean):Number {
			if (rotate) {
				checkComputeBottom();
				return _bottom;
			}
			return getRelativeBottom();
		}
	
		/**
		 * @return the rotation
		 */
		public  function getRotation():Number {
			throw new NotImplementedError();
		}
	
		 function getCurrentStamp():Number {
			 throw new NotImplementedError();
		 }
	
		public function setLeaf(b:Boolean):void {
			this._leaf = b;
		}
	
	}
}