package com.settinghead.tyful.client.model.vo.wordlist {

	

	[Bindable]
	public class WordVO {
		public var word:String;
		public var weight:Number;
		public var occurences:Array;
	
		public function WordVO(word:String = null, weight:Number = 1, occurences:Array=null) {
			this.word = word;
			this.weight = weight;
			this.occurences = occurences;
		}	
		

	}
}