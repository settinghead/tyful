package com.settinghead.groffle.client.model.algo.tree;	
	
	
class BBPolarTreeVO {
		
	public static inline var HALF_PI:Float= (Math.PI / 2);
	public static inline var TWO_PI:Float= ((Math.PI * 2));
	public static inline var PI:Float = (Math.PI);
	public static inline var ONE_AND_HALF_PI:Float= ((Math.PI + HALF_PI));
		
	private var rStamp:Int;	
	private var _x : Float;
	private var _y: Float;
	private var _right : Float;
	private var  _bottom:Float;

	public var _r1:Float;public var d1:Float;public var _r2:Float;public var d2:Float;
	private var _kids:Array<BBPolarChildTreeVO>;
	private var _computedR1:Float;private var _computedR2:Float;
	private var pointsStamp:Float;
	private var _px:Float;private var _py:Float;private var _pright:Float;private var _pbottom:Float;
	private var xStamp:Float;private var yStamp:Float;private var rightStamp:Float;private var bottomStamp:Float;
	private var _leaf:Bool;
	private var _relativeX:Float;private var _relativeY:Float;
	private var _relativeRight:Float;private var _relativeBottom:Float;
		
	
	public static inline var MARGIN:Float = 0;
		
	public function new( r1:Float,  r2:Float, d1:Float, d2:Float, minBoxSize:Int) {
		_computedR1 = Math.NaN;
		_computedR2 = Math.NaN;
		swelling = 0;
		_leaf = false;
		this._r1 = r1;
		this._r2 = r2;
		this.d1 = d1;
		this.d2 = d2;
		
		_relativeX = Math.NaN;
		_relativeY = Math.NaN;
		_relativeRight = Math.NaN;
		_relativeBottom = Math.NaN;
		
		var r:Float= r2 - r1;
		var d:Float=  BBPolarTreeVO.PI * (d1+d2) * r / BBPolarTreeVO.TWO_PI;
			
		var tooSmallToContinue:Bool= d <= minBoxSize || d2 - d1 <= minBoxSize;
		//			var tooSmallToContinue:Bool = 
		//				this.getWidth(false) < minBoxSize || this.getHeight(false) < minBoxSize;
		if (tooSmallToContinue)
			this.setLeaf(true);
	}
		
	public function addKids(kidList:Array<BBPolarChildTreeVO>):Void {
		_kids = kidList;
	}
		
	public function getRootX():Int {
		throw "NotImplementedError";
		return 0;
	}
		
	public function getRootY():Int {
		throw "NotImplementedError";
		return 0;
	}
		
	public function overlaps(otherTree:BBPolarTreeVO):Bool {
			
		if (this.collide(otherTree)) {
			if (this.isLeaf() && otherTree.isLeaf()) {
				return true;
			} else if (this.isLeaf()) { // Then otherTree isn't a leaf.
				for (otherKid in otherTree.getKids()) {
					if (this.overlaps(otherKid)) {
						return true;
					}
				}
			} else {
				for (myKid in this.getKids()) {
					if (otherTree.overlaps(myKid)) {
						return true;
					}
				}
			}
		}
		return false;
	}
		
	public function getKids():Array<BBPolarChildTreeVO> {
		if ((!this.isLeaf()) && this._kids == null)
			BBPolarTreeBuilder.makeChildren(this, getShape(), getMinBoxSize(),
				getRoot());
		return this._kids;
	}
		
	public function getKidsNoGrowth():Array<BBPolarChildTreeVO> {
		return this._kids;
	}
		
	public function getRoot():BBPolarRootTreeVO {
		throw "NotImplementedError";
		return null;
	}
		
	public function getMinBoxSize():Int {
		throw "NotImplementedError";
		return 0;
	}
		
	public function getShape():IImageShape {
		throw "NotImplementedError";
		return null;
	}
		
	public function overlapsCoord(x:Float, y:Float, right:Float, bottom:Float):Bool {
			
		if (this.rectCollideCoord(x, y, right, bottom)) {
			if (this.isLeaf()) {
				return true;
			} else {
				for (myKid in this.getKids()) {
					if (myKid.overlapsCoord(x, y, right, bottom)) {
						return true;
					}
				}
			}
		}
		return false;
	}
		
