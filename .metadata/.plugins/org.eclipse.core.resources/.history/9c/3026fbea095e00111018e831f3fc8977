package com.settinghead.wexpression.client.nudger {
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.math.MathUtils;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	
	import de.polygonal.utils.PM_PRNG;
	
	import flash.geom.Point;

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

public class ShapeConfinedRandomWordNudger implements WordNudger {

	// Who knows? this seems to be good, but it seems to depend on the font --
	// bigger fonts need a bigger thetaIncrement.
//	private var thetaIncrement:Number= Math.PI * 0.03;
	private var angler:WordAngler;
	private var prng:PM_PRNG = new PM_PRNG();
	
	public function ShapeConfinedRandomWordNudger() {
		
	}

	public function nudgeFor(w:WordVO, pInfo:PlaceInfo, attempt:int, totalPlannedAttempt:int):Point {
		var factor:int;
//		if (pInfo != null && pInfo.get().patch != null) {
			var p:Patch= Patch(pInfo.get().patch);
			factor = p.getWidth() > p.getHeight() ? p.getWidth() : p
					.getHeight();
			if (p.getLevel() == 0)
				factor /= 6;
			else if (p.getLevel() == 1)
				factor /= 2;
//		} else
//			factor = 30;

		factor *= 6;
		
		return new Point(next(attempt, factor), next(attempt, factor));
	}
	
	private function next( attempt:int, stdDev:Number):Number {
		return prng.nextGaussian() * attempt * stdDev;
	}

	

}
}