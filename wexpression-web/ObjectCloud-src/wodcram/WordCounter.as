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

import java.util.*;
import java.util.Map.Entry;

import cue.lang.Counter;
import cue.lang.WordIterator;
import cue.lang.stop.StopWords;


internal class WordCounter {

	private var cueStopWords:StopWords;
	private Set<String> extraStopWords = new HashSet<String>();
	private var excludeNumbers:Boolean;
	
	public function WordCounter() {
		this(null);
	}
	public function WordCounter(cueStopWords:StopWords) {
		this.cueStopWords = cueStopWords;
	}
	
	public function withExtraStopWords(extraStopWordsString:String):WordCounter {
		var stopWordsArray:Array= extraStopWordsString.toLowerCase().split(" ");
		extraStopWords = new HashSet<String>(Arrays.asList(stopWordsArray));
		return this;
	}
	
	public function shouldExcludeNumbers(shouldExcludeNumbers:Boolean):WordCounter {
		excludeNumbers = shouldExcludeNumbers;
		return this;
	}

	public Word[] count(var text:String) {
		if (cueStopWords == null) {
			cueStopWords = StopWords.guess(text);
		}
		return countWords(text);
	}

	private Word[] countWords(var text:String) {
		Counter<String> counter = new Counter<String>();
		
		for (String word : new WordIterator(text)) {
			if (shouldCountWord(word)) {
				counter.note(word);
			}
		}
		
		List<Word> words = new ArrayList<Word>();
		
		for (Entry<String, Integer> entry : counter.entrySet()) {
			words.add(new Word(entry.getKey(), int(entry.getValue())));
		}
		
		return words.toArray(new Word[0]);
	}

	private function shouldCountWord(word:String):Boolean {
		return !isStopWord(word) && !(excludeNumbers && isNumeric(word));
	}

	private function isNumeric(word:String):Boolean {
		try {
			Double.parseDouble(word);
			return true;
		}
		catch (x:NumberFormatException) {
			return false;
		}
	}

	private function isStopWord(word:String):Boolean {
		return cueStopWords.isStopWord(word) || 
				extraStopWords.contains(word.toLowerCase());
	}

}
}