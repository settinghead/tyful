package com.settinghead.groffle.client.controller.main
{
	import com.settinghead.groffle.client.ApplicationFacade;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class InitCommand extends SimpleCommand
	{
		public function InitCommand()
		{
			var mode:String = decodeURIComponent(FlexGlobals.topLevelApplication.parameters.mode) as String;
			switch(mode){
				case ApplicationFacade.MODE_EDIT_TEMPLATE:
				case ApplicationFacade.MODE_SHOW_TEMPLATE:
					facade.sendNotification(ApplicationFacade.DOWNLOAD_TEMPLATE);
					break;
				case ApplicationFacade.MODE_RENDER_TU:
					facade.sendNotification(ApplicationFacade.RENDER_TU);
					break;
				case ApplicationFacade.MODE_NEW_TEMPLATE:
					facade.sendNotification(ApplicationFacade.NEW_TEMPLATE);
					break;
				default:
					Alert.show("Unrecognized command.");
					break;
			}
		}
	}
}