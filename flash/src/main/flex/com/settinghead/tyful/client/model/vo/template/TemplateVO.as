package com.settinghead.tyful.client.model.vo.template
{

	import com.settinghead.tyful.client.colorer.ColorSheetColorer;
	import com.settinghead.tyful.client.colorer.WordColorer;
	import com.settinghead.tyful.client.fonter.RandomSetFonter;
	import com.settinghead.tyful.client.fonter.WordFonter;
	import com.settinghead.tyful.client.model.zip.IZipInput;
	import com.settinghead.tyful.client.model.zip.IZipOutput;
	import com.settinghead.tyful.client.model.zip.IZippable;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;	
	
	[Bindable]
	public class TemplateVO implements IZippable, IWithEffectiveBorder
	{
		public static const DEFAULT_WIDTH:int = 900;
		public static const DEFAULT_HEIGHT:int = 900;
		
		
//		private var tree:BBPolarRootTreeVO;
		private var _bounds:Rectangle= null;
		private static const SAMPLE_DISTANCE:Number = 100;
		private static const MISS_PERCENTAGE_THRESHOLD:Number= 0.1;
		private var _fonter:WordFonter;
		private var _colorer:WordColorer;
		private var _renderOptions:RenderOptions;
//		private var hsbArray:Array;
		private var _width:Number, _height:Number;
		private var _previewPNG: BitmapData;
		public var mixColorDistance:int = 5;
		public var perseverance:int = 30;
		public var diligence:int = 8;
		public var id:String = null;
		public var uuid:String = null;
		private var _effectiveBorder:Rectangle = null;
		private var _tolerance:Number = 1;
		
		// Applet applet = new Applet();
		// Frame frame = new Frame("Roseindia.net");
		private var _layers:ArrayCollection =  new ArrayCollection();
		
		public function TemplateVO()
		{
			_layers.addEventListener(CollectionEvent.COLLECTION_CHANGE, layersChanged);

		}
		
		
		public function get layers():ArrayCollection{
			return this._layers;
		}

		private var connecting:Boolean = false;
		public function connectLayers():void{
			if(!connecting){
				connecting = true;
				for(var i:int=0;i<layers.length;i++){
					(layers[i] as Layer).above = null;
					(layers[i] as Layer).below = null;
					if(i>0) Layer.connect( (layers[i] as Layer),(layers[i-1] as Layer)); 
				}
				connecting = false;
			}
			
		}

		
		public function removeLayerAt(index:int):void{
			if(index>0)
				(layers[index-1] as Layer).above = null;
			if(index<layers.length-1)
				(layers[index+1] as Layer).below = null;
			if(index>0 && index<layers.length-1)
					Layer.connect(layers[index+1],layers[index-1]);
			layers.removeItemAt(index);
		}
		
		private function layersChanged(e:Event):void{
			connectLayers();
		}
		
		public function get width():Number{
			if(isNaN(_width)){
				var maxWidth:Number = 0;
				for each(var l:Layer in layers)
					if(maxWidth < l.getWidth()) maxWidth = l.getWidth();
				if(maxWidth > 0) _width = maxWidth; 
			}
			return _width;
		}
		
		public function set width(v:Number):void{
			 _width = v;
		}
		
		public function get height():Number{
			if(isNaN(_height)){
				var maxHeight:Number = 0;
				for each(var l:Layer in layers)
				if(maxHeight < l.getHeight()) maxHeight = l.getHeight();
				if(maxHeight > 0) _height = maxHeight; 
			}
			return _height;
		}
		
		public function set height(v:Number):void{
			_height = v;
		}
		
		public function get preview():BitmapData{
			return _previewPNG;
		}
		
		public function set preview(p:BitmapData):void{
			 _previewPNG = p;
		}
		
		public function get tolerance():Number 
		{
			return _tolerance;
		}
		
		public function set tolerance(value:Number):void 
		{
			_tolerance = value;
		}
		
		public function generateEffectiveBorder():void{
			var left:Number=Number.MAX_VALUE,
				top:Number=Number.MAX_VALUE,
				bottom:Number=Number.MIN_VALUE, 
				right:Number=Number.MIN_VALUE; 
			for each(var l:Layer in layers){
				l.generateEffectiveBorder();
				 var rect:Rectangle = l.effectiveBorder;
				 if(rect.x < left)
					 left = rect.x;
				 if(rect.y < top)
					 top = rect.y;
				 if(rect.right > right)
					 right = rect.right;
				 if(rect.bottom > bottom)
					 bottom = rect.bottom;
			}
			this._effectiveBorder = new Rectangle(left, top, right-left, bottom-top);
		}
		
		public function get effectiveBorder():Rectangle{
			if(this._effectiveBorder==null)
				generateEffectiveBorder();
				return this._effectiveBorder;
		}


		public function get fonter():WordFonter{
			if(this._fonter==null){
				this._fonter = new RandomSetFonter();
			}
			return this._fonter;
		}
		
		
		public function get colorer():WordColorer{
			if(this._colorer==null){
				this._colorer = new ColorSheetColorer();
			}
			return this._colorer;
		}
		
		public function get renderOptions():RenderOptions{
			if(this._renderOptions==null){
				this._renderOptions = new RenderOptions();
			}
			return this._renderOptions;
		}
		
//		public function onLoadComplete (event:Event):void
//		{
////			this._patchIndex = new DensityPatchIndex(this);
//		}
		
		public function writeNonJSONPropertiesToZip(output:IZipOutput):void {
			output.putBitmapDataToPNGFile("preview.png", preview);
//			output.putBitmapDataToJPEGFile("preview.jpg", preview);
			output.process(this.layers, "layers");
			output.process(this.fonter, "fonter");
			output.process(this.colorer, "colorer");
			output.process(this.renderOptions, "renderOptions");
		}
		
		public function readNonJSONPropertiesFromZip(input:IZipInput): void{
			
		}
		
		public function saveProperties(dict:Object):void{
			dict.width = this._width;
			dict.height = this._height;
			dict.perseverance = this.perseverance;
			dict.diligence = this.diligence;
		}
		
		public function get type():String{
			return "Template";
		}
		
		public function set type(t:String):void{
			//dummy method; do nothing 
		}
		
	}
}