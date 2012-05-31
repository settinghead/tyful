package com.settinghead.groffle.client.model
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	
	import flash.utils.getTimer;
	
	import org.generalrelativity.thread.process.AbstractProcess;
	
	public class RenderTuProcess extends AbstractProcess
	{
		private static const MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE:int = 2;
		private static const SNAPSHOT_INTERVAL:int = 22;
		private var _tu:TuVO;
		private var _wordList:WordListVO;
		private var numRetries:int = 0;
		private var _failureCount:int = 0;
		private var facade:ApplicationFacade;
		
		public function RenderTuProcess(facade:ApplicationFacade, isSelfManaging:Boolean=false)
		{
			super(isSelfManaging);
			this.facade = facade;
		}
		
		override public function run() : void
		{
			currentStep();
		}
		
		override public function runAndManage( allocation:int ) : void
		{
			var start:int = getTimer();
			while(_tu!=null && !_failureCount<_tu.template.perseverance && getTimer() - start < allocation )
			{
				currentStep();
			}
		}
		
		private function currentStep(){
			//TODO
		}
	}
}