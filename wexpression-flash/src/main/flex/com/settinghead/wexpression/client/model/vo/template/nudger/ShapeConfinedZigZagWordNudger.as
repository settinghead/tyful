package com.settinghead.wexpression.client.model.vo.template.nudger {
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.math.MathUtils;
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	import com.settinghead.wexpression.client.model.vo.template.WordNudger;
	
	import flash.geom.Point;
	
	import mx.controls.Alert;
	
	import org.as3commons.logging.util.xml.xmlNs;


	public class ShapeConfinedZigZagWordNudger extends WordNudger {
	
		// Who knows? this seems to be good, but it seems to depend on the font --
		// bigger fonts need a bigger thetaIncrement.
	//	private var thetaIncrement:Number= Math.PI * 0.03;
	
		public function ShapeConfinedZigZagWordNudger() {
		}
	
		public override function nudgeFor(w:WordVO, pInfo:PlaceInfo, attempt:int, totalPlannedAttempt:int):Point {
			var factor:int;
				attempt = ( attempt + pInfo.patch.lastAttempt + totalPlannedAttempt / 2) % totalPlannedAttempt;
				var p:Patch= Patch(pInfo.get().patch);
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
				
			return new Point(x, y);
		}
	}
}