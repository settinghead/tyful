package com.settinghead.wenwentu.client.model.vo
{
	import com.settinghead.wenwentu.client.WordComparator;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.fx.SortedListFx;
	
	public class WordListVO extends SortedList
	{
		public function WordListVO(){
			super(new WordComparator());
		}
		
		public static function generateWords():WordListVO{
			var list:WordListVO = new WordListVO();
			for(var i:int=0;i<60;i++){
				list.add(new WordVO("Freedomize", Math.random()*5+0.5));
				list.add(new WordVO("CaRRRR", Math.random()*5+0.5));
				list.add(new WordVO("eclipse", Math.random()*5+0.5));
				list.add(new WordVO("carz", Math.random()*5+0.5));
				list.add(new WordVO("sand", Math.random()*5+0.5));
				list.add(new WordVO("beach", Math.random()*5+0.5));
				list.add(new WordVO("stephen", Math.random()*5+0.5));
				list.add(new WordVO("Bloom", Math.random()*5+0.5));			
			}
			return list;
		}
	}
}