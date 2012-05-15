package com.settinghead.groffle.client.controller.tu
{
	import com.settinghead.groffle.client.model.TemplateProxy;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.TuVO;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import mx.rpc.IResponder;
	
	import org.as3commons.reflect.Method;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GenerateTuCommand extends SimpleCommand
	{
		override public function execute( note:INotification ):void {
			var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;

			var tu:TuVO = tuProxy.tu;
			tuProxy.template = tu.template;
			tuProxy.wordList = tu.words;
			tuProxy.load();
		}
	}
}