package com.settinghead.tyful.client.controller.tu
{
	import com.notifications.Notification;
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.TemplateProxy;
	import com.settinghead.tyful.client.model.TuProxy;
	import com.settinghead.tyful.client.model.WordListProxy;
	
	import flash.utils.setTimeout;
	
	import net.codestore.flex.Mask;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RenderTuCommand extends SimpleCommand
	{
		public function RenderTuCommand()
		{
			super();
		}
		
		public override function execute(note:INotification):void{
			this.waitForWordList();
		}
		

		private function waitForWordList():void{
			
			var wordListProxy:WordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			if(templateProxy.template==null){
				if(!templateProxy.loading)
					facade.sendNotification(ApplicationFacade.DOWNLOAD_TEMPLATE);
				if(!Mask.shown){
					Mask.show("Loading template. Just a moment.");
				}
				setTimeout(function():void{
					facade.sendNotification(ApplicationFacade.RENDER_TU);
				}
					, 200);	
			}
			else if(wordListProxy.currentWordList==null){
				if(!Mask.shown){
					Mask.show("Analyzing your Facebook profile and status data. Just a moment.");
				}
				setTimeout(function():void{
					facade.sendNotification(ApplicationFacade.RENDER_TU);
				}
					, 200);				}
			else{
				Mask.close();

				var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;

				tuProxy.load();
				tuProxy.startRender();

			}

		}
	}
}