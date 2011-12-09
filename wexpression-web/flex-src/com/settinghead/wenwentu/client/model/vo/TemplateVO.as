package com.settinghead.wenwentu.client.model.vo
{

	import com.settinghead.wenwentu.client.RenderOptions;
	import com.settinghead.wenwentu.client.placer.ShapeConfinedPlacer;
	import com.settinghead.wenwentu.client.nudger.ShapeConfinedWordNudger;
	import com.settinghead.wenwentu.client.angler.MostlyHorizAngler;
	import com.settinghead.wenwentu.client.angler.ShapeConfinedAngler;
	import com.settinghead.wenwentu.client.angler.WordAngler;
	import com.settinghead.wenwentu.client.colorer.TwoHuesRandomSatsColorer;
	import com.settinghead.wenwentu.client.colorer.WordColorer;
	import com.settinghead.wenwentu.client.density.DensityPatchIndex;
	import com.settinghead.wenwentu.client.fonter.AlwaysUseFonter;
	import com.settinghead.wenwentu.client.fonter.WordFonter;
	import com.settinghead.wenwentu.client.nudger.WordNudger;
	import com.settinghead.wenwentu.client.placer.WordPlacer;
	import com.settinghead.wenwentu.client.sizers.ByWeightSizer;
	import com.settinghead.wenwentu.client.sizers.WordSizer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.utils.HSBColor;
	
	import org.as3commons.bytecode.util.Assertions;
	import org.as3commons.lang.Assert;
	import org.peaceoutside.utils.ColorMath;
	
	
	[Bindable]
	public class TemplateVO
	{
		private var _thumbnail:BitmapData;
		public var _img:Bitmap;
		var tree:BBPolarRootTreeVO;
		private var _bounds:Rectangle= null;
		private static const SAMPLE_DISTANCE:Number= 25;
		private static const MISS_PERCENTAGE_THRESHOLD:Number= 0.1;
		private var _path:String;
		private var _sizer:WordSizer;
		private var _fonter:WordFonter;
		private var _colorer:WordColorer;
		private var _placer:WordPlacer;
		private var _nudger:WordNudger;
		private var _angler:WordAngler;
		private var _renderOptions:RenderOptions;
		
		// Applet applet = new Applet();
		// Frame frame = new Frame("Roseindia.net");
		
		public function TemplateVO(path:String)
		{
			this._path = path;
		}
		
		public function get thumbnail():BitmapData{			
			if(this._thumbnail ==null && this.img!=null )
				this._thumbnail = createThumbnail(this.img.bitmapData);
			return this._thumbnail;
		}
		
		private static function createThumbnail(bmp:BitmapData):BitmapData{
			return resizeImage(bmp, 100, 100);
		}
		
		private static const IDEAL_RESIZE_PERCENT:Number = .5;
		public static function resizeImage(source:BitmapData, width:uint, height:uint, constrainProportions:Boolean = true):BitmapData
		{
			var scaleX:Number = width/source.width;
			var scaleY:Number = height/source.height;
			if (constrainProportions) {
				if (scaleX > scaleY) scaleX = scaleY;
				else scaleY = scaleX;
			}
			
			var bitmapData:BitmapData = source;
			
			if (scaleX >= 1 && scaleY >= 1) {
				bitmapData = new BitmapData(Math.ceil(source.width*scaleX), Math.ceil(source.height*scaleY), true, 0);
				bitmapData.draw(source, new Matrix(scaleX, 0, 0, scaleY), null, null, null, true);
				return bitmapData;
			}
			
			// scale it by the IDEAL for best quality
			var nextScaleX:Number = scaleX;
			var nextScaleY:Number = scaleY;
			while (nextScaleX < 1) nextScaleX /= IDEAL_RESIZE_PERCENT;
			while (nextScaleY < 1) nextScaleY /= IDEAL_RESIZE_PERCENT;
			
			if (scaleX < IDEAL_RESIZE_PERCENT) nextScaleX *= IDEAL_RESIZE_PERCENT;
			if (scaleY < IDEAL_RESIZE_PERCENT) nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			var temp:BitmapData = new BitmapData(bitmapData.width*nextScaleX, bitmapData.height*nextScaleY, true, 0);
			temp.draw(bitmapData, new Matrix(nextScaleX, 0, 0, nextScaleY), null, null, null, true);
			bitmapData = temp;
			
			nextScaleX *= IDEAL_RESIZE_PERCENT;
			nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			while (nextScaleX >= scaleX || nextScaleY >= scaleY) {
				var actualScaleX:Number = nextScaleX >= scaleX ? IDEAL_RESIZE_PERCENT : 1;
				var actualScaleY:Number = nextScaleY >= scaleY ? IDEAL_RESIZE_PERCENT : 1;
				temp = new BitmapData(bitmapData.width*actualScaleX, bitmapData.height*actualScaleY, true, 0);
				temp.draw(bitmapData, new Matrix(actualScaleX, 0, 0, actualScaleY), null, null, null, true);
				bitmapData.dispose();
				nextScaleX *= IDEAL_RESIZE_PERCENT;
				nextScaleY *= IDEAL_RESIZE_PERCENT;
				bitmapData = temp;
			}
			
			return bitmapData;
		}
		
		
		public function loadTemplate(callback:Function = null){
			var my_loader:Loader = new Loader();
			my_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			if(callback!=null)
				my_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callback);
			my_loader.load(new URLRequest(this._path));
		}
		
		private var done:Function;
		//private var renderer:WordCramRenderer;
		
		private function onLoadComplete (event:Event):void
		{
			this._img = new Bitmap(event.target.content.bitmapData);
			//this.renderer.withConfinementImage(this);
			//			this.tree = BBPolarTreeBuilder.makeTree(this, 0);
		}
		
		public function getBrightness(x:int, y:int):Number {
			//			var rgbPixel : uint = img.bitmapData.getPixel( x, y );
			//			var colour : HSBColor = HSBColor.convertRGBtoHSB( rgbPixel );
			//			return colour.brightness;
			var rgbPixel : uint = img.bitmapData.getPixel( x, y );
			//			var colour : HSBColor = HSBColor.convertRGBtoHSB( rgbPixel );
			var colour : int = ColorMath.RGBtoHSB(rgbPixel);
			//			Assert.isTrue(!isNaN(colour.hue));
			var b:Number= (colour & 0xFF);
			b/=255;
			return b;
		}
		
		public function getHue(x:int, y:int):Number {
			var rgbPixel : int = img.bitmapData.getPixel( x, y );
			//			var colour : HSBColor = HSBColor.convertRGBtoHSB( rgbPixel );
			var colour : int = ColorMath.RGBtoHSB(rgbPixel);
			//			Assert.isTrue(!isNaN(colour.hue));
			var h:Number= ( (colour & 0x00FF0000) >> 16);
			h/=255;
			return h;
		}
		
		public function getHeight():int {
			return img.height;
		}
		
		public function getWidth():int {
			return img.width;
		}
		
		public function getBounds2D():Rectangle {
			
			if (this._bounds == null) {
				var centerX:Number= img.width / 2;
				var centerY:Number= img.height / 2;
				var radius:Number= Math.sqrt(Math.pow(centerX, 2)
					+ Math.pow(centerY, 2));
				var diameter:int= int((radius * 2));
				
				this._bounds = new Rectangle(int((centerX - radius)),
					int((centerY - radius)), diameter, diameter);
			}
			return this._bounds;
		}
		
		public function contains(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
			if (tree == null) {
				// // %1
				// int threshold = (int) (width * height / 1000);
				// int darkCount = 0;
				// for (int i = 0; i < width; i++) {
				// for (int j = 0; j < height; j++) {
				// if (getBrightness((int) (x + i), (int) (y + j)) < 0.01
				// && ++darkCount >= threshold)
				// return false;
				// }
				// }
				// return true;
				
				// sampling approach
				var numSamples:int= int((width * height / SAMPLE_DISTANCE));
				// TODO: devise better lower bound
				if (numSamples < 10)
					numSamples = 10;
				var threshold:int= 5;
				var darkCount:int= 0;
				var i:int= 0;
				while (i < numSamples) {
					var relativeX:int= int((Math.random() * width));
					var relativeY:int= int((Math.random() * height));
					var sampleX:int= relativeX + x;
					var sampleY:int= relativeY + y;
					var brightness:Number = getBrightness(sampleX, sampleY);
					if (brightness < 0.01&& ++darkCount >= threshold)
						return false;
					i++;
				}
				
				return true;
				
			} else {
				return tree.contains(x, y, x + width, y + height);
			}
		}
		
		
		public function containsPoint(x:Number, y:Number,transformed:Boolean):Boolean{
			return img.hitTestPoint(x,y,true);
		}
		
		public function intersects(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
			if (tree == null) {
				var threshold:int= 10;
				var darkCount:int= 0;
				var brightCount:int= 0;
				// for (int i = 0; i < width; i++) {
				// for (int j = 0; j < height; j++) {
				// if (getBrightness((int) (x + i), (int) (y + j)) < 0.01)
				// darkCount++;
				// else
				// brightCount++;
				// if (darkCount >= threshold && brightCount >= threshold)
				// return true;
				// }
				// }
				// return false;
				
				var numSamples:int= int((width * height / SAMPLE_DISTANCE));
				// TODO: devise better lower bound
				if (numSamples < 4)
					numSamples = 4;
				
				var i:int= 0;
				while (i < numSamples) {
					var relativeX:int= int((Math.random() * width));
					var relativeY:int= int((Math.random() * height));
					var sampleX:int= int((relativeX + x));
					var sampleY:int= int((relativeY + y));
					if (getBrightness(int((sampleX)), int((sampleY))) < 0.01)
						darkCount++;
					else
						brightCount++;
					if (darkCount >= threshold && brightCount >= threshold)
						return true;
					i++;
				}
				
				return false;
			} else {
				return tree.overlapsCoord(x, y, x + width, y + height);
			}
		}
		
		public function translate(tx:Number, ty: Number):void{
			var mtx: Matrix = img.transform.matrix;
			mtx.translate(tx,ty);
			img.transform.matrix = mtx;
		}
		
		public function get shape():DisplayObject{
			return img;
		}
		
		public function get object():DisplayObject{
			return img;
		}
		
		public function get img():Bitmap{
			if(this._img == null)
				this.loadTemplate();
			return _img;
		}
		
		public function get path():String{
			return this._path;
		}
		
		public function set path(p:String):void{
			this._path = path;
		}
		
		public function get width():Number{
			return _img.width;
		}
		public function get height():Number{
			return _img.height;
		}
		
		public function get sizer():WordSizer{
			if(this._sizer==null){
				this._sizer = new ByWeightSizer(8,35);
			}
			return this._sizer;
		}
		
		public function get fonter():WordFonter{
			if(this._fonter==null){
				this._fonter = new AlwaysUseFonter("Velo");
			}
			return this._fonter;
		}
		
		public function get colorer():WordColorer{
			if(this._colorer==null){
				this._colorer = new TwoHuesRandomSatsColorer();
			}
			return this._colorer;
		}
		
		public function get placer():WordPlacer{
			if(this._placer==null){
				this._placer = new ShapeConfinedPlacer(this, new DensityPatchIndex(this));
			}
			return this._placer;
		}
		
		public function get nudger():WordNudger{
			if(this._nudger==null){
				this._nudger = new ShapeConfinedWordNudger();
			}
			return this._nudger;
		}
		
		public function get angler():WordAngler{
			if(this._angler==null){
				this._angler = new ShapeConfinedAngler(this, new MostlyHorizAngler());
			}
			return this._angler;
		}
		
		public function get renderOptions():RenderOptions{
			if(this._renderOptions==null){
				this._renderOptions = new RenderOptions();
			}
			return this._renderOptions;
		}
		
	}
}