package com.settinghead.wexpression.client.controller.template
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.business.TemplateDelegate;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SaveTemplateCommand extends SimpleCommand implements IResponder
	{
		override public function execute( note:INotification ) : void    {
			var template:TemplateVO = note.getBody() as TemplateVO;
			var delegate:TemplateDelegate = new TemplateDelegate(this);
			delegate.saveTemplate(template);
		}
		
		public function result(data:Object):void
		{
			sendNotification(ApplicationFacade.TEMPLATE_SAVED);
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeBusyCursor();
			Alert.show("Error: "+ info.toString());
		}
	}
}