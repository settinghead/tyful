package com.settinghead.wenwentu.client.model.vo
{
	import com.settinghead.wenwentu.client.WordComparator;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.fx.SortedListFx;
	
	public class WordListVO extends ArrayCollection
	{
		public static function generateWords():WordListVO{
			var list:WordListVO = new WordListVO();
			for(var i:int=0;i<60;i++){
				list.addItem(new WordVO("Freedomize", Math.random()*5+0.5));
				list.addItem(new WordVO("CaRRRR", Math.random()*5+0.5));
				list.addItem(new WordVO("eclipse", Math.random()*5+0.5));
				list.addItem(new WordVO("carz", Math.random()*5+0.5));
				list.addItem(new WordVO("sand", Math.random()*5+0.5));
				list.addItem(new WordVO("beach", Math.random()*5+0.5));
				list.addItem(new WordVO("stephen", Math.random()*5+0.5));
				list.addItem(new WordVO("Bloom", Math.random()*5+0.5));			
			}
			return list;
		}
	}
}