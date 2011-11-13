package wordcram;

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

import processing.core.PApplet;
import processing.core.PVector;
import wordcram.WordPlacer.PlaceInfo;
import wordcram.density.DensityPatchIndex.LeveledPatchMap.PatchQueue.Patch;

public class ShapeConfinedWordNudger implements WordNudger {

	// Who knows? this seems to be good, but it seems to depend on the font --
	// bigger fonts need a bigger thetaIncrement.
	private float thetaIncrement = (float) (Math.PI * 0.03);
	private WordAngler angler;

	public ShapeConfinedWordNudger() {
	}

	public PVector nudgeFor(Word w, PlaceInfo pInfo, int attempt) {
		int factor;
		if (pInfo != null && pInfo.get().getReturnedObj() != null) {
			Patch p = (Patch) pInfo.get().getReturnedObj();
			factor = p.getWidth() > p.getHeight() ? p.getWidth() : p
					.getHeight();
			if (p.getLevel() == 0)
				factor /= 6;
			else if (p.getLevel() == 1)
				factor /= 2;
		} else
			factor = 30;

		factor *= 6;
		
		float rad = powerMap(0.6f, attempt, 0, 600, 1, factor * 6);

		thetaIncrement = powerMap(1, attempt, 0, 600, 0.5f, 0.3f);
		float theta = thetaIncrement * attempt;
		float x = PApplet.cos(theta) * rad;
		float y = PApplet.sin(theta) * rad;
		return new PVector(x, y);
	}

	private float powerMap(float power, float v, float min1, float max1,
			float min2, float max2) {

		float val = PApplet.norm(v, min1, max1);
		val = PApplet.pow(val, power);
		return PApplet.lerp(min2, max2, val);
	}

}
