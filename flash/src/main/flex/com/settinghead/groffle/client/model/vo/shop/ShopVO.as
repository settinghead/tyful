package com.settinghead.groffle.client.model.vo.shop
{
	import com.settinghead.groffle.client.model.vo.wordlist.WordComparator;
	import com.settinghead.groffle.client.model.vo.PreviewUrlVO;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.fx.SortedListFx;
	
	public class ShopVO extends ArrayCollection
	{
		public function ShopVO(previewUrl:PreviewUrlVO, 
							   array:Array = null){
			super();
			if(array!=null){
				for(var i:int = 0; i<array.length; i++){
					this.addItem(
						new ShopItemVO(array[i].name,previewUrl,
						array[i].url,array[i].imageUrl, array[i].description));
				}
			}
			
		}
	}
}