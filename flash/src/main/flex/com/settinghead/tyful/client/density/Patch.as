package com.settinghead.tyful.client.density
{
	import com.settinghead.tyful.client.model.vo.EngineWordVO;
	import com.settinghead.tyful.client.model.vo.template.Layer;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.template.WordLayer;
	
	import org.as3commons.collections.Set;

	public class Patch  {
		
		
		private var x:int;
		private var y:int;
		private var width:int;
		private var height:int;
		private var _averageAlpha:Number= Number.NaN;
		private var parent:Patch;
		private var children:Vector.<Patch> = null;
		private var _childrenMarker:Set;
		private var _area:Number= Number.NaN;
		private var _alphaSum:Number= Number.NaN;
		private var _queue:PatchQueue;
		private var rank:int;
		private var _numOfFailures:int;
		private var _lastAttempt:int = 0;
		private var _eWords:Vector.<EngineWordVO> = null;
		private var _layer:WordLayer;
		
		public function Patch(x:int, y:int, width:int, height:int, rank:int,
							  parent:Patch, queue:PatchQueue, layer:WordLayer) {
			this.setX(x);
			this.setY(y);
			this.setWidth(width);
			this.setHeight(height);
			this.setParent(parent);
			this.rank = rank;
			this._queue = queue;
			this._layer = layer;
			
		}
		
		public function get layer():WordLayer{
			return this._layer;
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
		
		public function getImg():TemplateVO {
			return this._queue.getMap().getIndex().template;
		}
		
		private function setWidth(width:int):void {
			this.width = width;
		}
		
		public function getWidth():int {
			return width;
		}
		
		public function getAverageAlpha():Number {
			
			if (isNaN(this._averageAlpha)) {
				// now remove sub-patches that's already marked
				this._averageAlpha = this.getAlphaSum();
//				for each (var markedChild:Patch in this.getMarkedChildren()) {
//					this._averageAlpha -= markedChild.getAverageAlpha()
//						* DensityPatchIndex.MARK_FILL_FACTOR;
//				}
//				
				this._averageAlpha /= this.getArea();
				
			}
			return this._averageAlpha;
		}
		
		public function getAlphaSum():Number {
			if (isNaN(this._alphaSum))
				// lazy calc
			{
//				this._alphaSum = 0;
//				this.getArea();
//
//				if (this.getChildren() == null
//					|| this.getChildren().length == 0) {
//					for (var i:int= 0; i < this.getWidth(); i++)
//						for (var j:int= 0; j < this.getHeight(); j++) {
//							var brightness:Number = _layer.getBrightness(
//								this.getX() + i, this.getY() + j);
//							if(isNaN(brightness)){
//								brightness = 0;
//							}
//							else 
//								brightness = brightness;
//							this._alphaSum += brightness;
//							if(brightness==0)
//								this._area -= 1;
//						}
//				} else
//					for each (var p:Patch in this.getChildren())
//						this._alphaSum += p.getAlphaSum();
				this._alphaSum = 1;
			}
			
			if(this._alphaSum==0) 
				this._alphaSum= Number.NEGATIVE_INFINITY;
			
			return this._alphaSum;
		}
		
//		private function getMarkedChildren(): Set {
//			if (this._childrenMarker == null)
//				this._childrenMarker = new Set();
//			return this._childrenMarker;
//		}
		
		
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
		
		public function divideIntoNineOrMore(newQueue:PatchQueue) :Vector.<Patch>{
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
						squareWidth, squareHeight, 0, this, newQueue, this._layer);
					result.push(p);
					if (breakJ)
						break;
				}
				if (breakI)
					break;
			}
			
			setChildren(result);
//			trace("Patches", this.getLevel() + 1, result.length);  
			return result;
		}
		
		
		
		public function mark(smearedArea:int, spreadSmearToChildren:Boolean):void {
//			this.resetWorthCalculations();
//			this.getAlphaSum();
			this._alphaSum -= smearedArea * DensityPatchIndex.MARK_FILL_FACTOR;
			if(spreadSmearToChildren)
				for each (var child:Patch in this.getChildren()) {
				child.mark(smearedArea * DensityPatchIndex.MARK_FILL_FACTOR/this.getChildren().length, true);
//				child._alphaSum -= smearedArea * DensityPatchIndex.MARK_FILL_FACTOR/this.getChildren().length;
//				child._queue.remove(child);
//				child._queue.tryAdd(child);
			}
//			if (getParent() != null)
//				getParent().markChild(this);
			if (getParent() != null){
				parent.mark(smearedArea, false);
//				parent._queue.remove(parent);
//				parent._queue.tryAdd(parent);
			}
		}

		
