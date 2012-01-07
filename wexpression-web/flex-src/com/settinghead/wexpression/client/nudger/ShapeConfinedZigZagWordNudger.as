package com.settinghead.wexpression.client.nudger {
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.math.MathUtils;
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	
	import flash.geom.Point;
	
	import org.as3commons.logging.util.xml.xmlNs;

/*
 Copyright 2010 Daniel Bernier

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

public class ShapeConfinedZigZagWordNudger implements WordNudger {

	// Who knows? this seems to be good, but it seems to depend on the font --
	// bigger fonts need a bigger thetaIncrement.
//	private var thetaIncrement:Number= Math.PI * 0.03;
	private var angler:WordAngler;

	public function ShapeConfinedZigZagWordNudger() {
	}

	public function nudgeFor(w:WordVO, pInfo:PlaceInfo, attempt:int, totalPlannedAttempt:int):Point {
		var factor:int;
			attempt = ( attempt + pInfo.patch.lastAttempt ) % totalPlannedAttempt;
//		if (pInfo != null && pInfo.get().patch != null) {
			var p:Patch= Patch(pInfo.get().patch);
			var unitDistance:Number = Math.sqrt(p.getWidth() * p.getHeight()/totalPlannedAttempt);
			var x:Number = ((attempt / (pInfo.patch.getHeight() / unitDistance)) * unitDistance - p.getWidth() / 2) * 1.2;
			var y:Number = ((attempt % (pInfo.patch.getHeight() / unitDistance)) * unitDistance - p.getHeight() / 2) * 1.2;
			
		return new Point(x, y);
	}

	private function powerMap(power:Number, v:Number, min1:Number, max1:Number,
			min2:Number, max2:Number):Number {
		var val:Number= MathUtils.norm(v, min1, max1);
		val = Math.pow(val, power);
		return MathUtils.lerp(min2, max2, val);
	}
}
}