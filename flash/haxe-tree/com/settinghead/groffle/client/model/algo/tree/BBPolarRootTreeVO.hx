package com.settinghead.groffle.client.model.algo.tree;	
class BBPolarRootTreeVO extends BBPolarTreeVO {
	private var rootX:Int;
	private var rootY:Int;
	private var _rotation:Float;
	private var rootStamp:Int;
	private var shape:IImageShape;
	private var _minBoxSize:Int;
		
	public function new(shape:IImageShape, centerX:Int, centerY:Int,
									d:Float, minBoxSize:Int) {
		super(0, BBPolarTreeVO.TWO_PI, 0, d, minBoxSize);
		
		_rotation = 0;
		rootStamp = 0;
		this.rootX = centerX;
		this.rootY = centerY;
		this.shape = shape;
		this._minBoxSize = minBoxSize;
		this.rootStamp++;
	}
		
	public inline function setLocation(centerX:Int, centerY:Int):Void {
		this.rootX = centerX;
		this.rootY = centerY;
		this.rootStamp++;
	}
		
		
	public override inline function getRootX():Int {
		return rootX;
	}
		
		
	public override inline function getRootY():Int {
		return rootY;
	}
		
		
	private override inline function computeX(rotate:Bool):Float {
//			if(shape.width<STOP_COMPUTE_TREE_THRESHOLD)
//				return -shape.width/2;
//			else 
			return -d2;
	}
		
		
	private override inline function computeY(rotate:Bool):Float {
//			if(shape.height<STOP_COMPUTE_TREE_THRESHOLD)
//				return -shape.height/2;
//			else 
			return -d2;
	}
		
		
	private override inline function computeRight(rotate:Bool):Float {
//			if(shape.width<STOP_COMPUTE_TREE_THRESHOLD)
//				return shape.width/2;
//			else 
			return (d2);
	}
		
		
	private override inline function computeBottom(rotate:Bool):Float {
//			if(shape.height<STOP_COMPUTE_TREE_THRESHOLD)
//				return -shape.height/2;
//			else 
			return (d2);
	}
		
	public inline function setRotation(rotation:Float):Void {
		this._rotation = rotation % BBPolarTreeVO.TWO_PI;
		if(this._rotation<0)
			this._rotation = BBPolarTreeVO.TWO_PI + this._rotation;
		this.rootStamp++;
	}
		
		
	override public inline function getRotation():Float {
		return this._rotation;
	}
		
		
	public override inline function getCurrentStamp():Int {
		return this.rootStamp;
	}
		
		
	public override inline function getRoot():BBPolarRootTreeVO {
		return this;
	}
		
		
	public override inline function getMinBoxSize():Int {
		return this._minBoxSize;
	}
		
		
	public override inline function getShape():IImageShape {
		return this.shape;
	}
		
//		public override function overlaps(otherTree:BBPolarTreeVO):Bool {
//			var min:Float = 30;
//			if(this.getHeight(false)<min || 
//				this.getWidth(false)<min || 
//				otherTree.getHeight(false)<min ||
//				otherTree.getWidth(false)<min
//			){
//				return rectCollide(otherTree);
//			}
//			else
//				return super.overlaps(otherTree);
//		}
		
}
