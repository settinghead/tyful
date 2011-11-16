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
import processing.core.PVector;

public class UpperLeftWordPlacer implements WordPlacer {

	private var r:Random= new Random();
	
	public function place(word:Word, wordIndex:int, wordsCount:int, wordImageWidth:int, wordImageHeight:int, fieldWidth:int, fieldHeight:int):PVector {
		var x:int= getOneUnder(fieldWidth - wordImageWidth);
		var y:int= getOneUnder(fieldHeight - wordImageHeight);
		return new PVector(x, y);
	}
	
	private function getOneUnder(limit:int):int {
		return PApplet.round(PApplet.map(random(random(random(random(random(1.0))))), 0, 1, 0, limit));
	}
	
	private function random(limit:Number):Number {
		return r.nextFloat() * limit;
	}

}
}