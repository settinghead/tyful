package com.settinghead.groffle.client.model.algo
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.density.Patch;
	import com.settinghead.groffle.client.model.ITuImageGenerator;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.vo.DisplayWordVO;
	import com.settinghead.groffle.client.model.vo.EngineWordVO;
	import com.settinghead.groffle.client.model.vo.TextShapeVO;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.model.vo.template.PlaceInfo;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordShaper;
	import com.settinghead.groffle.client.model.vo.wordlist.WordVO;
	
	import flash.utils.getTimer;
	
	import org.generalrelativity.thread.process.AbstractProcess;
	import org.puremvc.as3.interfaces.IFacade;
	
	public class RenderTuProcess extends AbstractProcess
	{
		private static const MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE:int = 2;
		private static const SNAPSHOT_INTERVAL:int = 22;
		private var lastSnapShotAt:int = 0;
		private var tu:TuVO;
		private var wordList:WordListVO;
		private var numRetries:int = 0;
		private var _failureCount:int = 0;
		private var facade:IFacade;
		private var _startTime:int;
		private var snapshotTicker:int=0;
		private var _currentWordIndex:int = -1;
		private var totalAttemptedWords:int = 0;
		private var generator:ITuImageGenerator;
		
		private var tuProxy:TuProxy;
		
		public function RenderTuProcess(facade:IFacade, tu:TuVO, generator:ITuImageGenerator,
										 isSelfManaging:Boolean=false)
		{
			super(isSelfManaging);
			this.facade = facade;
			this.tu = tu;
			this.generator = generator;
			this.tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			resetCurrentWordIndex();
			//			indexOffset=0;
			retryWords = new Vector.<WordVO>();
			totalAttemptedWords = 0;
			tu.template.sizer.reset();
		}
		
		public override function get percentage() : Number
		{
			return failureCount<tu.template.perseverance?0:1;
		}
		
		override public function run() : void
		{
			if(_startTime==0)
				_startTime = getTimer();
			if(generator.rendering) 
				currentStep();
		}

		
		override public function runAndManage( allocation:int ) : void
		{
			var start:int = getTimer();
			while(tu!=null && _failureCount<tu.template.perseverance && getTimer() - start < allocation &&
			generator.rendering
			)
			{
				currentStep();
			}
		}
		
		private function currentStep():void{
			//TODO
			renderNextDisplayWord();
		}
		
		public function get failureCount():int{
			return _failureCount;
		}
		
		
		private var retryWords:Vector.<WordVO> = new Vector.<WordVO>();
		
		public function renderNextDisplayWord():void{
			//TODO
			var eWord:EngineWordVO = null;
			var word:WordVO = null;
			
			word = getNextWordAndIncrement();
			if(word==null) return;
			eWord = generateEngineWord(word);
			
			if(eWord!=null){
				placeWord(eWord);			
				
				if(eWord.wasSkipped()){
					if(tu.template.sizer.hasNextSize())
						//store in pending eword and retry a smaller size
						//in next round
					{
						if(totalAttemptedWords>0){
							retryWords.push(eWord.word);
							//							_failureCount++;
							//							//5 consecutive failures. Put rendering to an end.
							//							if (failureCount > tu.template.perseverance){
							//								//						tu.skipToLast();
							//								facade.sendNotification(ApplicationFacade.TU_GENERATION_LAST_CALL);
							//								
							//								
							//								markStopRendering();
							//								
							//							}
							numRetries++;
						}
						else
							//first word. instruct the next round to immediately reduce size
							numRetries = MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE;
						if(numRetries==MAX_NUM_RETRIES_BEFORE_REDUCE_SIZE ){
							//				&&indexOffset+totalAttemptedWords<tu.words.size - 1){
							//				var incr:int = tu.words.size/40;
							//				if(incr==0) incr = 1;
							//				indexOffset+=incr;
							//				if(indexOffset+totalAttemptedWords>tu.words.size)
							//				{
							//					indexOffset = tu.words.size -1;
							//				}
							tu.template.sizer.switchToNextSize();
							numRetries=0;
						}
						return;
						
					}
				}
				
				tu.pushEngineWord(eWord);
				
				
				var dw:DisplayWordVO = null;
				if(!eWord.wasSkipped()){
					if(_failureCount>1) _failureCount -= 2;
					dw = eWord.rendition(tu.template.colorer.colorFor(eWord));
					tu.dWords.addItem(dw);
					
					if(!tuProxy.generateTemplatePreview){
						if(_startTime>0)
							//timed out; display generate image even if unfinished
						{
							if(tu.generatedImage==null && getTimer() - _startTime > 10000){
								tuProxy.generateImage();
								_startTime = -1;
							}
						}
						else{
							if(++snapshotTicker>=SNAPSHOT_INTERVAL && getTimer()-lastSnapShotAt > 10000){
								tuProxy.generateImage();
								//							Notification.show("Snapshot generated.");
								
								snapshotTicker = 0;
								lastSnapShotAt = getTimer();
								
							}
						}
					}
					
				}
				else{
					_failureCount ++;
					
					//5 consecutive failures. Put rendering to an end.
					if (failureCount >= tu.template.perseverance){
						//						tu.skipToLast();
						tuProxy.generateImage();
						facade.sendNotification(ApplicationFacade.TU_GENERATION_LAST_CALL);

						if(tuProxy.generateTemplatePreview){
							tu.template.preview = generator.canvasImage(300);
							
							facade.sendNotification(ApplicationFacade.TEMPLATE_PREVIEW_GENERATED);
						}
						else{
							//desperate measure: fill in whatever is available as preview
							// warning: may violate user privacy
//							if(tu.template.preview==null){
//								tu.template.preview = generator.canvasImage(300);
//								
//							}
						}
					}
				}
				facade.sendNotification(ApplicationFacade.DISPLAYWORD_CREATED, dw);
			}
		}
		

		private function generateEngineWord(word:WordVO):EngineWordVO{
			var newIndex:int = totalAttemptedWords
				//				+indexOffset
				<tu.words.size?
				totalAttemptedWords
				//				+ indexOffset
				:tu.words.size;
			var eWord:EngineWordVO= new EngineWordVO(word, newIndex , tu.words.size);
			
			var wordFont:String= tu.template.fonter.fontFor(word);
			var wordSize:Number= tu.template.sizer.currentSize();
			//.sizeFor(word,newIndex,tu.words.size);
			//			var wordAngle:Number= template.angler.angleFor(eWord);
			
			var shape:TextShapeVO= WordShaper.makeShape(word.word, wordSize, wordFont, 0);
			if (shape == null) {
				skipWord(eWord, EngineWordVO.SKIP_REASON_SHAPE_TOO_SMALL);
			} else {
				eWord.setShape(shape, tu.template.renderOptions.wordPadding);
			}
			
			return eWord;
		}
		
		private function placeWord(eWord:EngineWordVO):Boolean {
			//			totalCount++;
			//			tu.failedLastVar = false;
			var word:WordVO= eWord.word;
			
			// these into
			// EngineWord.setDesiredLocation?
			// Does that make
			// sense?
			var wordImageWidth:int= int(eWord.shape.textField.width);
			var wordImageHeight:int= int(eWord.shape.textField.height);
			
			eWord.retrieveDesiredLocations(tu.template.placer, tu.eWords.length,
				wordImageWidth, wordImageHeight, tu.template.width,
				tu.template.height);
			// Set maximum number of placement trials
			
			
			while(eWord.hasNextDesiredLocation()){
				var candidateLoc:PlaceInfo = eWord.nextDesiredLocation();
				
				var maxAttemptsToPlace:int= tu.template.renderOptions.maxAttemptsToPlaceWord > 0? tu.template.renderOptions.maxAttemptsToPlaceWord
					: calculateMaxAttemptsFromWordWeight(eWord, candidateLoc.patch);
				
				var lastCollidedWith:EngineWordVO = null;
				var attempt:int;
				//				var neighboringPatches:Set = candidateLoc.patch.neighborsAndMe;
				//				var neighboringEWords:Vector.<EngineWordVO> = new Vector.<EngineWordVO>();
				
				//				var iter:org.as3commons.collections.framework.IIterator = neighboringPatches.iterator();
				
				//				
				//				while(iter.hasNext()){
				//					var p:Patch = iter.next();
				//					for each (var ew:EngineWordVO in p.eWords)
				//						neighboringEWords.push(ew);
				//					var ao:Vector.<Patch> = p.ancestorsAndOffsprngs();
				//					for each (var p1:Patch in ao){
				//						for each (var ew:EngineWordVO in p1.eWords)
				//							neighboringEWords.push(ew);
				//					}
				//				}
				
				
				inner: for (attempt= 0; attempt < maxAttemptsToPlace; attempt++) {
					eWord.nudgeTo(candidateLoc.getpVector().add(tu.template.nudger.nudgeFor(word, candidateLoc,
						attempt,maxAttemptsToPlace)), candidateLoc.patch);
					
					var angle:Number= candidateLoc.patch.layer.angler.angleFor(eWord);
					//			eWord.getTree().draw(destination.graphics);
					
					// // TODO
					eWord.getTree().setRotation(angle);
					//
					if (eWord.trespassed(candidateLoc.patch.layer, angle, tu.template.tolerance))
						continue;
					var loc:PlaceInfo= eWord.getCurrentLocation();
					if (loc.getpVector().x < 0|| loc.getpVector().y < 0|| loc.getpVector().x + wordImageWidth >= tu.template.width
						|| loc.getpVector().y + wordImageHeight >= tu.template.height) {
						continue;
					}
					
					if (lastCollidedWith != null && eWord.overlaps(lastCollidedWith)) {
						continue;
					}
					
					var foundOverlap:Boolean= false;
					
					//					for (var i:int= 0; !foundOverlap && i < neighboringEWords.length; i++) {
					for (var i:int= 0; !foundOverlap && i < tu.eWords.length; i++) {
						//						var otherWord:EngineWordVO= neighboringEWords[i];
						var otherWord:EngineWordVO = tu.eWords[i];
						if (otherWord.wasSkipped()) continue; //can't overlap with skipped word
						
						if (eWord.overlaps(otherWord)) {
							foundOverlap = true;
							
							lastCollidedWith = otherWord;
							continue inner;
						}
					}
					
					if (!foundOverlap) {
						candidateLoc.patch.mark(wordImageWidth*wordImageHeight, false);
						tu.template.placer.success(eWord.desiredLocations);
						eWord.finalizeLocation();
						//						successCount++;
						candidateLoc.patch.lastAttempt = attempt;
						return true;
					}
				}
				candidateLoc.patch.lastAttempt = attempt;
				candidateLoc.patch.fail();
			}
			
			skipWord(eWord, EngineWordVO.SKIP_REASON_NO_SPACE);
			//			info.patch.mark(wordImageWidth*wordImageHeight, true);
			tu.template.placer.fail(eWord.desiredLocations);
			//			tu.failedLastVar = true;
			return false;
		}
		
		private function calculateMaxAttemptsFromWordWeight(eWord:EngineWordVO, p:Patch):int {
			return (p.getWidth() * p.getHeight())  / (eWord.shape.width * eWord.shape.height) * 5 * tu.template.diligence;
			* (1+ Math.random() * 0.4)
				;
			//			var area:Number = p.getWidth() * p.getHeight();
			//			var result:int = area / 10000 * int(((1.0 - word.weight) * 60) )+ 30 + 40*Math.random();
			//			Assert.isTrue(result>0);
			//			return result;
		}
		
		private function skipWord(eWord:EngineWordVO, reason:int):void {
			eWord.wasSkippedBecause(reason);
		}
		
		private function getNextWordAndIncrement():WordVO{
			if(tu.eWords.length==0)
			{
				if(currentWordIndex==0) incrCurrentWordIndexAndGet();
				return tu.words.itemAt(0);
			}
			if(currentWordIndex==tu.words.size-1 && retryWords.length>0)
				return retryWords.pop(); 
			else 
				return tu.words.itemAt(incrCurrentWordIndexAndGet() % tu.words.size) as WordVO;
		}
		
		private function get currentWordIndex():int{
			return _currentWordIndex;
		}
		
		private function incrCurrentWordIndexAndGet():int{
			_currentWordIndex++;
			totalAttemptedWords ++;
			return _currentWordIndex;
		}
		
		private function resetCurrentWordIndex():void{
			_currentWordIndex = -1;
		}
		
		private function markStartRendering():void{
			_failureCount = 0;
			_startTime = getTimer();
		}
		
		private function markStopRendering():void{
			_failureCount = tu.template.perseverance;
		}
		

	}
}