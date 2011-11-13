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

import java.util.Random;

import processing.core.PApplet;

public class Colorers {

	public static function twoHuesRandomSats(host:PApplet):WordColorer {

		var hues:Array= new float[] { host.random(256), host.random(256) };

		return new HsbWordColorer(host) {
			public function getColorFor(w:Word):int {

				var hue:Number= hues[int(host.random(hues.length))];
				var sat:Number= host.random(256);
				var val:Number= host.random(100, 256);

				return host.color(hue, sat, val);
			}
		};
	}

	public static function twoHuesRandomSatsOnWhite(host:PApplet):WordColorer {

		var hues:Array= new float[] { host.random(256), host.random(256) };

		return new HsbWordColorer(host) {
			public function getColorFor(w:Word):int {

				var hue:Number= hues[int(host.random(hues.length))];
				var sat:Number= host.random(256);
				var val:Number= host.random(156);

				return host.color(hue, sat, val);
			}
		};
	}

	public static function pickFrom(int... colors):WordColorer {
		var r:Random= new Random();
		return new WordColorer() {
			public function colorFor(w:Word):int {
				return colors[r.nextInt(colors.length)];
			}
		};
	}

	// TODO add an overload that takes 1 int (greyscale), 2 ints
	// (greyscale/alpha), etc
	public static function alwaysUse(color:int):WordColorer {
		return new WordColorer() {
			public function colorFor(w:Word):int {
				return color;
			}
		};
	}
}
}