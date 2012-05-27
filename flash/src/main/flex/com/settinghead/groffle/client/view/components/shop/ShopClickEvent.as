package com.settinghead.groffle.client.view.components.shop
{
	import com.settinghead.groffle.client.model.vo.shop.ShopItemVO;
	
	import flash.events.Event;
	[Event(name="ProcessShopClick", type="com.settinghead.groffle.client.view.components.shop.ShopClickEvent")]

	public class ShopClickEvent extends Event
	{
		private var _item:ShopItemVO; 
		public function ShopClickEvent(type:String, item:ShopItemVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._item = item;
		}
		
		public function get item():ShopItemVO{
			return _item;
		}
		
		public override function clone():Event{
			return new ShopClickEvent(super.type,item,super.bubbles,super.cancelable);
		}
	}
}