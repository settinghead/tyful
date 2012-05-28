package com.settinghead.groffle.client.view
{
	import com.notifications.Notification;
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.ShopProxy;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.model.vo.shop.ShopItemVO;
	import com.settinghead.groffle.client.view.components.shop.ShopClickEvent;
	import com.settinghead.groffle.client.view.components.shop.ShopItemList;
	import com.settinghead.groffle.client.view.components.shop.ShopItemRenderer;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	[Event(name="ProcessShopClick", type="com.settinghead.groffle.client.view.components.shop.ShopClickEvent")]

	public class ShopMediator extends Mediator
	{
		private var shopProxy:ShopProxy;
		private var tuProxy:TuProxy;
		public static const NAME:String = "ShopMediator";
		private var pendingShopClick:Boolean = false;
		
		public function ShopMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			shopItemList.addEventListener(ShopItemRenderer.PROCESS_SHOP_CLICK, processShopClick);
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
					if(!tuProxy.generateTemplatePreview)
						shopProxy.uploadImage(tuProxy.tu.generatedImage);
					shopItemList.list = shopProxy.shop;
					break;
			}
		}
		
		private var currentItem:ShopItemVO;
		private function processShopClick(e:ShopClickEvent):void{ // file loaded
			this.currentItem = e.item;
			if(tuProxy.tu.generatedImage==null)
				facade.sendNotification(ApplicationFacade.GENERATE_TU_IMAGE);
			pendingShopClick = true;
			setTimeout(checkOpenUrl, 200);

		}
		
		private function checkOpenUrl():void{
			Notification.show("nono");
			if(shopProxy.previewUrl.url!=null){
				navigateToURL(new URLRequest(currentItem.itemUrl), '_blank');
				pendingShopClick = false;

			}
			else
				setTimeout(checkOpenUrl, 200);
		}
	}
}