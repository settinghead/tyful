package com.settinghead.wexpression.client.model
{
	import com.settinghead.wexpression.client.view.components.shop.ShopItemList;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	public class ShopProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "ShopProxy";
		public static const SRNAME:String = "ShopSRProxy";
		
		public function ShopProxy()
		{
			super(NAME, new ArrayCollection());
		}
		
		public function load() :void{
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