package com.settinghead.wexpression.client.model.vo {

	import flash.geom.Point;
	import com.settinghead.wexpression.client.PlaceInfo;

	[Bindable]
	[RemoteClass(alias="com.settinghead.wexpression.server.model.Word")]
	public class WordVO {
		public var word:String;
		public var weight:Number;
	
		public function WordVO(word:String = null, weight:Number = 1) {
			this.word = word;
			this.weight = weight;
		}	
	}
}