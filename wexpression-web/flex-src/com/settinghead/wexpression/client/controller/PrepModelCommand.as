package com.settinghead.wexpression.client.controller
{
	import com.settinghead.wexpression.client.model.ShopProxy;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.WordListProxy;
	import com.settinghead.wexpression.client.model.vo.TemplateVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	import org.puremvc.as3.utilities.loadup.model.LoadupMonitorProxy;
	import org.puremvc.as3.utilities.loadup.model.LoadupResourceProxy;
	
	public class PrepModelCommand extends SimpleCommand
	{
		
		var monitor:LoadupMonitorProxy;
		/**
		 * Prepare the Model.
		 */
		override public function execute( note:INotification ) : void    
		{
			facade.registerProxy(new LoadupMonitorProxy());
			monitor = facade.retrieveProxy(LoadupMonitorProxy.NAME) as LoadupMonitorProxy;
			// Create Template Proxy, 
			var templateProxy:TemplateProxy = new TemplateProxy();
			var tuProxy:TuProxy = new TuProxy();
			var shopProxy:ShopProxy = new ShopProxy();
			var wordListProxy:WordListProxy = new WordListProxy();
			
			// register it
			facade.registerProxy( templateProxy );
			facade.registerProxy(tuProxy );
			facade.registerProxy(shopProxy);
			facade.registerProxy(wordListProxy);
			
			var rTemplate:LoadupResourceProxy = registerResourceProxy(TemplateProxy.SRNAME,templateProxy);
			var rTu:LoadupResourceProxy = registerResourceProxy(TuProxy.SRNAME,tuProxy);
			var rShop:LoadupResourceProxy = registerResourceProxy(ShopProxy.SRNAME,shopProxy);
			var rWordList:LoadupResourceProxy = registerResourceProxy(WordListProxy.SRNAME,wordListProxy);
			
			rTu.requires = [rWordList, rTemplate];
			rShop.requires = [rTu];
		}
		
		private function registerResourceProxy(srName:String, px:ILoadupProxy):LoadupResourceProxy{
			var rProxy:LoadupResourceProxy = new LoadupResourceProxy(srName, px);
			facade.registerProxy(rProxy);
			monitor.addResource(rProxy);
			return rProxy;

		}
	}
}