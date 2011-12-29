package com.settinghead.wexpression.client.model
{
	import com.settinghead.wexpression.client.view.components.shop.ShopItemList;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ShopProxy extends Proxy
	{
		public static const NAME:String = "ShopProxy";
		
		public function ShopProxy()
		{
			super(NAME, new ArrayCollection());
			
		}
		
		// return data property cast to proper type
		public function get shop():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		// add an item to the data
		public function addItem( item:Object ):void
		{
			shop.addItem( item );
		}
	}
}