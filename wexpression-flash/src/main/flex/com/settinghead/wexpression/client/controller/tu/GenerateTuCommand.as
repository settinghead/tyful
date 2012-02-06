package com.settinghead.wexpression.client.controller.tu
{
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import mx.rpc.IResponder;
	
	import org.as3commons.reflect.Method;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GenerateTuCommand extends SimpleCommand
	{
		override public function execute( note:INotification ):void {
			var tu:TuVO = note.getBody() as TuVO;
			var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			tuProxy.template = tu.template;
			tuProxy.wordList = tu.words;
			tuProxy.load();
		}
	}
}