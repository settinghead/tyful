package com.settinghead.tyful.client.controller.main
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.vo.wordlist.WordShaper;
	import com.settinghead.tyful.client.controller.shop.LoadShopCommand;
	import com.settinghead.tyful.client.controller.template.DownloadTemplateCommand;
	import com.settinghead.tyful.client.controller.template.LoadTemplateCommand;
	import com.settinghead.tyful.client.controller.template.NewTemplateCommand;
	import com.settinghead.tyful.client.model.TuProxy;
	import com.settinghead.tyful.client.model.vo.TuVO;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	
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
			this.addSubCommand( InitCommand);
			
		}
	}
}