package com.settinghead.wenwentu.client.controller
{
	import com.settinghead.wenwentu.client.WordShaper;
	import com.settinghead.wenwentu.client.model.TuProxy;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.model.vo.TuVO;
	import com.settinghead.wenwentu.client.model.vo.WordListVO;
	
	import flash.display.LoaderInfo;
	
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
			this.addSubCommand( PrepSampleTUCommand );
			this.addSubCommand( GenerateTuCommand );
		}
	}
}