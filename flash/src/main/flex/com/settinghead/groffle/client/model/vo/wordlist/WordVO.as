package com.settinghead.groffle.client.model.vo.wordlist {

	import com.settinghead.groffle.client.PlaceInfo;
	
	import flash.geom.Point;

	[Bindable]
	[RemoteClass(alias="com.settinghead.wexpression.server.model.Word")]
	public class WordVO {
		public var word:String;
		public var weight:Number;
	
		public function WordVO(word:String = null, weight:Number = 1) {
			this.word = word;
			this.weight = weight;
		}	
		
		public function clone():WordVO{
			return new WordVO(word, weight);
		}
	}
}