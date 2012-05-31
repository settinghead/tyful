package com.settinghead.groffle.client.controller.tu
{
	import com.settinghead.groffle.client.model.TuProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RenderTuCommand extends SimpleCommand
	{
		public function RenderTuCommand()
		{
			super();
		}
		
		public override function execute(note:INotification):void{
			var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;

			tuProxy.startRender();

		}
	}
}