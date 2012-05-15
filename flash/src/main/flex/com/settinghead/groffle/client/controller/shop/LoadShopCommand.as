package com.settinghead.groffle.client.controller.shop
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.ShopProxy;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.shop.ShopItemVO;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	import com.settinghead.groffle.client.view.components.shop.ShopItemList;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadShopCommand extends SimpleCommand
	{
		private  var shopProxy:ShopProxy;
		
		public function LoadShopCommand()
		{
			super();
		}
		
		override public function execute( note:INotification ) : void    
		{
			this.shopProxy = facade.retrieveProxy(ShopProxy.NAME) as ShopProxy;
			var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			shopProxy.load();
		}
		
	}
}