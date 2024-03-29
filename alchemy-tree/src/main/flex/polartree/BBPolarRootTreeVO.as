package polartree
{

	public class BBPolarRootTreeVO extends BBPolarTreeVO {
		private var rootX:int;
		private var rootY:int;
		private var _rotation:Number= 0;
		protected var rootStamp:int = 0;
		private var shape:IImageShape;
		private var _minBoxSize:int;
		
		public function BBPolarRootTreeVO(shape:IImageShape, centerX:int, centerY:int,
										d:Number, minBoxSize:int) {
			super(0, TWO_PI, 0, d, minBoxSize);
			this.rootX = centerX;
			this.rootY = centerY;
			this.shape = shape;
			this._minBoxSize = minBoxSize;
			this.rootStamp++;
		}
		
		public function setLocation(centerX:int, centerY:int):void {
			this.rootX = centerX;
			this.rootY = centerY;
			this.rootStamp++;
		}
		
		
		public override function getRootX():int {
			return rootX;
		}
		
		
		public override function getRootY():int {
			return rootY;
		}
		
		
		protected override function computeX(rotate:Boolean):Number {
//			if(shape.width<STOP_COMPUTE_TREE_THRESHOLD)
//				return -shape.width/2;
//			else 
				return -super.d2;
		}
		
		
		protected override  function computeY(rotate:Boolean):Number {
//			if(shape.height<STOP_COMPUTE_TREE_THRESHOLD)
//				return -shape.height/2;
//			else 
				return -super.d2;
		}
		
		
		protected override function computeRight(rotate:Boolean):Number {
//			if(shape.width<STOP_COMPUTE_TREE_THRESHOLD)
//				return shape.width/2;
//			else 
				return (super.d2);
		}
		
		
		protected override function computeBottom(rotate:Boolean):Number {
	//			if(shape.height<STOP_COMPUTE_TREE_THRESHOLD)
	//				return -shape.height/2;
	//			else 
				return (super.d2);
		}
		
		public function setRotation(rotation:Number):void {
			this._rotation = rotation % BBPolarTreeVO.TWO_PI;
			if(this._rotation<0)
				this._rotation = BBPolarTreeVO.TWO_PI + this._rotation;
			this.rootStamp++;
		}
		
		
		override public function getRotation():Number {
			return this._rotation;
		}
		
		
		public override function getCurrentStamp():Number {
			return this.rootStamp;
		}
		
		
		public override function getRoot():BBPolarRootTreeVO {
			return this;
		}
		
		
		public override function getMinBoxSize():int {
			return this._minBoxSize;
		}
		
		
		public override function getShape():IImageShape {
			return this.shape;
		}
		
//		public override function overlaps(otherTree:BBPolarTreeVO):Boolean {
//			var min:Number = 30;
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

}