package com.settinghead.wenwentu.client.controller
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.model.ShopProxy;
	import com.settinghead.wenwentu.client.model.TuProxy;
	import com.settinghead.wenwentu.client.model.vo.ShopItemVO;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.model.vo.TuVO;
	import com.settinghead.wenwentu.client.model.vo.WordListVO;
	import com.settinghead.wenwentu.client.view.components.shop.ShopItemList;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepSampleShopCommand extends SimpleCommand
	{
		private  var shopProxy:ShopProxy;
		
		public function PrepSampleShopCommand()
		{
			super();
		}
		
		override public function execute( note:INotification ) : void    
		{
			this.shopProxy = facade.retrieveProxy(ShopProxy.NAME) as ShopProxy;
			var maleTee:ShopItemVO = new ShopItemVO("http://www.zazzle.com/male");
			var femaleTee:ShopItemVO = new ShopItemVO("http://www.zazzle.com/female");
			//TODO
			shopProxy.addItem(maleTee);
			shopProxy.addItem(femaleTee);
		}
		
	}
}