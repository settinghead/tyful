package com.settinghead.tyful.client.controller.shop
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.ShopProxy;
	import com.settinghead.tyful.client.model.TuProxy;
	import com.settinghead.tyful.client.model.vo.shop.ShopItemVO;
	import com.settinghead.tyful.client.model.vo.TuVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.view.components.shop.ShopItemList;
	
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
			var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			shopProxy.prepareSampleShop();
		}
		
	}
}