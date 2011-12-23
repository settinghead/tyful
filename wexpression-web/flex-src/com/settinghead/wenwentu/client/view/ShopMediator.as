package com.settinghead.wenwentu.client.view
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.model.vo.TuVO;
	import com.settinghead.wenwentu.client.view.components.shop.ShopItemList;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ShopMediator extends Mediator
	{
		public function ShopMediator(viewComponent:Object=null)
		{
			public static const NAME:String = "ShopMediator";
			super(NAME, viewComponent);
		}
		
		private function get shopItemList ():ShopItemList
		{
			return viewComponent as ShopItemList;
		}
		
		override public function onRegister():void
		{
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.TU_GENERATED,
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ApplicationFacade.TU_GENERATED:
					shopItemList.img =  (note.getBody() as TuVO).img;
					break;
			}
		}
	}
}