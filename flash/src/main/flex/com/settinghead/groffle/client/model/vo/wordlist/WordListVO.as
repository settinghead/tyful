package com.settinghead.groffle.client.model.vo.wordlist
{
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.fx.SortedListFx;
	
	import valueObjects.WordList;
	
	public class WordListVO extends SortedList
	{
		public function WordListVO(array:Array){
			super(new WordComparator());
			if(array!=null){
				for(var i:int = 0; i<array.length; i++){
					this.add(new WordVO(array[i].word,array[i].weight, array[i].occurences));
				}
			}
			
			var current_i:int=0;
			while(this.size<1000){
				var w:WordVO = this.itemAt((current_i++)%this.size) as WordVO;
				this.add(new WordVO(w.word, 0));
			}
		}
	}
}