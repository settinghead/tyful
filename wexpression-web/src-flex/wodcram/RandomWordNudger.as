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

import processing.core.PVector;

/**
 * A RandomWordNudger, where each attempt's PVector has X & Y coords
 * distributed randomly around the desired point, multiplied by a standard deviation,
 * and multiplied by the attempt number (so it gets farther, as it gets more 
 * desperate).
 * 
 * @author Dan Bernier
 */
public class RandomWordNudger implements WordNudger {

	private var r:Random= new Random();
	private var stdDev:Number;
	
	/**
	 * Create a RandomWordNudger with a standard deviation of 0.6.
	 */
	public function RandomWordNudger() {
		this(0.6);
	}

	/**
	 * Create a RandomWordNudger with your own standard deviation.
	 */
	public function RandomWordNudger(stdDev:Number) {
		this.stdDev = stdDev;
	}

	public function nudgeFor(w:Word, attempt:int):PVector {
		return new PVector(next(attempt), next(attempt));
	}
	
	private function next(attempt:int):Number {
		return float(r.nextGaussian() )* attempt * stdDev;
	}

}
}