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

import processing.core.*;

public class WaveWordPlacer implements WordPlacer {

	public function place(word:Word, wordIndex:int, wordsCount:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int):PVector {

		var normalizedIndex:Number= float(wordIndex )/ wordsCount;
		var x:Number= normalizedIndex * fieldWidth;
		var y:Number= normalizedIndex * fieldHeight;

		var yOffset:Number= getYOffset(wordIndex, wordsCount, fieldHeight);
		return new PVector(x, y + yOffset);
	}

	private function getYOffset(wordIndex:int, wordsCount:int, fieldHeight:int):Number {
		var theta:Number= PApplet.map(wordIndex, 0, wordsCount, PConstants.PI, -PConstants.PI);

		return float(Math.sin(theta) )* (fieldHeight / 3);
	}
}
}