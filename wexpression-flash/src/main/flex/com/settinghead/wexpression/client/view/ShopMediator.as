package com.settinghead.wexpression.client.view
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.ShopProxy;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.view.components.shop.ShopItemList;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ShopMediator extends Mediator
	{
		private var shopProxy:ShopProxy;
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
					shopItemList.img =  (note.getBody() as TuVO).generatedImage;
					shopItemList.list = shopProxy.shop;
					break;
			}
		}
	}
}