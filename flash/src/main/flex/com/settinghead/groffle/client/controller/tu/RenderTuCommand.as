package com.settinghead.groffle.client.controller.tu
{
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.WordListProxy;
	
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
			
			if(wordListProxy.currentWordList==null){
				if(!Mask.shown){
					Mask.show("Analyzing your Facebook profile and status data. Just a moment.");
				}
				setTimeout(waitForWordList, 200);
			}
			else{
				Mask.close();
				var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
				tuProxy.startRender();
			}

		}
	}
}