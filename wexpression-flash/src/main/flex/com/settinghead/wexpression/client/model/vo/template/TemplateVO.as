package com.settinghead.wexpression.client.model.vo.template
{

	import com.adobe.serializers.json.JSONEncoder;
	import com.settinghead.wexpression.client.RenderOptions;
	import com.settinghead.wexpression.client.angler.MostlyHorizAngler;
	import com.settinghead.wexpression.client.angler.ShapeConfinedAngler;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.colorer.ColorSheetColorer;
	import com.settinghead.wexpression.client.colorer.TwoHuesRandomSatsColorer;
	import com.settinghead.wexpression.client.colorer.WordColorer;
	import com.settinghead.wexpression.client.density.DensityPatchIndex;
	import com.settinghead.wexpression.client.fonter.AlwaysUseFonter;
	import com.settinghead.wexpression.client.fonter.WordFonter;
	import com.settinghead.wexpression.client.model.vo.BBPolarRootTreeVO;
	import com.settinghead.wexpression.client.model.vo.IImageShape;
	import com.settinghead.wexpression.client.model.vo.IZipInput;
	import com.settinghead.wexpression.client.model.vo.IZipOutput;
	import com.settinghead.wexpression.client.model.vo.IZippable;
	import com.settinghead.wexpression.client.nudger.ShapeConfinedRandomWordNudger;
	import com.settinghead.wexpression.client.nudger.ShapeConfinedSpiralWordNudger;
	import com.settinghead.wexpression.client.nudger.ShapeConfinedZigZagWordNudger;
	import com.settinghead.wexpression.client.nudger.WordNudger;
	import com.settinghead.wexpression.client.placer.ShapeConfinedPlacer;
	import com.settinghead.wexpression.client.placer.WordPlacer;
	import com.settinghead.wexpression.client.sizers.ByWeightSizer;
	import com.settinghead.wexpression.client.sizers.WordSizer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.utils.HSBColor;
	
	import org.as3commons.bytecode.util.Assertions;
	import org.as3commons.lang.Assert;
	import org.as3commons.logging.util.jsonXify;
	import org.peaceoutside.utils.ColorMath;
	
	
	[Bindable]
	public class TemplateVO implements IZippable
	{
		private var tree:BBPolarRootTreeVO;
		private var _bounds:Rectangle= null;
		private static const SAMPLE_DISTANCE:Number= 100;
		private static const MISS_PERCENTAGE_THRESHOLD:Number= 0.1;
		private var _path:String;
		private var _sizer:WordSizer;
		private var _fonter:WordFonter;
		private var _colorer:WordColorer;
		private var _placer:WordPlacer;
		private var _nudger:WordNudger;
		private var _angler:WordAngler;
		private var _renderOptions:RenderOptions;
//		private var hsbArray:Array;
		private var _patchIndex:DensityPatchIndex;
		private var _width:Number, _height:Number;
		private var _previewPNG: ByteArray;
		public var mixColorDistance:int = 5;
		public var dilligence:int = 10;

		// Applet applet = new Applet();
		// Frame frame = new Frame("Roseindia.net");
		private var _layers:ArrayCollection =  new ArrayCollection();
		
		public function TemplateVO(path:String)
		{
			this._path = path;
		}
		
		public function get layers():ArrayCollection{
			return this._layers;
		}
		
		public function get path():String{
			return _path;
		}
		
		public function get width():Number{
			if(isNaN(_width)){
				var maxWidth:Number = 0;
				for each(var l:Layer in layers)
					if(maxWidth < l.width) maxWidth = l.width;
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
				if(maxHeight < l.height) maxHeight = l.height;
				if(maxHeight > 0) _height = maxHeight; 
			}
			return _height;
		}
		
		public function set height(v:Number):void{
			_height = v;
		}
		
		public function get previewPNG():ByteArray{
			return _previewPNG;
		}
		
		public function set previewPNG(p:ByteArray):void{
			 _previewPNG = p;
		}
		
		public function get patchIndex():DensityPatchIndex{
			return this._patchIndex;
		}
		
		public function get placer():WordPlacer{
			if(this._placer==null){
				this._placer = new ShapeConfinedPlacer(this, _patchIndex);
			}
			return this._placer;
		}
		
		public function get sizer():WordSizer{
			if(this._sizer==null){
				this._sizer = new ByWeightSizer(14,100);
			}
			return this._sizer;
		}

		public function get fonter():WordFonter{
			if(this._fonter==null){
				this._fonter = new AlwaysUseFonter("Vera");
			}
			return this._fonter;
		}
		
		
		public function get colorer():WordColorer{
			if(this._colorer==null){
				this._colorer = new ColorSheetColorer();
			}
			return this._colorer;
		}
		
		public function get nudger():WordNudger{
			if(this._nudger==null){
//								this._nudger = new ShapeConfinedSpiralWordNudger();
				//				this._nudger = new ShapeConfinedRandomWordNudger();
				this._nudger = new ShapeConfinedZigZagWordNudger();
				
			}
			return this._nudger;
		}
		
		public function get renderOptions():RenderOptions{
			if(this._renderOptions==null){
				this._renderOptions = new RenderOptions();
			}
			return this._renderOptions;
		}
		
		public function onLoadComplete (event:Event):void
		{
			this._patchIndex = new DensityPatchIndex(this);
		}
		
		public function writeNonJSONPropertiesToZip(output:IZipOutput):void {
			output.putBytesToFile("preview.png", previewPNG);
			output.process(this.layers, "layers");
			output.process(this.fonter, "fonter");
			output.process(this.sizer, "sizer");
			output.process(this.colorer, "colorer");
//			output.process(this._nudger, "nudger");
//			output.process(this._angler, "angler");
//			output.process(this._placer, "placer");
			output.process(this.renderOptions, "renderOptions");
		}
		
		public function readNonJSONPropertiesFromZip(input:IZipInput): void{
			
		}
		
		public function saveProperties(dict:Object):void{
			dict.path = this._path;
			dict.width = this._width;
			dict.height = this._height;
			dict.dilligence = this.dilligence;
		}
		
	}
}