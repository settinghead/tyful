package com.settinghead.tyful.client.model.vo.template
{
	public class PlaceInfo {
		private var _layer:int;
		
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		
		public function PlaceInfo(x:Number, y:Number, rotation:Number, lNum:int) {
			this.x = x;
			this.y = y;
			this.rotation = rotation;
			this.layer = lNum;
		}
		
		
		public function set layer(l:int):void{
			this._layer = l;
		}
		
		public function get layer():int{
			return this._layer;
		}

		
		public function distanceFrom(p:PlaceInfo):Number{
			return Math.sqrt(
				Math.pow(p.x - this.x, 2) +
				Math.pow(p.y - this.y, 2));
		}
		
		public function clone():PlaceInfo{
			return new PlaceInfo(x,y,rotation,_layer);
		}
		
		public function add(addum:PlaceInfo):PlaceInfo{
			var p:PlaceInfo = this.clone();
			p.x += addum.x;
			p.y += addum.y;
			return p;
		}
	}

}