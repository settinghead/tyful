package com.settinghead.wenwentu.client.model.vo
{
	import com.settinghead.wenwentu.client.PlaceInfo;
	
	import org.as3commons.concurrency.thread.IRunnable;
	
	public class NudgerRunner implements IRunnable
	{
		private var eWord:EngineWordVO;
		private var start:int, end:int;
		private var candidateLoc:PlaceInfo;
		private var maxAttemptsToPlace:int;
		private var _eWords:Vector.<EngineWordVO>;

		
		public function NudgerRunner(eWord:EngineWordVO, eWords:Vector.<EngineWordVO>, candidateLoc:PlaceInfo, start:int, end:int)
		{
			this.eWord = eWord;
			this.start = start;
			this.end = end;
			this.candidateLoc = candidateLoc;
			this._eWords = eWords;
		}
		}
		
		public function process():void
		{
			var lastCollidedWith:EngineWordVO = null;

			for (var attempt:int= this.start; attempt < this.end; attempt++) {
				this.eWord.nudgeTo(candidateLoc.getpVector().add(template.nudger.nudgeFor(word, candidateLoc,
					attempt,maxAttemptsToPlace)), candidateLoc.patch);
				var angle:Number= template.angler.angleFor(eWord);
				//			eWord.getTree().draw(destination.graphics);
				
				// // TODO
				this.eWord.getTree().setRotation(angle);
				//
				if (this.eWord.trespassed(template))
					continue;
				var loc:PlaceInfo= eWord.getCurrentLocation();
				if (loc.getpVector().x < 0|| loc.getpVector().y < 0|| loc.getpVector().x + wordImageWidth >= template.width
					|| loc.getpVector().y + wordImageHeight >= template.height) {
					continue;
				}
				
				if (lastCollidedWith != null && eWord.overlaps(lastCollidedWith)) {
					continue;
				}
				
				var foundOverlap:Boolean= false;
				var contInner:Boolean = true;
				for (var i:int= 0; !foundOverlap && i < currentWordIndex; i++) {
					var otherWord:EngineWordVO= _eWords[i];
					if (otherWord.wasSkipped()) continue; //can't overlap with skipped word
					
					if (this.eWord.overlaps(otherWord)) {
						foundOverlap = true;
						
						lastCollidedWith = otherWord;
						contInner = false;
						break;
					}
				}
				if(!contInner) break;
				
				if (!foundOverlap) {
					candidateLoc.patch.mark(wordImageWidth*wordImageHeight, true);
					template.placer.success(eWord.desiredLocation);
					this.eWord.finalizeLocation();
					successCount++;
					return true;
				}
			}
		}
		
		public function cleanup():void
		{
		}
		
		public function isComplete():Boolean
		{
			return false;
		}
		
		public function getTotal():int
		{
			return 0;
		}
		
		public function getProgress():int
		{
			return 0;
		}
	}
}