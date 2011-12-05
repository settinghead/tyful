package com.settinghead.wenwentu.client.model.vo
{	
	import com.settinghead.wenwentu.client.PlaceInfo;
	import com.settinghead.wenwentu.client.RenderOptions;
	import com.settinghead.wenwentu.client.WordShaper;
	import com.settinghead.wenwentu.client.angler.WordAngler;
	import com.settinghead.wenwentu.client.fonter.WordFonter;
	import com.settinghead.wenwentu.client.sizers.WordSizer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import spark.primitives.BitmapImage;

	public class TuVO
	{
		private static const SKIP_REASON_NO_SPACE:int = 0;
		private static const SKIP_REASON_SHAPE_TOO_SMALL:int = 1;
		
		private var _template:TemplateVO;
		private var _words:WordListVO;
		private var _dWords:DisplayWordListVO = new DisplayWordListVO();
		private var _bgImg:Bitmap = null;
		private var _backgroundColor:uint = 0xffffff;
		private var _bgMode:String;
		private var _width:uint, _height:uint;
		private var failedLastVar:Boolean;
		
		private static const SOLID_COLOR:String = "solidColor";
		private static const BACKGROUND_IMAGE:String = "backgroundImage";
		private var _currentWordIndex:int = 0;
		private var _eWords:Vector.<EngineWordVO> = new Vector.<EngineWordVO>();

		public function TuVO(template:TemplateVO, words:WordListVO){
			this._width = width;
			this._height = height;
			this._words = words;
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
			 return this._currentWordIndex >=  this.words.length;
		}
		
		public function getNextWordAndIncrement():WordVO{
			return words.getItemAt(_currentWordIndex++) as WordVO;
		}
		
		public function get currentWordIndex():int{
			return _currentWordIndex;
		}
		
		
		public function get failedLast():Boolean{
			return this.failedLast;
		}
		
		private function calculateMaxAttemptsFromWordWeight(word:WordVO):int {
			return int(((1.0 - word.weight) * 600) )+ 100;
		}
		
		public function placeWord(eWord:EngineWordVO):Boolean {
			this.failedLastVar = false;
			var word:WordVO= eWord.word;
			// these into
			// EngineWord.setDesiredLocation?
			// Does that make
			// sense?
			var wordImageWidth:int= int(eWord.getTree().getWidth(true));
			var wordImageHeight:int= int(eWord.getTree().getHeight(true));
			
			var info:PlaceInfo= eWord.setDesiredLocation(template.placer, _eWords.length,
				wordImageWidth, wordImageHeight, template.width,
				template.height);
			
			// Set maximum number of placement trials
			var maxAttemptsToPlace:int= template.renderOptions.maxAttemptsToPlaceWord > 0? template.renderOptions.maxAttemptsToPlaceWord
				: calculateMaxAttemptsFromWordWeight(word);
			
			var lastCollidedWith:EngineWordVO = null;
			
			outer: for (var attempt:int= 0; attempt < maxAttemptsToPlace; attempt++) {
				
				eWord.nudge(template.nudger.nudgeFor(word, eWord.getCurrentLocation(),
					attempt));
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
						continue outer;
					}
				}
				
				if (!foundOverlap) {
					//eWord.getTree().draw(applet.getGraphics());
					// eWord.setShape(WordShaper.rotate(eWord.getShape(), eWord
					// .getTree().getRotation(), (float) eWord.getTree()
					// .getRootX(), (float) eWord.getTree().getRootY()), 0);
					template.placer.success(info.getReturnedObj());
					eWord.finalizeLocation();
					return true;
				}
				
			}
			
			skipWord(eWord.word, SKIP_REASON_NO_SPACE);
			template.placer.fail(info.getReturnedObj());
			this.failedLastVar = true;
			trace("failed:", info.getpVector());
			return false;
		}

		public function generateEngineWord(word:WordVO):EngineWordVO{
			var eWord:EngineWordVO= new EngineWordVO(word, this.currentWordIndex , this.words.length);
			
			var wordFont:String= template.fonter.fontFor(word);
			var wordSize:Number= template.sizer.sizeFor(word,currentWordIndex,this.words.length);
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
			
	}
}