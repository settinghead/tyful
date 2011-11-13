package wordcram {
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

/**
 * Some pre-fab WordAnglers.
 * <p>
 * If you want a pretty typical WordAngler, it's probably in here; if you want
 * to know how to build your own WordAngler, you can learn from the source for
 * these.
 * 
 * @author Dan Bernier
 */
import de.polygonal.math;
import de.polygonal.math.PM_PRNG;

	
public class Anglers {

	static var HALF_PI:Number = Math.PI/2;
	
	/**
	 * @return a WordAngler that gives a random angle every time it's called.
	 */
	public static function random():WordAngler {
		return new WordAngler() {
			public function angleFor(w:Word):Number {
				return Math.random() * Math.PI *2 ;
			}
		};
	}

	/**
	 * @param min
	 *            the lower-bound of the angle range
	 * @param max
	 *            the upper-bound of the angle range
	 * @return a WordAngler that gives a random angle between min and max, every
	 *         time it's called.
	 */
	public static function randomBetween(min:Number, max:Number):WordAngler {
		var difference:Number= max - min;
		return new WordAngler() {
			public function angleFor(w:Word):Number {
				return (Math.random() * difference) + min;
			}
		};
	}

	/**
	 * @return a WordAngler that angles all words between -7 degrees and 7
	 *         degrees, for a "heaped" effect.
	 */
	public static function heaped():WordAngler {
		var angle:Number= degreesToRadians(7);
		return randomBetween(-angle, angle);
	}

	/**
	 * If you want all your words to be drawn at the same angle, use this. For
	 * example, {@link #horiz()} is basically implemented as
	 * <code>return alwaysUse(0f);</code>.
	 * 
	 * @see #horiz()
	 * @param angle
	 *            The angle all words should be rotated at.
	 * @return a WordAngler that always returns the given angle parameter.
	 */
	public static function alwaysUse(angle:Number):WordAngler {
		return new WordAngler() {
			public function angleFor(w:Word):Number {
				return angle;
			}
		};
	}

	/**
	 * Just like {@link #alwaysUse(float)}, but it takes multiple angles. If you
	 * want all your words to be drawn at the same N angles, pass those angles
	 * to {@link #alwaysUse(float)}. You can pass as many angles as you like.
	 * <p>
	 * For example, if you want all your words drawn on 45&deg; and 135&deg;
	 * angles, use <code>Anglers.pickFrom(radians(45), radians(135))</code>.
	 * {@link #hexes()} is a similar example.
	 * 
	 * @see #alwaysUse(float)
	 * @see #hexes()
	 * @param angles
	 *            The angles all words should be rotated at.
	 * @return A WordAngler that will pick one of the angles, at random, for
	 *         each word.
	 */
	public static function pickFrom(float... angles):WordAngler {
		return new WordAngler() {
			public function angleFor(w:Word):Number {
				var rnd:PM_PRNG = new PM_PRNG();
				return angles[rnd.nextIntRange(0,angles.length)];
			}
		};
	}

	/**
	 * A WordAngler that draws all words at hexagonal angles, or (if you're a
	 * bit more mathy) 0&pi;/6, 1&pi;/6, 2&pi;/6, 3&pi;/6, 4&pi;/6, and 5&pi;/6.
	 * It gives a vaguely snow-flake look.
	 * <p>
	 * It's implemented with {@link #pickFrom(float...)}.
	 * <p>
	 * (In retrospect, this is probably not one you'll use very often, so it
	 * might not merit a place in Anglers. But whatever.)
	 * 
	 * @see #pickFrom(float...)
	 * @return a WordAngler that draws all words at hexagonal angles.
	 */
	public static function hexes():WordAngler {
		var oneSixth:Number= Math.PI *2 / 6;
		return pickFrom(0, oneSixth, 2* oneSixth, 3* oneSixth, 4* oneSixth,
				5* oneSixth);
	}

	/**
	 * A WordAngler that draws all words horizontally. It uses
	 * {@link #alwaysUse(float)}.
	 * 
	 * @return a WordAngler that draws all words horizontally.
	 */
	public static function horiz():WordAngler {
		return alwaysUse(0);
	}

	/**
	 * A WordAngler that draws all words vertically, pointing both up and down.
	 * It uses {@link #pickFrom(float...)}.
	 * 
	 * @return a WordAngler that draws all words vertically, pointing both up
	 *         and down.
	 */
	public static function upAndDown():WordAngler {
		return pickFrom(HALF_PI, -HALF_PI);
	}

	/**
	 * A WordAngler that draws 5/7 words horizontally, and the rest going up and
	 * down. It makes for a pretty nice effect. A WordAngler that draws all
	 * words vertically, pointing both up and down. It uses
	 * {@link #pickFrom(float...)}.
	 * 
	 * @return a WordAngler that draws most of the words horizontally, and the
	 *         rest vertically.
	 */
	public static function mostlyHoriz():WordAngler {
		return pickFrom(0, 0, 0, 0, 0, HALF_PI, -HALF_PI);
	}

	
	static function degreesToRadians(degrees:Number):Number {
		return degrees * Math.PI / 180;
	}
	
	static function radiansToDegrees(radians:Number):Number{
		return radians * 180 / Math.PI;
	}

}
}