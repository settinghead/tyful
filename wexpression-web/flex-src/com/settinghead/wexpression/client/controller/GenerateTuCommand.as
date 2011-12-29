package com.settinghead.wexpression.client.controller
{
	import com.settinghead.wexpression.client.model.vo.TuVO;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import org.as3commons.reflect.Method;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GenerateTuCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) : void    {
			var tu:TuVO = note.getBody() as TuVO;
			
		}
	}
}