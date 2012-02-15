package com.settinghead.wexpression.client.model.vo
{
	
		public class BBPolarChildTreeVO extends BBPolarTreeVO {
			
			private var root:BBPolarRootTreeVO;
			
			public function BBPolarChildTreeVO(r1:Number, r2:Number,
												  d1:Number, d2:Number, 
											 root:BBPolarRootTreeVO) {
					super(r1, r2, d1, d2);
					this.root = root;
				}
			
			
			public override function getRootX():int {
				return root.getRootX();
			}
			
			
			public override function getRootY():int {
				return root.getRootY();
			}
			
			
			protected override function computeX(rotate:Boolean):Number {
				var x:Number;
				if (getR1(rotate) < HALF_PI) {
					if (getR2(rotate) < getR1(rotate)) {
						x = d2 * Math.cos(PI);
					} else if (getR2(rotate) < HALF_PI) {
						x = d1 * Math.cos(getR2(rotate));
					} else if (getR2(rotate) < PI) {
						x = d2 * Math.cos(getR2(rotate));
					} else {
						// circle
						x = d2 * Math.cos(PI);
					}
				} else if (getR1(rotate) < PI) {
					if (getR2(rotate) < HALF_PI) {
						x = d2 * Math.cos(PI);
					} else if (getR2(rotate) < PI) {
						x = d2 * Math.cos(getR2(rotate));
					} else if (getR2(rotate) < ONE_AND_HALF_PI) {
						x = d2 * Math.cos(PI);
					} else {
						x = d2 * Math.cos(PI);
					}
				} else if (getR1(rotate) < ONE_AND_HALF_PI) {
					if (getR2(rotate) < HALF_PI) {
						x = d2 * Math.cos(getR1(rotate));
					} else if (getR2(rotate) < getR1(rotate)) {
						var x1:Number= d2 * Math.cos(getR1(rotate));
						var x2:Number= d2 * Math.cos(getR2(rotate));
						x = x1 < x2 ? x1 : x2;
					} else if (getR2(rotate) < ONE_AND_HALF_PI) {
						x = d2 * Math.cos(getR1(rotate));
					} else {
						x = d2 * Math.cos(getR1(rotate));
					}
				} else {
					if (getR2(rotate) < HALF_PI) {
						var x1:Number= d1 * Math.cos(getR1(rotate));
						var x2:Number= d1 * Math.cos(getR2(rotate));
						x = x1 < x2 ? x1 : x2;
					} else if (getR2(rotate) < PI) {
						x = d2 * Math.cos(getR2(rotate));
					} else if (getR2(rotate) < getR1(rotate)) {
						x = d2 * Math.cos(PI);
					} else
						x = d1 * Math.cos(getR1(rotate));
				}
				return x;
			}
			
			
			protected override function computeY(rotate:Boolean):Number {
				var y:Number;
				if (getR1(rotate) < HALF_PI) {
					if (getR2(rotate) < getR1(rotate)) {
						y = d1 * Math.sin(HALF_PI);
					} else if (getR2(rotate) < HALF_PI) {
						y = d2 * Math.sin(getR2(rotate));
					} else if (getR2(rotate) < PI) {
						y = d2 * Math.sin(HALF_PI);
					} else {
						// circle
						y = d2 * Math.sin(HALF_PI);
					}
				} else if (getR1(rotate) < PI) {
					if (getR2(rotate) < HALF_PI) {
						var y1:Number= d2 * Math.sin(getR1(rotate));
						var y2:Number= d2 * Math.sin(getR2(rotate));
						y = y1 > y2 ? y1 : y2;
					} else if (getR2(rotate) < getR1(rotate))
						y = d2 * Math.sin(HALF_PI);
					else
						y = d2 * Math.sin(getR1(rotate));
				} else if (getR1(rotate) < ONE_AND_HALF_PI) {
					if (getR2(rotate) < PI) {
						y = d2 * Math.sin(HALF_PI);
					} else if (getR2(rotate) < getR1(rotate)) {
						y = d1 * Math.sin(getR2(rotate));
					} else if (getR2(rotate) < ONE_AND_HALF_PI) {
						y = d1 * Math.sin(getR1(rotate));
					} else {
						var val1:Number= d1 * Math.sin(getR2(rotate));
						var val2:Number= d1 * Math.sin(getR1(rotate));
						y = val1 > val2 ? val1 : val2;
					}
					
				} else {
					if (getR2(rotate) < HALF_PI) {
						y = d2 * Math.sin(getR2(rotate));
					} else if (getR2(rotate) < getR1(rotate)) {
						y = d2 * Math.sin(HALF_PI);
					} else
						y = d1 * Math.sin(getR2(rotate));
				}
				y = -y;
				return y;
			}
			
			
			protected override function computeRight(rotate:Boolean):Number {
				var right:Number;
				if (getR1(rotate) < HALF_PI) {
					if (getR2(rotate) < getR1(rotate)) {
						right = d2 * Math.cos(0);
					} else if (getR2(rotate) < HALF_PI) {
						right = d2 * Math.cos(getR1(rotate));
					} else if (getR2(rotate) < PI) {
						right = d2 * Math.cos(getR1(rotate));
					} else {
						// circle
						right = d2 * Math.cos(0);
					}
				} else if (getR1(rotate) < PI) {
					if (getR2(rotate) < getR1(rotate)) {
						right = d2 * Math.cos(0);
					} else if (getR2(rotate) < PI) {
						right = d1 * Math.cos(getR1(rotate));
					} else if (getR2(rotate) < ONE_AND_HALF_PI) {
						var val1:Number= d1 * Math.cos(getR1(rotate));
						;
						var val2:Number= d1 * Math.cos(getR2(rotate));
						;
						right = val1 > val2 ? val1 : val2;
					} else {
						right = d2 * Math.cos(getR2(rotate));
					}
				} else if (getR1(rotate) < ONE_AND_HALF_PI) {
					if (getR2(rotate) < getR1(rotate)) {
						right = d2 * Math.cos(0);
					} else if (getR2(rotate) < ONE_AND_HALF_PI) {
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
			
			
			protected override function computeBottom(rotate:Boolean):Number {
				var bottom:Number;
				if (getR1(rotate) < HALF_PI) {
					if (getR2(rotate) < getR1(rotate)) {
						bottom = d1 * Math.sin(ONE_AND_HALF_PI);
					} else if (getR2(rotate) < HALF_PI) {
						bottom = d1 * Math.sin(getR1(rotate));
					} else if (getR2(rotate) < PI) {
						var val1:Number= d1 * Math.sin(getR1(rotate));
						var val2:Number= d1 * Math.sin(getR2(rotate));
						bottom = val1 < val2 ? val1 : val2;
					} else {
						// circle
						bottom = d2 * Math.sin(ONE_AND_HALF_PI);
					}
				} else if (getR1(rotate) < PI) {
					if (getR2(rotate) < getR1(rotate)) {
						bottom = d1 * Math.sin(ONE_AND_HALF_PI);
					} else if (getR2(rotate) < PI) {
						bottom = d1 * Math.sin(getR2(rotate));
					} else if (getR2(rotate) < ONE_AND_HALF_PI) {
						bottom = d2 * Math.sin(getR2(rotate));
					} else {
						bottom = d2 * Math.sin(ONE_AND_HALF_PI);
					}
				} else if (getR1(rotate) < ONE_AND_HALF_PI) {
					if (getR2(rotate) < getR1(rotate)) {
						bottom = d2 * Math.sin(ONE_AND_HALF_PI);
					} else if (getR2(rotate) < ONE_AND_HALF_PI) {
						bottom = d2 * Math.sin(getR2(rotate));
					} else {
						bottom = d2 * Math.sin(ONE_AND_HALF_PI);
					}
					
				} else {
					if (getR2(rotate) < PI) {
						bottom = d2 * Math.sin(getR1(rotate));
					} else if (getR2(rotate) < ONE_AND_HALF_PI) {
						var b1:Number= d2 * Math.sin(getR1(rotate));
						var b2:Number= d2 * Math.sin(getR2(rotate));
						bottom = b1 < b2 ? b1 : b2;
					} else if (getR2(rotate) < getR1(rotate)) {
						bottom = Math.cos(ONE_AND_HALF_PI);
					} else
						bottom = d2 * Math.sin(getR1(rotate));
				}
				bottom = -bottom;
				return bottom;
			}
			
			
			override public function getRotation():Number {
				return root.getRotation();
			}
			
			
			public override function getCurrentStamp():Number {
				return root.getCurrentStamp();
			}
			
			public override function getRoot():BBPolarRootTreeVO {
				return root;
			}
			
			public override function getShape():IImageShape {
				return root.getShape();
			}
		}
}