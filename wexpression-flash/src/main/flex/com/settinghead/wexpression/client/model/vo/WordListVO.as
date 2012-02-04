package com.settinghead.wexpression.client.model.vo
{
	import com.settinghead.wexpression.client.WordComparator;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.fx.SortedListFx;
	
	public class WordListVO extends SortedList
	{
		public function WordListVO(array:ArrayCollection = null){
			super(new WordComparator());
			if(array!=null){
				for(var i:int = 0; i<array.length; i++){
					this.add(new WordVO(array[i].word,array[i].weight));
				}
			}
		}
	}
}