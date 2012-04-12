package com.settinghead.wexpression.client.controller.template
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.business.TemplateDelegate;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DownloadTemplateCommand extends SimpleCommand implements IResponder
	{
		override public function execute( note:INotification ) : void    {
			var templateId:String = note.getBody() as String;
			var delegate:TemplateDelegate = new TemplateDelegate(this);
			delegate.getTemplate(templateId);
		}
		
		public function result(data:Object):void
		{
			facade.retrieveProxy(TemplateProxy.NAME).setData(data.result);
			sendNotification(ApplicationFacade.TEMPLATE_LOADED);
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeBusyCursor();
			Alert.show("Error: "+ info.toString());
		}
	}
}