package com.settinghead.groffle.client.controller.main
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.vo.wordlist.WordShaper;
	import com.settinghead.groffle.client.controller.shop.LoadShopCommand;
	import com.settinghead.groffle.client.controller.template.DownloadTemplateCommand;
	import com.settinghead.groffle.client.controller.template.LoadTemplateCommand;
	import com.settinghead.groffle.client.controller.template.NewTemplateCommand;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	
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