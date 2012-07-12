package com.settinghead.tyful.client.model.vo.template
{
	import com.settinghead.tyful.client.density.Patch;
	
	import flash.geom.Point;

	public class PlaceInfo {
		private var _patch:Patch;
		
		public var x:int;
		public var y:int;
		
		public function PlaceInfo(x:int, y:int, p:Patch = null) {
			this.x = x;
			this.y = y;
			this.patch = p;
		}
		
		
		public function set patch(p:Patch):void{
			this._patch = p;
		}
		
		public function get patch():Patch{
			return this._patch;
		}

		
		public function distanceFrom(p:PlaceInfo):Number{
			return Math.sqrt(
				Math.pow(p.x - this.x, 2) +
				Math.pow(p.y - this.y, 2));
		}
		
		public function clone():PlaceInfo{
			return new PlaceInfo(x,y,_patch);
		}
		
		public function add(addum:PlaceInfo):PlaceInfo{
			var p:PlaceInfo = this.clone();
			p.x += addum.x;
			p.y += addum.y;
			return p;
		}
	}

}