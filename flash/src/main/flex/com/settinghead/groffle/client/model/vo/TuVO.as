package com.settinghead.groffle.client.model.vo
{	
	import com.settinghead.groffle.client.model.vo.template.IWithEffectiveBorder;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordSorterAndScaler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	[Event(name="failureCountChanged", type="flash.events.Event")]

	public class TuVO extends EventDispatcher implements IWithEffectiveBorder
	{
		private var _template:TemplateVO;
		private var _words:WordListVO;
		private var _dWords:DisplayWordListVO = new DisplayWordListVO();
		private var _bgImg:Bitmap = null;
		private var _backgroundColor:uint = 0xffffff;
		private var _bgMode:String;
		private var _width:uint, _height:uint;
//		private var failedLastVar:Boolean;
		private var _failureCount:int = 0;
		
		//the generated image
		private var _generatedImage:BitmapData = null;
		
		private static const SOLID_COLOR:String = "solidColor";
		private static const BACKGROUND_IMAGE:String = "backgroundImage";
		private var _eWords:Vector.<EngineWordVO> = new Vector.<EngineWordVO>();

		public static const FAILURE_COUNT_CHANGED:String = "failureCountChanged";

		
		public function TuVO(template:TemplateVO, words:WordListVO){
			this._template = template;
			this._width = template.width;
			this._height = template.height;

			this._words = WordSorterAndScaler.sortAndScale(words);
			
		}
		
		[Bindable(event="failureCountChanged")]
		public function get failureCount():int{
			return _failureCount;
		}
		
		public function set failureCount(v:int):void{
			_failureCount = v;
			dispatchEvent(new Event("failureCountChanged"));

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
		
		public function generateEffectiveBorder():void{
			template.generateEffectiveBorder();
		}
		public function get effectiveBorder():Rectangle{
			return template.effectiveBorder;
		}

	}
}