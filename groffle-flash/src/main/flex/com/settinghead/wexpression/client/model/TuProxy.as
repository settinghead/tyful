package com.settinghead.wexpression.client.model
{
	import com.adobe.images.PNGEncoder;
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.RenderOptions;
	import com.settinghead.wexpression.client.WordShaper;
	import com.settinghead.wexpression.client.angler.MostlyHorizAngler;
	import com.settinghead.wexpression.client.angler.ShapeConfinedAngler;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.colorer.WordColorer;
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.fonter.WordFonter;
	import com.settinghead.wexpression.client.model.vo.DisplayWordVO;
	import com.settinghead.wexpression.client.model.vo.EngineWordVO;
	import com.settinghead.wexpression.client.model.vo.TextShapeVO;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.model.vo.wordlist.WordListVO;
	import com.settinghead.wexpression.client.model.vo.wordlist.WordVO;
	import com.settinghead.wexpression.client.nudger.WordNudger;
	import com.settinghead.wexpression.client.placer.ShapeConfinedPlacer;
	import com.settinghead.wexpression.client.placer.WordPlacer;
	import com.settinghead.wexpression.client.sizers.WordSizer;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	
	import org.as3commons.collections.Set;
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IIterator;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	public class TuProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "TuProxy";
		public static const SRNAME:String = "TuSRProxy";
		
		private var _template:TemplateVO;
		private var _wordList:WordListVO;
		private var _startTime:int;
		private var _rendering:Boolean = false;
		
		public var generateTemplatePreview:Boolean = false;
		
		public function TuProxy()
		{
			super(NAME, new ArrayCollection());
		}
		
		public function markStartRendering():void{
			_rendering = true;
			_startTime = getTimer();
		}
		
		public function markStopRendering():void{
			_rendering = false;
		}
		
		public function get rendering():Boolean{
			return _rendering;
		}
		
		public function get startTime():int{
			return _startTime;
		}
		
		// return data property cast to proper type
		public function get tu():TuVO
		{
			return data as TuVO;
		}
		
		public function set tu(tu:TuVO):void
		{
			this.setData(tu);
		}
		
		
		public function load() :void{
			var tu:TuVO = new TuVO(_template, _wordList);
			this.setData(tu);

		}
		
		public function set template(t:TemplateVO):void{
			this._template = t;
		}
		
		public function set wordList(wl:WordListVO):void{
			this._wordList = wl;
		}

		
		private var failureCount:int = 0;
		
		private var pendingEword:EngineWordVO = null;
		
		public function renderNextDisplayWord(tu:TuVO):void{
			//TODO
			var eWord:EngineWordVO = null;
			var word:WordVO = null;
			if(pendingEword!=null)
			{
				if(tu.indexOffset+tu.currentWordIndex<tu.words.size - 1)
					tu.indexOffset+=tu.words.size/40;
				if(tu.indexOffset+tu.currentWordIndex>tu.words.size)
				{
					tu.indexOffset = tu.words.size -1;
				}
				word = pendingEword.word;
				pendingEword = null;
			}
			else{
			word = tu.getNextWordAndIncrement();
			}
			if(word==null) return;
			eWord = generateEngineWord(word);

			if(eWord!=null){
				placeWord(eWord);			
				
				if(eWord.wasSkipped() &&
					tu.indexOffset+tu.currentWordIndex<tu.words.size - 1)
					//store in pending eword and retry a smaller size
					//in next round
				{
					pendingEword = eWord;
					return;
				}
				
				tu.pushEngineWord(eWord);
				var dw:DisplayWordVO = null;
				if(!eWord.wasSkipped()){
					failureCount = 0;
					dw = eWord.rendition(tu.template.colorer.colorFor(eWord));
					tu.dWords.addItem(dw);
				}
				else{
					failureCount ++;
					
					//5 consecutive failures. Put rendering to an end.
					if (failureCount > tu.template.perseverance){
//						tu.skipToLast();
						sendNotification(ApplicationFacade.TU_GENERATION_LAST_CALL);
						
						markStopRendering();

				}
				
				if(tu.generatedImage==null && getTimer() - startTime > 9000)
					//timed out; display generate image even if unfinished
				{
					facade.sendNotification(ApplicationFacade.GENERATE_TU_IMAGE);
				}
				}
				sendNotification(ApplicationFacade.DISPLAYWORD_CREATED, dw);
			}
		}
		
		public function generateEngineWord(word:WordVO):EngineWordVO{
			var newIndex:int = tu.currentWordIndex+tu.indexOffset<tu.words.size?
				tu.currentWordIndex + tu.indexOffset:tu.words.size;
			var eWord:EngineWordVO= new EngineWordVO(word, newIndex , tu.words.size);
			
			var wordFont:String= tu.template.fonter.fontFor(word);
			var wordSize:Number= tu.template.sizer.sizeFor(word,newIndex,tu.words.size);
			//			var wordAngle:Number= template.angler.angleFor(eWord);
			
			var shape:TextShapeVO= WordShaper.makeShape(word.word, wordSize, wordFont, 0);
			if (shape == null) {
				skipWord(eWord, EngineWordVO.SKIP_REASON_SHAPE_TOO_SMALL);
			} else {
				eWord.setShape(shape, tu.template.renderOptions.wordPadding);
			}
			
			return eWord;
		}
		
		public function placeWord(eWord:EngineWordVO):Boolean {
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
					for (var i:int= 0; !foundOverlap && i < tu.currentWordIndex; i++) {
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
		
		private var urlLoader : URLLoader;

		public function postToFacebook():void{
			var b:ByteArray = PNGEncoder.encode(tu.generatedImage);
			// set up the request & headers for the image upload;
			var urlRequest : URLRequest = new URLRequest();
			urlRequest.url = 'facebook/publish_photo';
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = b;
			urlRequest.requestHeaders.push(header);
			// create the image loader & send the image to the server;
			urlLoader = new URLLoader();
			//			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, photoPostComplete);
			urlLoader.load( urlRequest );	
		}
		
		public function photoPostComplete(e:Event):void{
		}
	}
}