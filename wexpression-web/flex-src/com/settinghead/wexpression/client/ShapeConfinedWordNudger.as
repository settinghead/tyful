package com.settinghead.wexpression.client {
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.math.MathUtils;
	
	import flash.geom.Point;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.nudger.WordNudger;

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

public class ShapeConfinedWordNudger implements WordNudger {

	// Who knows? this seems to be good, but it seems to depend on the font --
	// bigger fonts need a bigger thetaIncrement.
	private var thetaIncrement:Number= Math.PI * 0.03;
	private var angler:WordAngler;

	public function ShapeConfinedWordNudger() {
	}

	public function nudgeFor(w:Word, pInfo:PlaceInfo, attempt:int):Point {
		var factor:int;
		if (pInfo != null && pInfo.get().getReturnedObj() != null) {
			var p:Patch= Patch(pInfo.get().getReturnedObj());
			factor = p.getWidth() > p.getHeight() ? p.getWidth() : p
					.getHeight();
			if (p.getLevel() == 0)
				factor /= 6;
			else if (p.getLevel() == 1)
				factor /= 2;
		} else
			factor = 30;

		factor *= 6;
		
		var rad:Number= powerMap(0.6, attempt, 0, 600, 1, factor * 6);

		thetaIncrement = powerMap(1, attempt, 0, 600, 0.5, 0.3);
		var theta:Number= thetaIncrement * attempt;
		var x:Number= Math.cos(theta) * rad;
		var y:Number= Math.sin(theta) * rad;
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