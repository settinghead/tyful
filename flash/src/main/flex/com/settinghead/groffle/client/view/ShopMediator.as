package com.settinghead.groffle.client.view
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.ShopProxy;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.view.components.shop.ShopItemList;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ShopMediator extends Mediator
	{
		private var shopProxy:ShopProxy;
		private var tuProxy:TuProxy;
		public static const NAME:String = "ShopMediator";

		public function ShopMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		private function get shopItemList ():ShopItemList
		{
			return viewComponent as ShopItemList;
		}
		
		override public function onRegister():void
		{
			shopProxy = facade.retrieveProxy(ShopProxy.NAME) as ShopProxy;
			tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.TU_IMAGE_GENERATED,
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ApplicationFacade.TU_IMAGE_GENERATED:
					shopProxy.uploadImage(tuProxy.tu.generatedImage);
					shopItemList.list = shopProxy.shop;
					break;
			}
		}
	}
}