package com.settinghead.wexpression.client.controller.template
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.business.TemplateDelegate;
	import com.settinghead.wexpression.client.model.vo.ZipOutputImpl;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.effects.Zoom;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SaveTemplateCommand extends SimpleCommand implements IResponder
	{
		override public function execute( note:INotification ) : void    {
			var template:TemplateVO = note.getBody() as TemplateVO;
			if(template==null) template = templateProxy.template;
			
			var templateProxy:TemplateProxy = (facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy);
			
			var fr:FileReference = new FileReference();
			fr.save(templateProxy.toFile(template), "template.zip");
			sendNotification(ApplicationFacade.TEMPLATE_SAVED);

		}
		
		public function result(data:Object):void
		{
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeBusyCursor();
			Alert.show("Error: "+ info.toString());
		}
	}
}