	public function contains(x:Float, y:Float, right:Float, bottom:Float):Bool {
			
		if (this.rectContain(x, y, right, bottom)) {
			if (this.isLeaf())
				return true;
			else {
				for (myKid in this.getKids()) {
					if (myKid.contains(x, y, right, bottom)) {
						return true;
					}
				}
				return false;
			}
		} else
			return false;
	}
		
	private function computeX(rotate:Bool):Float {throw "NotImplementedError";return Math.NaN;}
	private function computeY(rotate:Bool):Float  {throw "NotImplementedError";return Math.NaN;}
	private function computeRight(rotate:Bool):Float  {throw "NotImplementedError";return Math.NaN;}
	private function computeBottom(rotate:Bool):Float  {throw "NotImplementedError";return Math.NaN;}
		
	public inline function getR1(rotate:Bool):Float {
		if (rotate) {
			checkRecompute();
			return this._computedR1;
		} else
			return this._r1;
	}
		
	public inline function getR2(rotate:Bool):Float {
		if (rotate) {
			checkRecompute();
			return this._computedR2;
		} else
			return this._r2;
	}
		
	public inline function checkRecompute():Void {
		if (this.rStamp != this.getCurrentStamp()) {
			computeR1();
			computeR2();
			this.rStamp = this.getCurrentStamp();
		}
	}
		
	private inline function computeR1():Void {
		_computedR1 = this._r1 + getRotation();
		if (_computedR1 > TWO_PI)
			this._computedR1 = this._computedR1 % TWO_PI;
			
	}
		
	private inline function computeR2():Void {
		this._computedR2 = this._r2 + getRotation();
		if (this._computedR2 > TWO_PI)
			this._computedR2 = this._computedR2 % TWO_PI;
			
	}
		
