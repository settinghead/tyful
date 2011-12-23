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
			for(var i:int=0;i<80;i++){
				list.add(new WordVO("Freedomize", Math.random()*5+0.5));
				list.add(new WordVO("philosophy", Math.random()*5+0.5));
				list.add(new WordVO("Ministry of Tofu", Math.random()*5+0.5));
				list.add(new WordVO("form of forms", Math.random()*5+0.5));
				list.add(new WordVO("sand", Math.random()*5+0.5));
				list.add(new WordVO("beach", Math.random()*5+0.5));
				list.add(new WordVO("for the lulz", Math.random()*5+0.5));
				list.add(new WordVO("Bloom", Math.random()*5+0.5));	
				list.add(new WordVO("MOLLY", Math.random()*5+0.5));			
				list.add(new WordVO("shake spear", Math.random()*5+0.5));
			}
			return list;
		}
	}
}