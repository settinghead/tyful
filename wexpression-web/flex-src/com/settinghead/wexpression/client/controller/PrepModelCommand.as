package com.settinghead.wexpression.client.controller
{
	import com.settinghead.wexpression.client.model.ShopProxy;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.vo.TemplateVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepModelCommand extends SimpleCommand
	{
		/**
		 * Prepare the Model.
		 */
		override public function execute( note:INotification ) : void    
		{
			// Create Template Proxy, 
			var templateProxy:TemplateProxy = new TemplateProxy();
			
//			//Populate it with dummy data 
//			templateProxy.addItem( new TemplateVO("templates/dog.png" ) );
//			templateProxy.addItem( new TemplateVO("templates/face.png" ) );
//			templateProxy.addItem( new TemplateVO("templates/star.png" ) );
//			templateProxy.addItem( new TemplateVO("templates/heart.png" ) );
//			templateProxy.addItem( new TemplateVO("templates/wheel_h.png" ) );
//			templateProxy.addItem( new TemplateVO("templates/wheel_v.png" ) );
			
			// register it
			facade.registerProxy( templateProxy );
			facade.registerProxy(new TuProxy );
			facade.registerProxy(new ShopProxy);
			
		}
	}
}