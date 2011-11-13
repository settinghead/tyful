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

import java.util.Arrays;


internal class WordSorterAndScaler {

	public Word[] sortAndScale(var rawWords:Array) {
		
		var words:Array= copy(rawWords);
		Arrays.sort(words);
		var maxWeight:Number= words[0].weight;
		
		for (Word word : words) {
			word.weight = word.weight / maxWeight;
		}
		
		return words;
	}
	
	private Word[] copy(var rawWords:Array) {
		
		// was Arrays.copyOf(rawWords, rawWords.length); - removed for Java 1.5 compatibility.
		
		var copy:Array= new Word[rawWords.length];
		for(var i:int= 0; i < copy.length; i++) {
			copy[i] = rawWords[i];
		}
		return copy;
	}
}
}