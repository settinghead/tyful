package com.settinghead.wexpression.client {
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IIterator;

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



internal class WordSorterAndScaler {

	public function sortAndScale(rawWords:SortedList):SortedList {
		
		var maxWeight:Number= rawWords.first.getWeight();
		
		var it2:IIterator = rawWords.iterator();
		while(it2.hasNext()){
			var w:Word = it2.next();
			w.weight = w.weight / maxWeight;
		}

		return rawWords;
		
	}

//	private List<Word> copy(List<Word> rawWords) {
//
//		// was Arrays.copyOf(rawWords, rawWords.length); - removed for Java 1.5
//		// compatibility.
//
//		List<Word> copy = new Vector<Word>();
//		for (var i:int= 0; i < rawWords.size(); i++) {
//			copy.add(rawWords.get(i));
//		}
//		return copy;
//	}
}
}