	private inline function checkUpdatePoints():Void{
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
		
	private inline function px():Float{
		checkUpdatePoints();
		return this._px;
	}
		
	private inline function py():Float{
		checkUpdatePoints();
		return this._py;
	}
		
	private inline function pright():Float{
		checkUpdatePoints();
		return this._pright;
	}
		
	private inline function pbottom():Float{
		checkUpdatePoints();
		return this._pbottom;
	}
		
		
	private inline function collide(bTree:BBPolarTreeVO):Bool {	
		var dist:Float = Math.sqrt(Math.pow( this.getRootX()-bTree.getRootX(), 2)+Math.pow( this.getRootY()-bTree.getRootY(), 2));
		if(dist > this.d2 + bTree.d2) return false;
		else 
		{
//				var angle1:Float = -Math.atan2(bTree.getRootY() - this.getRootY(), bTree.getRootX() - this.getRootX());
//				var angle2:Float;
//				if(angle1>=0) angle2 = angle1-Math.PI;
//				else angle2 = angle1 + Math.PI;
//				var angleSum1:Float = Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI;
//				var angleSum2:Float = Math.abs(this.getR1(true)-angle1)%Math.PI+Math.abs(bTree.getR2(true)-angle2)%Math.PI;
//				if(Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI>Math.PI 
//					&& Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR2(true)-angle2)%Math.PI>Math.PI
//				&& Math.abs(this.getR1(true)-angle1)%Math.PI + Math.abs(bTree.getR2(true)-angle2)%Math.PI
//				&& Math.abs(this.getR1(true)-angle1)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI) return false;
			return rectCollide(bTree);
		}
	}
		
		
	private inline function rectCollide(bTree:BBPolarTreeVO):Bool {	
		return rectCollideCoord(bTree.px(), bTree.py(), bTree.pright(), bTree.pbottom());
	}
		
	private inline function rectContain(x:Float, y:Float, right:Float, bottom:Float):Bool {
		return this.px() <= x && this.py() <= y && this.pright() >= right && this.pbottom() >= bottom;
	}
		
	private inline function rectCollideCoord(x:Float, y:Float, right:Float, bottom:Float):Bool {
			
		//			var margin:Int = 2;
		return this.pbottom() > y && this.py() < bottom  && this.pright() > x && this.px() < right;
	}
		
	public inline function isLeaf():Bool {
		return _leaf;
	}
		
	private var swelling:Int;
	
	public function swell(extra:Int):Void {
		swelling += extra;
		if (!isLeaf()) {
			var i = 0;
			while(i < getKids().length) {
				getKids()[i].swell(extra);
				i++;
			}
		}
	}
		
		
		
	public function getWidth(rotate:Bool):Float {
		return this.getRight(rotate) - this.getX(rotate);
	}
		
	public function getHeight(rotate:Bool):Float {
		return this.getBottom(rotate) - this.getY(rotate);
	}
		
	/**
	 * @param rotation
	 *            the rotation to set
	 */
		
	private inline function checkComputeX():Void {
		if (this.xStamp != this.getCurrentStamp()) {
			this._x = computeX(true);
			this.xStamp = this.getCurrentStamp();
		}
	}
		
	private inline function checkComputeY():Void {
		if (this.yStamp != this.getCurrentStamp()) {
			this._y = computeY(true);
			this.yStamp = this.getCurrentStamp();
		}
			
	}
		
	private inline function checkComputeRight():Void {
		if (this.rightStamp != this.getCurrentStamp()) {
			this._right = computeRight(true);
			this.rightStamp = this.getCurrentStamp();
		}
	}
		
	private inline function checkComputeBottom():Void {
		if (this.bottomStamp != this.getCurrentStamp()) {
			this._bottom = computeBottom(true);
			this.bottomStamp = this.getCurrentStamp();
		}
	}
		
	private inline function getRelativeX():Float {
		if (Math.isNaN(this._relativeX))
			this._relativeX = computeX(false);
		return this._relativeX;
	}
		
	private inline function getRelativeY():Float {
		if (Math.isNaN(this._relativeY))
			this._relativeY = computeY(false);
		return this._relativeY;
	}
		
	private inline function getRelativeRight():Float {
		if (Math.isNaN(this._relativeRight))
			this._relativeRight = computeRight(false);
		return this._relativeRight;
	}
		
	private inline function getRelativeBottom():Float {
		if (Math.isNaN(this._relativeBottom))
			this._relativeBottom = computeBottom(false);
		return this._relativeBottom;
	}
		
	public function getX(rotate:Bool):Float {
		if (rotate) {
			checkComputeX();
			return _x - MARGIN;
		} else
			return getRelativeX();
	}
		
	public function getY(rotate:Bool):Float {
		if (rotate) {
			checkComputeY();
			return _y - MARGIN;
		} else
			return getRelativeY();
	}
		
	public function getRight(rotate:Bool):Float {
		if (rotate) {
			checkComputeRight();
			return _right + MARGIN;
		} else
			return getRelativeRight();
	}
		
	public function getBottom(rotate:Bool):Float {
		if (rotate) {
			checkComputeBottom();
			return _bottom + MARGIN;
		}
		return getRelativeBottom();
	}
		
	/**
	 * @return the rotation
	 */
	public  function getRotation():Float {
		throw "NotImplementedError";
		return Math.NaN;
	}
		
	public function getCurrentStamp():Int {
		throw "NotImplementedError";
		return -1;
	}
		
	public function setLeaf(b:Bool):Void {
		this._leaf = b;
	}
		
		
	public function toString(indent:Int = 0):String{
		var indentStr:String = "";
		var i = 0;
		while ( i < indent) {
			indentStr+=" ";
			i++;
		}	
		var childrenStr:String = "";
		
		var kids = getKids();
		if(kids!=null){
			for (k in kids) 

			{
				if(k!=null)
					childrenStr+=k.toString(indent+1);
			}
		}
		
	
		return indentStr + "R1: "+getR1(false)
			+", R2: "+getR2(false)
		+", D1: "+d1
		+", D2: "+d2 + "\r\n"
		+childrenStr;
	}
}
