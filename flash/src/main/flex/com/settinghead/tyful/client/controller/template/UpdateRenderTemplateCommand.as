package com.settinghead.tyful.client.controller.template
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.RenderProxy;
	import com.settinghead.tyful.client.model.TemplateProxy;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class UpdateRenderTemplateCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) : void    {
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			var renderProxy:RenderProxy = facade.retrieveProxy(RenderProxy.NAME) as RenderProxy;
			
			renderProxy.updateTemplate(templateProxy.template);
		}
	}
}