//		public function unmarkForParent():void {
//			if (getParent() != null)
//				getParent().unmarkChild(this);
//		}
//		
//		private function markChild(patch:Patch):void {
//			this.getMarkedChildren().add(patch);
//			this.resetWorthCalculations();
//			// re-sort
//			this.reRank();
//			// // cascading mark parents
//			// if (this.getParent() != null)
//			// this.getParent().markChild(this);
//		}
//		
//		private function unmarkChild(patch:Patch):void {
//			if (this.getMarkedChildren().remove(patch)) {
//				this.resetWorthCalculations();
//				// re-sort
//				this.reRank();
//				// cascading mark parents
//				// if (this.getParent() != null)
//				// this.getParent().markChild(this);
//				// this.unmarkForParent();
//			}
//		}
		
//		private function resetWorthCalculations():void {
//			this._area = NaN;
//			this._averageAlpha = NaN;
//		}
		
		/**
		 * @return the area
		 */
		public function getArea():Number {
			if (isNaN(this._area))
				this._area = getWidth() * getHeight();
			return this._area;
		}
		
	
		
		public function getLevel():int {
			return _queue.getMyLevel();
		}
		
		public function fail():void{
			_numOfFailures ++; 
		}
		
		public function get numberOfFailures():int{
			return _numOfFailures;
		}
		
		public function get lastAttempt():int{
			return _lastAttempt;
		}
		
		public function set lastAttempt(n:int):void{
			_lastAttempt = n;
		}
		
		public function get eWords():Vector.<EngineWordVO>{
			if(this._eWords==null)
				this._eWords = new Vector.<EngineWordVO>();
			return this._eWords;
		}
		
		private var _neighborsAndMe:Set = null;
		public function get neighborsAndMe():Set{
			if(this._neighborsAndMe ==null){
				this._neighborsAndMe = new Set();
				var min:Number = this.width < this.height ? this.width:this.height;
				var leftX:Number = this.x - min, rightX: Number = this.x + min, 
					topY:Number = this.y - min, bottomY: Number = this.y + min;
				var p:Patch;
				p = this._queue.patchAtCoordinate(leftX, topY);
				if(p!=null) _neighborsAndMe.add(p);	
				p = this._queue.patchAtCoordinate(leftX, this.y);
				if(p!=null) _neighborsAndMe.add(p);	
				p = this._queue.patchAtCoordinate(leftX, bottomY);
				if(p!=null) _neighborsAndMe.add(p);	
				p = this._queue.patchAtCoordinate(this.x, topY);
				if(p!=null) _neighborsAndMe.add(p);	
				p = this._queue.patchAtCoordinate(this.x, this.y);
				if(p!=null) _neighborsAndMe.add(p);	
				p = this._queue.patchAtCoordinate(this.x, bottomY);
				if(p!=null) _neighborsAndMe.add(p);	
				p = this._queue.patchAtCoordinate(rightX, topY);
				if(p!=null) _neighborsAndMe.add(p);	
				p = this._queue.patchAtCoordinate(rightX, this.y);
				if(p!=null) _neighborsAndMe.add(p);	
				p = this._queue.patchAtCoordinate(rightX, bottomY);
				if(p!=null) _neighborsAndMe.add(p);	
			}
			return this._neighborsAndMe;
		}
		
		public function ancestorsAndOffsprngs():Vector.<Patch>{
			var result:Vector.<Patch> = new Vector.<Patch>();
			ancestors(result);
			offsprings(result);
			return result;
		}
		
		private function ancestors(collector:Vector.<Patch>):void{
			if(this.parent!=null){
				collector.push(parent);
				parent.ancestors(collector);
			}
				
		}
		
		private function offsprings(collector:Vector.<Patch>):void{
			for each (var p:Patch in this.children){
				collector.push(p);
				p.offsprings(collector);
			}
		}
	}
}