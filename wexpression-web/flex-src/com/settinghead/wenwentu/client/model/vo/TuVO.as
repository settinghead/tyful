package com.settinghead.wenwentu.client.model.vo
{	
	import com.settinghead.wenwentu.client.PlaceInfo;
	import com.settinghead.wenwentu.client.RenderOptions;
	import com.settinghead.wenwentu.client.WordShaper;
	import com.settinghead.wenwentu.client.WordSorterAndScaler;
	import com.settinghead.wenwentu.client.angler.WordAngler;
	import com.settinghead.wenwentu.client.fonter.WordFonter;
	import com.settinghead.wenwentu.client.sizers.WordSizer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import org.as3commons.lang.Assert;
	
	import spark.primitives.BitmapImage;

	public class TuVO
	{
		private static const SKIP_REASON_NO_SPACE:int = 1;
		private static const SKIP_REASON_SHAPE_TOO_SMALL:int = 2;
		
		private var _template:TemplateVO;
		private var _words:WordListVO;
		private var _dWords:DisplayWordListVO = new DisplayWordListVO();
		private var _bgImg:Bitmap = null;
		private var _backgroundColor:uint = 0xffffff;
		private var _bgMode:String;
		private var _width:uint, _height:uint;
		private var failedLastVar:Boolean;
		
		//the generated image
		private var _generatedImage:BitmapData = null;
		
		private static const SOLID_COLOR:String = "solidColor";
		private static const BACKGROUND_IMAGE:String = "backgroundImage";
		private var _currentWordIndex:int = -1;
		private var _eWords:Vector.<EngineWordVO> = new Vector.<EngineWordVO>();

		public var indexOffset:int=0;

		
		public function TuVO(template:TemplateVO, words:WordListVO){
			this._template = template;
			this._width = template.width;
			this._height = template.height;
			this._words = WordSorterAndScaler.sortAndScale(words);
			
		}
		
		
		
		public function pushEngineWord(eWord:EngineWordVO):void{
			this._eWords.push(eWord);
		}
		
		public function get dWords():DisplayWordListVO{
			return _dWords;
		}
		
		public function get template():TemplateVO{
			return _template;
		}
		
		public function get backgroundImage():Bitmap{
			switch(this._bgMode)
			{
				case SOLID_COLOR:
					if(this._bgImg==null){
						this._bgImg = 
							new Bitmap(new BitmapData(_width, _height, false, _backgroundColor));
					}
					break;
			}
			return this._bgImg;
		}
		
		public function set backgroundImage(_bmp:Bitmap):void{
			this._bgImg = _bmp;
			this._bgMode = BACKGROUND_IMAGE;
		}
		
		public function set backgroundColor(color:uint):void{
			this.backgroundColor = color;
			this._bgMode = SOLID_COLOR;
		}
		
		public function get width():uint{
			return this.template.width;
		}
		
		public function get height():uint{
			return this.template.height;
		}
		
		public function get words():WordListVO{
			return _words;
		}
		
		public function get finishedDisplayWordRendering():Boolean{
			 return this._currentWordIndex >=  this.words.size;
		}
		
		public function get almostFinishedDisplayWordRendering():Boolean{
			//TODO 
			return this._currentWordIndex >=  this.words.size * 0.9;
		}
		
		
		public function getNextWordAndIncrement():WordVO{
			return words.itemAt(++_currentWordIndex) as WordVO;
		}
		
		public function get currentWordIndex():int{
			return _currentWordIndex;
		}
		
		
		public function get failedLast():Boolean{
			return this.failedLast;
		}
		
		private function calculateMaxAttemptsFromWordWeight(word:WordVO):int {
			
			var result:int = int(((1.0 - word.weight) * 100) )+ 50 + 100*Math.random();
			Assert.isTrue(result>0);
			return result;
		}
		private var successCount:Number = 0, totalCount:Number = 0;
		public function get lossRate():Number{
//			return 1- (successCount)/(totalCount);
			return 0;
		}

		public function generateEngineWord(word:WordVO):EngineWordVO{
			var newIndex:int = this.currentWordIndex+indexOffset<this.words.size?this.currentWordIndex+indexOffset:this.words.size;
			var eWord:EngineWordVO= new EngineWordVO(word, newIndex , this.words.size);
			
			var wordFont:String= template.fonter.fontFor(word);
			var wordSize:Number= template.sizer.sizeFor(word,newIndex,this.words.size);
			var wordAngle:Number= template.angler.angleFor(eWord);
			
			var shape:TextShapeVO= WordShaper.makeShape(word.word, wordSize, wordFont, wordAngle);
			if (shape == null) {
				skipWord(word, SKIP_REASON_SHAPE_TOO_SMALL);
			} else {
				eWord.setShape(shape, template.renderOptions.wordPadding);
			}
						
			return eWord;
		}
		
		private function skipWord(word:WordVO, reason:int):void {
			word.wasSkippedBecause(reason);
		}
		
		public function get generatedImage():BitmapData{
			return this._generatedImage;
		}
		
		public function set generatedImage(img:BitmapData):void{
			this._generatedImage = img;
		}
		
		public function placeWord(eWord:EngineWordVO):Boolean {
			totalCount++;
			this.failedLastVar = false;
			var word:WordVO= eWord.word;
			// these into
			// EngineWord.setDesiredLocation?
			// Does that make
			// sense?
			var wordImageWidth:int= int(eWord.shape.textField.width);
			var wordImageHeight:int= int(eWord.shape.textField.height);
			
			eWord.setDesiredLocation(template.placer, _eWords.length,
				wordImageWidth, wordImageHeight, template.width,
				template.height);
			// Set maximum number of placement trials
			var maxAttemptsToPlace:int= template.renderOptions.maxAttemptsToPlaceWord > 0? template.renderOptions.maxAttemptsToPlaceWord
				: calculateMaxAttemptsFromWordWeight(word);
			
			outer: for each(var candidateLoc:PlaceInfo in eWord.desiredLocation){
				var lastCollidedWith:EngineWordVO = null;
				inner: for (var attempt:int= 0; attempt < maxAttemptsToPlace; attempt++) {
					eWord.nudgeTo(candidateLoc.getpVector().add(template.nudger.nudgeFor(word, candidateLoc,
						attempt,maxAttemptsToPlace)), candidateLoc.patch);
					var angle:Number= template.angler.angleFor(eWord);
					//			eWord.getTree().draw(destination.graphics);
					
					// // TODO
					eWord.getTree().setRotation(angle);
					//
					if (eWord.trespassed(template))
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
					
					for (var i:int= 0; !foundOverlap && i < currentWordIndex; i++) {
						var otherWord:EngineWordVO= _eWords[i];
						if (otherWord.wasSkipped()) continue; //can't overlap with skipped word
						
						if (eWord.overlaps(otherWord)) {
							foundOverlap = true;
							
							lastCollidedWith = otherWord;
							continue inner;
						}
					}
					
					if (!foundOverlap) {
						candidateLoc.patch.mark(wordImageWidth*wordImageHeight, true);
						template.placer.success(eWord.desiredLocation);
						eWord.finalizeLocation();
						successCount++;
						return true;
					}
					
				}
			}
			
			skipWord(eWord.word, SKIP_REASON_NO_SPACE);
			//			info.patch.mark(wordImageWidth*wordImageHeight, true);
			this.template.placer.fail(eWord.desiredLocation);
			this.failedLastVar = true;
			return false;
		}

			
	}
}