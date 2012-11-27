package com.settinghead.tyful.client.model.vo.wordlist
{
	
	import org.as3commons.collections.SortedList;
	
	public class WordListVO extends SortedList
	{
		private var currentWordIndex:int = 0;
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
		
		public function reset():void{
			currentWordIndex = 0;
		}
		
		public function next():WordVO{
			if(this.size==0) return null;
			var w:WordVO = this.itemAt(currentWordIndex++);
			if(currentWordIndex==this.size)
				//circular
				currentWordIndex = 0;
			return w;
		}
		
		public function clone():WordListVO{
			return new WordListVO(this.toArray());
		}
	}
}