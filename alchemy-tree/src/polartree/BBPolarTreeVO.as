package polartree {
	
	
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
	
	
	import mx.controls.Alert;
	
	import org.as3commons.lang.Assert;
	
	public class BBPolarTreeVO {
		
		public static const HALF_PI:Number= (Math.PI / 2);
		public static const TWO_PI:Number= ((Math.PI * 2));
		public static const PI:Number = (Math.PI);
		public static const ONE_AND_HALF_PI:Number= ((Math.PI + HALF_PI));
		
		protected var rStamp:int;
		
		protected var _x:Number, _y :Number, _right:Number, _bottom:Number;
		
		public var _r1:Number, d1:Number, _r2:Number, d2:Number;
		protected var _kids:Vector.<BBPolarChildTreeVO>;
		protected var _computedR1:Number= Number.NaN, _computedR2:Number = Number.NaN;
		private var pointsStamp:Number;
		private var _px:Number, _py:Number, _pright:Number, _pbottom:Number;
		
		public static const MARGIN:Number = 0;
		
		public function BBPolarTreeVO( r1:Number,  r2:Number, d1:Number, d2:Number, minBoxSize:int) {
			this._r1 = r1;
			this._r2 = r2;
			this.d1 = d1;
			this.d2 = d2;
			var r:Number= r2 - r1;
			var d:Number=  BBPolarTreeVO.PI * (d1+d2) * r / BBPolarTreeVO.TWO_PI;
			
			var tooSmallToContinue:Boolean= d <= minBoxSize || d2 - d1 <= minBoxSize;
			//			var tooSmallToContinue:Boolean = 
			//				this.getWidth(false) < minBoxSize || this.getHeight(false) < minBoxSize;
			if (tooSmallToContinue)
				this.setLeaf(true);
		}
		
		public function addKids(kidList:Vector.<BBPolarChildTreeVO>):void {
			_kids = kidList;
		}
		
		public function getRootX():int {
			throw new NotImplementedError();
		}
		
		public function getRootY():int {
			throw new NotImplementedError();
		}
		
		public function overlaps(otherTree:BBPolarTreeVO):Boolean {
			
			if (this.collide(otherTree)) {
				if (this.isLeaf() && otherTree.isLeaf()) {
					return true;
				} else if (this.isLeaf()) { // Then otherTree isn't a leaf.
					for each (var otherKid:BBPolarTreeVO in otherTree.getKids()) {
						if (this.overlaps(otherKid)) {
							return true;
						}
					}
				} else {
					for each (var myKid:BBPolarTreeVO  in this.getKids()) {
						if (otherTree.overlaps(myKid)) {
							return true;
						}
					}
				}
			}
			return false;
		}
		
		public function getKids():Vector.<BBPolarChildTreeVO> {
			if ((!this.isLeaf()) && this._kids == null)
				BBPolarTreeBuilder.makeChildren(this, getShape(), getMinBoxSize(),
					getRoot());
			return this._kids;
		}
		
		public function getKidsNoGrowth():Vector.<BBPolarChildTreeVO> {
			return this._kids;
		}
		
		public function getRoot():BBPolarRootTreeVO {
			throw new NotImplementedError();
		}
		
		public function getMinBoxSize():int {
			throw new NotImplementedError();
		}
		
		public function getShape():IImageShape {
			throw new NotImplementedError();
		}
		
		public function overlapsCoord(x:Number, y:Number, right:Number, bottom:Number):Boolean {
			
			if (this.rectCollideCoord(x, y, right, bottom)) {
				if (this.isLeaf()) {
					return true;
				} else {
					for each (var myKid:BBPolarChildTreeVO in this.getKids()) {
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
					for each (var myKid:BBPolarTreeVO in this.getKids()) {
						if (myKid.contains(x, y, right, bottom)) {
							return true;
						}
					}
					return false;
				}
			} else
				return false;
		}
		
		protected function computeX(rotate:Boolean):Number {throw new NotImplementedError();}
		protected function computeY(rotate:Boolean):Number  {throw new NotImplementedError();}
		protected function computeRight(rotate:Boolean):Number  {throw new NotImplementedError();}
		protected function computeBottom(rotate:Boolean):Number  {throw new NotImplementedError();}
		
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
		
		public function checkRecompute():void {
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
		
		private function checkUpdatePoints():void{
			if (this.pointsStamp != this.getCurrentStamp()) {
				this._px = getRootX() - swelling + getX(true);
				this._py = getRootY() - swelling + getY(true);
				this._pright = getRootX() + swelling + getRight(true);
				this._pbottom = getRootY() + swelling + getBottom(true);
				this.pointsStamp = this.getCurrentStamp();
				
//				try{
//					Assert.isTrue(this._px < this._pright);
//				}
//				catch(e:Error){
//					Alert.show("RootX:"+ getRootX().toString()+", "+swelling.toString()+",_X: "+_x.toString()
//					+",Right: "+ getRight(true).toString()+", xstamp: "+this.xStamp.toString()+", cstamp: "+getCurrentStamp().toString());
//				}

//				Assert.isTrue(this._py < this._pbottom);
			}
		}
		
		protected function get px():Number{
			checkUpdatePoints();
			return this._px;
		}
		
		protected function get py():Number{
			checkUpdatePoints();
			return this._py;
		}
		
		protected function get pright():Number{
			checkUpdatePoints();
			return this._pright;
		}
		
		protected function get pbottom():Number{
			checkUpdatePoints();
			return this._pbottom;
		}
		
		
		protected function collide(bTree:BBPolarTreeVO):Boolean {	
			var dist:Number = Math.sqrt(Math.pow( this.getRootX()-bTree.getRootX(), 2)+Math.pow( this.getRootY()-bTree.getRootY(), 2));
			if(dist > this.d2 + bTree.d2) return false;
			else 
			{
//				var angle1:Number = -Math.atan2(bTree.getRootY() - this.getRootY(), bTree.getRootX() - this.getRootX());
//				var angle2:Number;
//				if(angle1>=0) angle2 = angle1-Math.PI;
//				else angle2 = angle1 + Math.PI;
//				var angleSum1:Number = Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI;
//				var angleSum2:Number = Math.abs(this.getR1(true)-angle1)%Math.PI+Math.abs(bTree.getR2(true)-angle2)%Math.PI;
//				if(Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI>Math.PI 
//					&& Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR2(true)-angle2)%Math.PI>Math.PI
//				&& Math.abs(this.getR1(true)-angle1)%Math.PI + Math.abs(bTree.getR2(true)-angle2)%Math.PI
//				&& Math.abs(this.getR1(true)-angle1)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI) return false;
				return rectCollide(bTree);
			}
		}
		
		
		protected function rectCollide(bTree:BBPolarTreeVO):Boolean {	
			return rectCollideCoord(bTree.px, bTree.py, bTree.pright, bTree.pbottom);
		}
		
		private function rectContain(x:Number, y:Number, right:Number, bottom:Number):Boolean {
			return this.px <= x && this.py <= y && this.pright >= right && this.pbottom >= bottom;
		}
		
		private function rectCollideCoord(x:Number, y:Number, right:Number, bottom:Number):Boolean {
			
			//			var margin:int = 2;
			return this.pbottom > y && this.py < bottom  && this.pright > x && this.px < right;
		}
		
		public function isLeaf():Boolean {
			return _leaf;
		}
		
		private var swelling:int= 0;
		private var xStamp:Number, yStamp:Number, rightStamp:Number, bottomStamp:Number;
		private var _leaf:Boolean= false;
		private var _relativeX:Number= Number.NaN, _relativeY:Number = Number.NaN,
			_relativeRight:Number = Number.NaN, _relativeBottom:Number = Number.NaN;
		
		public function swell(extra:int):void {
			swelling += extra;
			if (!isLeaf()) {
				for (var i:int= 0; i < getKids().length; i++) {
					getKids()[i].swell(extra);
				}
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
				return _x - MARGIN;
			} else
				return getRelativeX();
		}
		
		public function getY(rotate:Boolean):Number {
			if (rotate) {
				checkComputeY();
				return _y - MARGIN;
			} else
				return getRelativeY();
		}
		
		public function getRight(rotate:Boolean):Number {
			if (rotate) {
				checkComputeRight();
				return _right + MARGIN;
			} else
				return getRelativeRight();
		}
		
		public function getBottom(rotate:Boolean):Number {
			if (rotate) {
				checkComputeBottom();
				return _bottom + MARGIN;
			}
			return getRelativeBottom();
		}
		
		/**
		 * @return the rotation
		 */
		public  function getRotation():Number {
			throw new NotImplementedError();
		}
		
		public function getCurrentStamp():Number {
			throw new NotImplementedError();
		}
		
		public function setLeaf(b:Boolean):void {
			this._leaf = b;
		}
		
		
		public function toString(indent:int = 0):String{
			var indentStr:String = "";
			for (var i:int = 0; i < indent; i++) 
			{
				indentStr+=" ";
			}
			
			var childrenStr:String = "";
			
			for each (var k:BBPolarTreeVO in getKids()) 
			{
				childrenStr+=k.toString(indent+1);
			}
			
			
			return indentStr + "R1: "+getR1(false).toString()
				+", R2: "+getR2(false).toString()
			+", D1: "+d1.toString()
			+", D2: "+d2.toString() + "\n"
			+childrenStr;
		}
	}
}