package com.settinghead.wexpression.client.nudger {
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.math.MathUtils;
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.wordlist.WordVO;
	
	import flash.geom.Point;
	
	import mx.controls.Alert;

	public class ShapeConfinePowerWordNudger implements WordNudger {
	
		// Who knows? this seems to be good, but it seems to depend on the font --
		// bigger fonts need a bigger thetaIncrement.
	//	private var thetaIncrement:Number= Math.PI * 0.03;
		private var angler:WordAngler;
	
		public function ShapeConfinedPowerWordNudger() {
		}
		
		private var retPoint:Point = new Point(0,0);
		public function nudgeFor(w:WordVO, pInfo:PlaceInfo, attempt:int, totalPlannedAttempt:int):Point {
			var factor:int;
				attempt = ( attempt + pInfo.patch.lastAttempt + totalPlannedAttempt / 2) % totalPlannedAttempt;
				var p:Patch= Patch(pInfo.patch);
				
				var rank:Number = Math.floor(Math.log(attempt*3+1)/Math.log(2)-2);
				var seqInRank:int = attempt - Math.pow(2,rank-1);
				
				var unitDistance:Number = Math.sqrt(p.getWidth() * p.getHeight()/totalPlannedAttempt);
//				Alert.show(unitDistance.toString());
				var x:Number = ((attempt / (pInfo.patch.getHeight() / unitDistance)) * unitDistance - p.getWidth() / 2);
				var y:Number = ((attempt % (pInfo.patch.getHeight() / unitDistance)) * unitDistance - p.getHeight() / 2);
				x *= 1.5;
				y *= 1.5;
				if(attempt % 2==0)
				{
					x = p.getWidth() - x;
					y = p.getHeight() - y;
				}
				
			retPoint.x = x;
			retPoint.y = y;
			return retPoint;
		}
	}
}