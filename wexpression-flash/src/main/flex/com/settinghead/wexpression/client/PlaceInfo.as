package com.settinghead.wexpression.client
{
	import com.settinghead.wexpression.client.density.Patch;
	
	import flash.geom.Point;

	public class PlaceInfo {
		private var pVector:Point;
		private var _patch:Patch;
		
		public function PlaceInfo(pVector:Point, p:Patch = null) {
			this.setpVector(pVector);
			this.patch = p;
		}
		
		
		private function setpVector(pVector:Point):void {
			this.pVector = pVector;
		}
		
		public function getpVector():Point {
			return pVector;
		}
		
		public function set patch(p:Patch):void{
			this._patch = p;
		}
		
		public function get patch():Patch{
			return this._patch;
		}
		
		public function get():PlaceInfo {
			return new PlaceInfo(this.getpVector().clone(), this.patch);
		}
		
		public function distanceFrom(p:PlaceInfo):Number{
			return Math.sqrt(
				Math.pow(p.getpVector().x - this.getpVector().x, 2) +
				Math.pow(p.getpVector().y - this.getpVector().y, 2));
		}
	}

}