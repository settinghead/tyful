package com.settinghead.wexpression.client.controller.main
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.WordShaper;
	import com.settinghead.wexpression.client.controller.shop.LoadShopCommand;
	import com.settinghead.wexpression.client.controller.template.DownloadTemplateCommand;
	import com.settinghead.wexpression.client.controller.template.LoadTemplateCommand;
	import com.settinghead.wexpression.client.controller.template.NewTemplateCommand;
	import com.settinghead.wexpression.client.controller.tu.GenerateTuCommand;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.model.vo.wordlist.WordListVO;
	
	import flash.display.LoaderInfo;
	
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class StartupCommand extends MacroCommand
	{	
		/**
		 * Add the Subcommands to startup the PureMVC apparatus.
		 * 
		 * Generally, it is best to prep the Model (mostly registering 
		 * proxies)followed by preparation of the View (mostly registering 
		 * Mediators).
		 */
		override protected function initializeMacroCommand():void    
		{
			this.addSubCommand( PrepModelCommand );
			this.addSubCommand( PrepViewCommand );
			this.addSubCommand( LoadShopCommand);
			var mode:String = FlexGlobals.topLevelApplication.parameters.mode as String;
			switch(mode){
				case ApplicationFacade.MODE_EDIT_TEMPLATE:
					this.addSubCommand(DownloadTemplateCommand);
					break;
				case ApplicationFacade.MODE_RENDER_TU:
					this.addSubCommand(GenerateTuCommand);
					break;
				case ApplicationFacade.MODE_NEW_TEMPLATE:
					this.addSubCommand(NewTemplateCommand);
					break;
				break;
			}
		}
	}
}