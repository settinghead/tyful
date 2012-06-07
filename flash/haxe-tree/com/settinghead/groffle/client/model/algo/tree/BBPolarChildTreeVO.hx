package com.settinghead.groffle.client.model.algo.tree;	
class BBPolarChildTreeVO extends BBPolarTreeVO {
			
	private var root:BBPolarRootTreeVO;
			
	public function new(r1:Float, r2:Float,
										  d1:Float, d2:Float, 
									 root:BBPolarRootTreeVO,  minBoxSize:Int) {
			super(r1, r2, d1, d2, minBoxSize);
			this.root = root;
		}
			
			
	public override function getRootX():Int {
		return root.getRootX();
	}
			
			
	public override function getRootY():Int {
		return root.getRootY();
	}
			
			
	private override function computeX(rotate:Bool):Float {
		var x:Float;
		if (getR1(rotate) < BBPolarTreeVO.HALF_PI) {
			if (getR2(rotate) < getR1(rotate)) {
				x = d2 * Math.cos(BBPolarTreeVO.PI);
			} else if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				x = d1 * Math.cos(getR2(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.PI) {
				x = d2 * Math.cos(getR2(rotate));
			} else {
				// circle
				x = d2 * Math.cos(BBPolarTreeVO.PI);
			}
		} else if (getR1(rotate) < BBPolarTreeVO.PI) {
			if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				x = d2 * Math.cos(BBPolarTreeVO.PI);
			} else if (getR2(rotate) < BBPolarTreeVO.PI) {
				x = d2 * Math.cos(getR2(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
				x = d2 * Math.cos(BBPolarTreeVO.PI);
			} else {
				x = d2 * Math.cos(BBPolarTreeVO.PI);
			}
		} else if (getR1(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
			if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				x = d2 * Math.cos(getR1(rotate));
			} else if (getR2(rotate) < getR1(rotate)) {
				var x1:Float= d2 * Math.cos(getR1(rotate));
				var x2:Float= d2 * Math.cos(getR2(rotate));
				x = x1 < x2 ? x1 : x2;
			} else if (getR2(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
				x = d2 * Math.cos(getR1(rotate));
			} else {
				x = d2 * Math.cos(getR1(rotate));
			}
		} else {
			if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				var xx1:Float= d1 * Math.cos(getR1(rotate));
				var xx2:Float= d1 * Math.cos(getR2(rotate));
				x = xx1 < xx2 ? xx1 : xx2;
			} else if (getR2(rotate) < BBPolarTreeVO.PI) {
				x = d2 * Math.cos(getR2(rotate));
			} else if (getR2(rotate) < getR1(rotate)) {
				x = d2 * Math.cos(BBPolarTreeVO.PI);
			} else
				x = d1 * Math.cos(getR1(rotate));
		}
		return x;
	}
			
			
	private override function computeY(rotate:Bool):Float {
		var y:Float;
		if (getR1(rotate) < BBPolarTreeVO.HALF_PI) {
			if (getR2(rotate) < getR1(rotate)) {
				y = d1 * Math.sin(BBPolarTreeVO.HALF_PI);
			} else if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				y = d2 * Math.sin(getR2(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.PI) {
				y = d2 * Math.sin(BBPolarTreeVO.HALF_PI);
			} else {
				// circle
				y = d2 * Math.sin(BBPolarTreeVO.BBPolarTreeVO.HALF_PI);
			}
		} else if (getR1(rotate) < BBPolarTreeVO.PI) {
			if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				var y1:Float= d2 * Math.sin(getR1(rotate));
				var y2:Float= d2 * Math.sin(getR2(rotate));
				y = y1 > y2 ? y1 : y2;
			} else if (getR2(rotate) < getR1(rotate))
				y = d2 * Math.sin(BBPolarTreeVO.HALF_PI);
			else
				y = d2 * Math.sin(getR1(rotate));
		} else if (getR1(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
			if (getR2(rotate) < BBPolarTreeVO.PI) {
				y = d2 * Math.sin(BBPolarTreeVO.HALF_PI);
			} else if (getR2(rotate) < getR1(rotate)) {
				y = d1 * Math.sin(getR2(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
				y = d1 * Math.sin(getR1(rotate));
			} else {
				var val1:Float= d1 * Math.sin(getR2(rotate));
				var val2:Float= d1 * Math.sin(getR1(rotate));
				y = val1 > val2 ? val1 : val2;
			}
					
		} else {
			if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				y = d2 * Math.sin(getR2(rotate));
			} else if (getR2(rotate) < getR1(rotate)) {
				y = d2 * Math.sin(BBPolarTreeVO.HALF_PI);
			} else
				y = d1 * Math.sin(getR2(rotate));
		}
		y = -y;
		return y;
	}
			
			
	private override function computeRight(rotate:Bool):Float {
		var right:Float;
		if (getR1(rotate) < BBPolarTreeVO.HALF_PI) {
			if (getR2(rotate) < getR1(rotate)) {
				right = d2 * Math.cos(0);
			} else if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				right = d2 * Math.cos(getR1(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.PI) {
				right = d2 * Math.cos(getR1(rotate));
			} else {
				// circle
				right = d2 * Math.cos(0);
			}
		} else if (getR1(rotate) < BBPolarTreeVO.PI) {
			if (getR2(rotate) < getR1(rotate)) {
				right = d2 * Math.cos(0);
			} else if (getR2(rotate) < BBPolarTreeVO.PI) {
				right = d1 * Math.cos(getR1(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
				var val1:Float= d1 * Math.cos(getR1(rotate));
				var val2:Float= d1 * Math.cos(getR2(rotate));
				right = val1 > val2 ? val1 : val2;
			} else {
				right = d2 * Math.cos(getR2(rotate));
			}
		} else if (getR1(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
			if (getR2(rotate) < getR1(rotate)) {
				right = d2 * Math.cos(0);
			} else if (getR2(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
				right = d1 * Math.cos(getR2(rotate));
			} else {
				right = d2 * Math.cos(getR2(rotate));
			}
					
		} else {
			if (getR2(rotate) < getR1(rotate)) {
				right = d2 * Math.cos(0);
			} else
				right = d2 * Math.cos(getR2(rotate));
		}
				
		return right;
				
	}
			
			
	private override function computeBottom(rotate:Bool):Float {
		var bottom:Float;
		if (getR1(rotate) < BBPolarTreeVO.HALF_PI) {
			if (getR2(rotate) < getR1(rotate)) {
				bottom = d1 * Math.sin(BBPolarTreeVO.ONE_AND_HALF_PI);
			} else if (getR2(rotate) < BBPolarTreeVO.HALF_PI) {
				bottom = d1 * Math.sin(getR1(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.PI) {
				var val1:Float= d1 * Math.sin(getR1(rotate));
				var val2:Float= d1 * Math.sin(getR2(rotate));
				bottom = val1 < val2 ? val1 : val2;
			} else {
				// circle
				bottom = d2 * Math.sin(BBPolarTreeVO.ONE_AND_HALF_PI);
			}
		} else if (getR1(rotate) < BBPolarTreeVO.PI) {
			if (getR2(rotate) < getR1(rotate)) {
				bottom = d1 * Math.sin(BBPolarTreeVO.ONE_AND_HALF_PI);
			} else if (getR2(rotate) < BBPolarTreeVO.PI) {
				bottom = d1 * Math.sin(getR2(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
				bottom = d2 * Math.sin(getR2(rotate));
			} else {
				bottom = d2 * Math.sin(BBPolarTreeVO.ONE_AND_HALF_PI);
			}
		} else if (getR1(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
			if (getR2(rotate) < getR1(rotate)) {
				bottom = d2 * Math.sin(BBPolarTreeVO.ONE_AND_HALF_PI);
			} else if (getR2(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
				bottom = d2 * Math.sin(getR2(rotate));
			} else {
				bottom = d2 * Math.sin(BBPolarTreeVO.ONE_AND_HALF_PI);
			}
					
		} else {
			if (getR2(rotate) < BBPolarTreeVO.PI) {
				bottom = d2 * Math.sin(getR1(rotate));
			} else if (getR2(rotate) < BBPolarTreeVO.ONE_AND_HALF_PI) {
				var b1:Float= d2 * Math.sin(getR1(rotate));
				var b2:Float= d2 * Math.sin(getR2(rotate));
				bottom = b1 < b2 ? b1 : b2;
			} else if (getR2(rotate) < getR1(rotate)) {
				bottom = Math.cos(BBPolarTreeVO.BBPolarTreeVO.ONE_AND_HALF_PI);
			} else
				bottom = d2 * Math.sin(getR1(rotate));
		}
		bottom = -bottom;
		return bottom;
	}
			
			
	override public function getRotation():Float {
		return root.getRotation();
	}
			
			
	public override function getCurrentStamp():Int {
		return root.getCurrentStamp();
	}
			
	public override function getRoot():BBPolarRootTreeVO {
		return root;
	}
			
			
	public override function getMinBoxSize():Int {
		return root.getMinBoxSize();
	}
			
			
	public override function getShape():IImageShape {
		return root.getShape();
	}
}