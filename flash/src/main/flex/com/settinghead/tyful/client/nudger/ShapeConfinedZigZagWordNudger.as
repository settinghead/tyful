package com.settinghead.tyful.client.nudger {
	import com.settinghead.tyful.client.angler.WordAngler;
	import com.settinghead.tyful.client.density.Patch;
	import com.settinghead.tyful.client.math.MathUtils;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.geom.Point;
	
	import mx.controls.Alert;

	public class ShapeConfinedZigZagWordNudger implements WordNudger {
	
		// Who knows? this seems to be good, but it seems to depend on the font --
		// bigger fonts need a bigger thetaIncrement.
	//	private var thetaIncrement:Number= Math.PI * 0.03;
		private var angler:WordAngler;
	
		public function ShapeConfinedZigZagWordNudger() {
		}
		
		private var retPoint:PlaceInfo = new PlaceInfo(0,0);
		public function nudgeFor(w:WordVO, pInfo:PlaceInfo, attempt:int, totalPlannedAttempt:int):PlaceInfo {
			var factor:int;
				attempt = ( attempt + pInfo.patch.lastAttempt + totalPlannedAttempt / 2) % totalPlannedAttempt;
				var p:Patch= Patch(pInfo.patch);
				var unitDistance:Number = Math.sqrt(p.getWidth() * p.getHeight()/totalPlannedAttempt);
//				Alert.show(unitDistance.toString());
				var x:Number = ((attempt / (pInfo.patch.getHeight() / unitDistance)) * unitDistance - p.getWidth() / 2);
				var y:Number = ((attempt % (pInfo.patch.getHeight() / unitDistance)) * unitDistance - p.getHeight() / 2);
				x *= 1.5;
				y *= 1.5;
				if(attempt % 2==0)
				{
					y = p.getHeight() - y;
				}
				if(attempt/2%2==0){
					x = p.getWidth() - x;

				}
				
			retPoint.x = x;
			retPoint.y = y;
			retPoint.patch = pInfo.patch;
			return retPoint;
		}
	}
}