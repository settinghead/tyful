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

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Vector;

class WordSorterAndScaler {

	public List<Word> sortAndScale(List<Word> rawWords) {

		List<Word> words = copy(rawWords);
		Collections.sort(words);
		float maxWeight = words.get(0).weight;

		for (Word word : words) {
			word.weight = word.weight / maxWeight;
		}

		return words;
	}

	private List<Word> copy(List<Word> rawWords) {

		// was Arrays.copyOf(rawWords, rawWords.length); - removed for Java 1.5
		// compatibility.

		List<Word> copy = new Vector<Word>();
		for (int i = 0; i < rawWords.size(); i++) {
			copy.add(rawWords.get(i));
		}
		return copy;
	}
}
