package com.settinghead.wenwentu.client.model.vo
{

	public class BBPolarRootTreeVO extends BBPolarTreeVO {
		private var rootX:int;
		private var rootY:int;
		private var _rotation:Number= 0;
		protected var rootStamp:Number;
		private var shape:IImageShape;
		var _minBoxSize:int;
		
		public function BBPolarRootTreeVO(shape:IImageShape, centerX:int, centerY:int,
										d:Number, minBoxSize:int) {
			super(0, TWO_PI, 0, d, minBoxSize);
			this.rootX = centerX;
			this.rootY = centerY;
			this.shape = shape;
			this._minBoxSize = minBoxSize;
			this.rootStamp = (new Date()).time;
		}
		
		function setLocation(centerX:int, centerY:int):void {
			this.rootX = centerX;
			this.rootY = centerY;
			this.rootStamp = (new Date()).time;
		}
		
		
		public override function getRootX():int {
			return rootX;
		}
		
		
		public override function getRootY():int {
			return rootY;
		}
		
		
		override function computeX(rotate:Boolean):Number {
			return -super.d2;
		}
		
		
		override  function computeY(rotate:Boolean):Number {
			return -super.d2;
		}
		
		
		override function computeRight(rotate:Boolean):Number {
			return (super.d2);
		}
		
		
		override function computeBottom(rotate:Boolean):Number {
			return (super.d2);
		}
		
		public function setRotation(rotation:Number):void {
			this._rotation = rotation % BBPolarTreeVO.TWO_PI;
			if(this._rotation<0)
				this._rotation = BBPolarTreeVO.TWO_PI + this._rotation;
			this.rootStamp = (new Date()).time;
		}
		
		
		override public function getRotation():Number {
			return this._rotation;
		}
		
		
		override function getCurrentStamp():Number {
			return this.rootStamp;
		}
		
		
		public override function getRoot():BBPolarRootTreeVO {
			return this;
		}
		
		
		override function getMinBoxSize():int {
			return this._minBoxSize;
		}
		
		
		override function getShape():IImageShape {
			return this.shape;
		}
		
	}

}