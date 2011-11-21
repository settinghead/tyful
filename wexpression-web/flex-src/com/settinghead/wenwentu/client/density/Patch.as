package com.settinghead.wenwentu.client.density
{
	import com.settinghead.wenwentu.client.TemplateImage;
	import org.as3commons.collections.Set;

	public class Patch  {
		
		
		private var x:int;
		private var y:int;
		private var width:int;
		private var height:int;
		private var _averageAlpha:Number= -1;
		private var parent:Patch;
		private var children:Vector.<Patch> = null;
		private var _childrenMarker:Set;
		private var _area:int= -1;
		private var _alphaSum:Number= -1;
		private var _queue:PatchQueue;
		private var rank:int;
		
		
		public function Patch(x:int, y:int, width:int, height:int, rank:int,
							  parent:Patch, queue:PatchQueue) {
			
			this.setX(x);
			this.setY(y);
			this.setWidth(width);
			this.setHeight(height);
			this.setParent(parent);
			this.rank = rank;
			this._queue = queue;
			
		}
		
		public function setX(x:int):void {
			this.x = x;
		}
		
		public function getX():int {
			return this.x;
		}
		
		public function setY(y:int):void {
			this.y = y;
		}
		
		public function getY():int {
			return this.y;
		}
		
		public function getImg():TemplateImage {
			return this._queue.getMap().getIndex().getImg();
		}
		
		private function setWidth(width:int):void {
			this.width = width;
		}
		
		public function getWidth():int {
			return width;
		}
		
		public function getAverageAlpha():Number {
			
			if (this._averageAlpha < 0) {
				
				// now remove sub-patches that's already marked
				this._averageAlpha = this.getAlphaSum();
				for each (var markedChild:Patch in this.getMarkedChildren()) {
					this._averageAlpha -= markedChild.getAverageAlpha()
						* DensityPatchIndex.MARK_FILL_FACTOR;
				}
				
				this._averageAlpha /= this.getArea();
				
			}
			return this._averageAlpha;
		}
		
		private function getAlphaSum():Number {
			if (this._alphaSum < 0)
				// lazy calc
			{
				this._alphaSum = 0;
				
				if (this.getChildren() == null
					|| this.getChildren().length == 0) {
					for (var i:int= 0; i < this.getWidth(); i++)
						for (var j:int= 0; j < this.getHeight(); j++) {
							this._alphaSum += _queue.getMap().getIndex().getImg().getBrightness(
								this.getX() + i, this.getY() + j);
						}
				} else
					for each (var p:Patch in this.getChildren())
						this._alphaSum += p.getAlphaSum();
			}
			
			return this._alphaSum;
		}
		
		private function getMarkedChildren(): Set {
			if (this._childrenMarker == null)
				this._childrenMarker = new Set();
			return this._childrenMarker;
		}
		
		
		public function getRank():int {
			return this.rank;
		}
		
		private function setHeight(height:int):void {
			this.height = height;
		}
		
		public function getHeight():int {
			return this.height;
		}
		
		private function setParent(parent:Patch):void {
			this.parent = parent;
		}
		
		public function getParent():Patch {
			return this.parent;
		}
		
		private function setChildren(children:Vector.<Patch>):void {
			this.children = children;
		}
		
		public function getChildren():Vector.<Patch>  {
			return this.children;
		}
		
		public function divideIntoNineOrMore() :Vector.<Patch>{
			var result:Vector.<Patch> = new Vector.<Patch>();
			var min:int= getWidth() < getHeight() ? getWidth()
				: getHeight();
			var squareLength:int= min / DensityPatchIndex.NUMBER_OF_DIVISIONS;
			var centerCount:int= (DensityPatchIndex.NUMBER_OF_DIVISIONS + 1) / 2;
			var breakI:Boolean= false;
			for (var i:int= 0; i < getWidth(); i += squareLength) {
				var squareWidth:int;
				if (i + squareLength * 2> getWidth()) {
					squareWidth = getWidth() - i;
					// i = getWidth();
					breakI = true;
				} else
					squareWidth = squareLength;
				var breakJ:Boolean= false;
				
				for (var j:int= 0; j < getHeight(); j += squareLength) {
					var squareHeight:int;
					if (j + squareLength * 2> getHeight()) {
						squareHeight = getHeight() - j;
						// j = getHeight();
						breakJ = true;
					} else
						squareHeight = squareLength;
					
					// the closer to the center, the higher the rank
					var p:Patch= new Patch(getX() + i, getY() + j,
						squareWidth, squareHeight, 0, this, this._queue);
					result.push(p);
					if (breakJ)
						break;
				}
				if (breakI)
					break;
			}
			
			setChildren(result);
			return result;
		}
		
		
		
		public function mark(smearedArea:int):void {
			this.resetWorthCalculations();
			this.getAlphaSum();
			if (this.getChildren() == null
				|| this.getChildren().length == 0)
				this._alphaSum -= smearedArea * DensityPatchIndex.MARK_FILL_FACTOR;
			
			if (getParent() != null)
				getParent().markChild(this);
			
		}
		
		public function unmarkForParent():void {
			if (getParent() != null)
				getParent().unmarkChild(this);
		}
		
		private function markChild(patch:Patch):void {
			this.getMarkedChildren().add(patch);
			this.resetWorthCalculations();
			// re-sort
			this.reRank();
			// // cascading mark parents
			// if (this.getParent() != null)
			// this.getParent().markChild(this);
		}
		
		private function unmarkChild(patch:Patch):void {
			if (this.getMarkedChildren().remove(patch)) {
				this.resetWorthCalculations();
				// re-sort
				this.reRank();
				// cascading mark parents
				// if (this.getParent() != null)
				// this.getParent().markChild(this);
				// this.unmarkForParent();
			}
		}
		
		private function resetWorthCalculations():void {
			this._area = -1;
			this._averageAlpha = -1;
			
		}
		
		/**
		 * @return the area
		 */
		public function getArea():int {
			if (this._area < 0)
				this._area = getWidth() * getHeight();
			return this._area;
		}
		
		public function reRank():void {
			_queue.remove(this);
			_queue.tryAdd(this);
			if (getParent() != null) {
				getParent().resetWorthCalculations();
				getParent().reRank();
			}
		}
		
		public function getLevel():int {
			return _queue.getMyLevel();
		}

	}
}