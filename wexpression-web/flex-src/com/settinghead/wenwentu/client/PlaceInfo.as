package com.settinghead.wenwentu.client
{
	import flash.geom.Point;

	public class PlaceInfo {
		private var pVector:Point;
		private var returnedObj:Object;
		
		public function PlaceInfo(pVector:Point, returnedObj:Object = null) {
			this.setpVector(pVector);
			this.setReturnedObj(returnedObj);
		}
		
		
		private function setpVector(pVector:Point):void {
			this.pVector = pVector;
		}
		
		public function getpVector():Point {
			return pVector;
		}
		
		private function setReturnedObj(returnedObj:Object):void {
			this.returnedObj = returnedObj;
		}
		
		public function getReturnedObj():Object {
			return returnedObj;
		}
		
		public function get():PlaceInfo {
			return new PlaceInfo(this.getpVector().clone(), this.getReturnedObj());
		}
	}

}