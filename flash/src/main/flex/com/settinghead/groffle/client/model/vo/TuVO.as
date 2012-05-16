package com.settinghead.groffle.client.model.vo
{	
	import com.settinghead.groffle.client.PlaceInfo;
	import com.settinghead.groffle.client.RenderOptions;
	import com.settinghead.groffle.client.WordShaper;
	import com.settinghead.groffle.client.WordSorterAndScaler;
	import com.settinghead.groffle.client.angler.WordAngler;
	import com.settinghead.groffle.client.density.Patch;
	import com.settinghead.groffle.client.fonter.WordFonter;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	import com.settinghead.groffle.client.sizers.WordSizer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.controls.Alert;
	
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IIterator;
	
	import spark.primitives.BitmapImage;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordVO;

	public class TuVO
	{

		private var _template:TemplateVO;
		private var _words:WordListVO;
		private var _dWords:DisplayWordListVO = new DisplayWordListVO();
		private var _bgImg:Bitmap = null;
		private var _backgroundColor:uint = 0xffffff;
		private var _bgMode:String;
		private var _width:uint, _height:uint;
//		private var failedLastVar:Boolean;
		
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

		public function get eWords():Vector.<EngineWordVO>{
			return this._eWords;
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
		
		public function getNextWordAndIncrement():WordVO{
			return words.itemAt(++_currentWordIndex % words.size) as WordVO;
		}
		
		public function get currentWordIndex():int{
			return _currentWordIndex;
		}
		
		
		public function get failedLast():Boolean{
			return this.failedLast;
		}
		
	
//		[Bindable] private var successCount:Number = 0, totalCount:Number = 0;
//		public function get lossRate():Number{
//			return 1- (successCount)/(totalCount);
////			return 0;
//		}

		
		public function get generatedImage():BitmapData{
			return this._generatedImage;
		}
		
		public function set generatedImage(img:BitmapData):void{
			this._generatedImage = img;
		}
		
	
	}
}