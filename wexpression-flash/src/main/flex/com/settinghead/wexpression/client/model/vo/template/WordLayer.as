package com.settinghead.wexpression.client.model.vo.template
{
	import com.settinghead.wexpression.client.RenderOptions;
	import com.settinghead.wexpression.client.angler.MostlyHorizAngler;
	import com.settinghead.wexpression.client.angler.ShapeConfinedAngler;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.colorer.TwoHuesRandomSatsColorer;
	import com.settinghead.wexpression.client.colorer.WordColorer;
	import com.settinghead.wexpression.client.density.DensityPatchIndex;
	import com.settinghead.wexpression.client.fonter.AlwaysUseFonter;
	import com.settinghead.wexpression.client.fonter.WordFonter;
	import com.settinghead.wexpression.client.model.vo.BBPolarRootTreeVO;
	import com.settinghead.wexpression.client.model.vo.IImageShape;
	import com.settinghead.wexpression.client.model.zip.IZipInput;
	import com.settinghead.wexpression.client.model.zip.IZipOutput;
	import com.settinghead.wexpression.client.model.zip.IZippable;
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
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.controls.Alert;
	import mx.utils.HSBColor;
	
	import org.as3commons.bytecode.util.Assertions;
	import org.as3commons.lang.Assert;
	import org.peaceoutside.utils.ColorMath;
	
	[Bindable]
	public class WordLayer extends Layer implements IImageShape, IZippable
	{
		public function WordLayer(name:String, template:TemplateVO, width:Number = -1, height:Number = -1, autoAddAndConnect:Boolean = true)
		{
			super(name, template, autoAddAndConnect);
			if(width>0 && height>0){
				this._img = new Bitmap(new BitmapData(width, height,true, 0xccc));
			}
		}
		
		private var _img:Bitmap;
		private var _colorSheet:Bitmap;
		private var _tree:BBPolarRootTreeVO;
		private var _bounds:Rectangle= null;
		public static const SAMPLE_DISTANCE:Number= 100;
		private static const MISS_PERCENTAGE_THRESHOLD:Number= 0.1;
		private var _path:String;
		private var _colorer:WordColorer;
		private var _nudger:WordNudger;
		private var _angler:WordAngler;
//		private var hsbArray:Array;
		// Applet applet = new Applet();
		// Frame frame = new Frame("Roseindia.net");
		
		private var _fonter:WordFonter = null;
		public function get fonter():WordFonter{
			if(this._fonter==null){
				return this._template.fonter;
			}
			else return this._fonter;
		}
		
		private var _placer:WordPlacer;
		public function get colorer():WordColorer{
			if(this._colorer==null){
				return this._template.colorer;
			}
			else return this._colorer;
		}
		
		
		public function get thumbnail():BitmapData{			
			if(this._thumbnail ==null && this.directionBitmap!=null )
				this._thumbnail = createThumbnail(this.directionBitmap.bitmapData);
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
		
		
		
		
		public function getHSB(x:int, y:int):int{
//			if(this.hsbArray[x]==null)
//				this.hsbArray[x] = new Array(this._img.height);
//			if(this.hsbArray[x][y]==null){
//				var rgbPixel : uint = _img.bitmapData.getPixel32( x, y );
//				var alpha:uint = rgbPixel>> 24 & 0xFF;
//				if(alpha == 0) {
//					hsbArray[x][y]  = NaN;
//					return NaN;
//				}
//				else {
//					var colour:int =  ColorMath.RGBtoHSB(rgbPixel);
//					hsbArray[x][y] = colour;
//					return colour;
//				}
//			}
//			return this.hsbArray[x][y];
			
			var rgbPixel : uint = _img.bitmapData.getPixel32( x, y );
			var alpha:uint = rgbPixel>> 24 & 0xFF;
			if(alpha == 0) {
				return NaN;
			}
			else {
				var colour:int =  ColorMath.RGBtoHSB(rgbPixel);
				return colour;
			}
		}
		
		public function getBrightness(x:int, y:int):Number {
			
			var rgbPixel : uint = _img.bitmapData.getPixel32( x, y );
			var alpha:uint = rgbPixel>> 24 & 0xFF;
			if(alpha == 0) {
				return NaN;
			}
			return ColorMath.getBrightness(rgbPixel);
		}
		
		public function getHue(x:int, y:int):Number {
			var colour : int = getHSB(x,y);
			//			Assert.isTrue(!isNaN(colour.hue));
			var h:Number= ( (colour & 0x00FF0000) >> 16);
			h/=255;
			return h;
		}
		
		public override function get height():Number {
			return directionBitmap.height;
		}
		
		public override function get width():Number {
			return directionBitmap.width;
		}
		
		public function getBounds2D():Rectangle {
			
			if (this._bounds == null) {
				var centerX:Number= directionBitmap.width / 2;
				var centerY:Number= directionBitmap.height / 2;
				var radius:Number= Math.sqrt(Math.pow(centerX, 2)
					+ Math.pow(centerY, 2));
				var diameter:int= int((radius * 2));
				
				this._bounds = new Rectangle(int((centerX - radius)),
					int((centerY - radius)), diameter, diameter);
			}
			return this._bounds;
		}
		
		public override function contains(x:Number, y:Number, width:Number, height:Number, rotation:Number, transformed:Boolean):Boolean {
			if (_tree == null) {
				// sampling approach
				var numSamples:int= int((width * height / SAMPLE_DISTANCE));
				//				var numSamples = 10;
				// TODO: devise better lower bound
				if (numSamples < 20)
					numSamples = 20;
				var threshold:int= 1;
				var darkCount:int= 0;
				var i:int= 0;
				while (i < numSamples) {
					var relativeX:int= int((Math.random() * width));
					var relativeY:int= int((Math.random() * height));
					
					//rotation
					rotation = - rotation;
					
					if(rotation!=0){
					
	//					Alert.show(rotation.toString());
						if(relativeX==0) relativeX = 0.001;
						relativeX = (relativeX - width/2);
						relativeY = (relativeY - height/2);
						
						var r:Number = Math.sqrt(Math.pow(relativeX, 2)+Math.pow(relativeY, 2));
						var theta:Number = Math.atan2(relativeY, relativeX);
						theta += rotation;
	
						relativeX = r * Math.cos(theta);
						relativeY = r * Math.sin(theta);
						
	//					relativeX = (relativeX * Math.cos(rotation))
	//						- (relativeY * Math.sin(rotation));
	//					relativeY = Math.sin(rotation) * relativeX
	//						+ Math.cos(rotation ) * relativeY;
						
						relativeX = (relativeX + width/2);
						relativeY = (relativeY + height/2);
					}
					var sampleX:int= relativeX + x;
					var sampleY:int= relativeY + y;
					
					var brightness:Number = getBrightness(sampleX, sampleY);
					if ((isNaN(brightness) || brightness < 0.01) && ++darkCount >= threshold)
//											if ((!containsPoint(sampleX, sampleY, false)) && ++darkCount >= threshold)
						return false;
					i++;
				}
				
				return true;
				
			} else {
				return _tree.overlapsCoord(x, y, x + width, y + height);
			}
		}
		
		
		public override function containsPoint(x:Number, y:Number, transform:Boolean,  refX:Number,refY:Number, tolerance:Number):Boolean{
			
			//a layer above contains this point which covers the current layer
			if(aboveContainsPoint(x,y,transform,refX,refY,1.0)) return false;
//			if(x<0 || y<0 || x>width || y>height) return true;
			if(x<0||y<0||x>directionBitmap.width||y>directionBitmap.height)
				return false;
			if(!directionBitmap.hitTestPoint(x,y,true) &&
				//not transparent
				((color.getPixel32(x,y) >> 24 &0xff)!=0)){
				if(tolerance>=1) return true;
				else return (ColorMath.dist(color.getPixel32(x,y), 
						color.getPixel32(refX,refY)) <= tolerance
						&&
					ColorMath.dist(direction.getPixel32(x,y), 
						direction.getPixel32(refX,refY)) <= tolerance);
			}
			else return false;
		}
		
		public override function intersects(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
			if (_tree == null) {
				var threshold:int= 10;
				var darkCount:int= 0;
				var brightCount:int= 0;
				
				var numSamples:int= int((width * height / SAMPLE_DISTANCE));
				// TODO: derive better lower bound
				if (numSamples < 10)
					numSamples = 10;
				
				var i:int= 0;
				while (i < numSamples) {
					var relativeX:int= int((Math.random() * width));
					var relativeY:int= int((Math.random() * height));
					var sampleX:int= int((relativeX + x));
					var sampleY:int= int((relativeY + y));
					if (isNaN(getBrightness(int((sampleX)), int((sampleY)))))
						//					if(!containsPoint(sampleX, sampleY, false))
						darkCount++;
					else
						brightCount++;
					if (darkCount >= threshold && brightCount >= threshold)
						return true;
					i++;
				}
				
				return false;
				
			} else {
				return _tree.overlapsCoord(x, y, x + width, y + height);
			}
		}
		
		public function translate(tx:Number, ty: Number):void{
			var mtx: Matrix = directionBitmap.transform.matrix;
			mtx.translate(tx,ty);
			directionBitmap.transform.matrix = mtx;
		}

		
		public function get directionBitmap():Bitmap{
			if(this._img == null){
				if(path!=null)
					this.loadLayerFromPNG();
				else{
					this._img = new Bitmap(new BitmapData(this._template.width, this._template.height,true, 0));
				}
			}
			return _img;
		}
		
		public function get direction():BitmapData{
			return directionBitmap.bitmapData;
		}
		
		public function set direction(d:BitmapData):void{
			this.directionBitmap = new Bitmap(d);
		}
		
		public function set directionBitmap(bmp:Bitmap):void{
			this._img = bmp;
//			var inverseLayer:InverseWordLayer = new InverseWordLayer(this);
//			this._tree = new BBPolarRootTreeVO(inverseLayer, 0, 0, 
//				Math.sqrt(Math.pow(inverseLayer.width/2, 2) + Math.pow(inverseLayer.width/2, 2)), 20); 
		}
		
		public function set colorSheet(bmp:Bitmap):void{
			this._colorSheet = bmp;
		}
		
		public function get colorSheet():Bitmap{
			if(this._colorSheet == null){
				this._colorSheet = new Bitmap(new BitmapData(this._template.width, this._template.height,true, 0));
			}
			return _colorSheet;
		}
		
		public function get color():BitmapData{
			return colorSheet.bitmapData;
		}
		
		public function set color(d:BitmapData):void{
			this.colorSheet = new Bitmap(d);
		}
		
		public function get path():String{
			return this._path;
		}
		
		public function set path(p:String):void{
			this._path = p;
		}

		
		public function get nudger():WordNudger{
			if(this._nudger==null){
				return _template.nudger;				
			}
			else return this._nudger;
		}
		
		public function get angler():WordAngler{
			if(this._angler==null){
				this._angler = new ShapeConfinedAngler(this, new MostlyHorizAngler());
			}
			return this._angler;
		}
		
		
		public function loadLayerFromPNG(callback:Function = null):void{
			var my_loader:Loader = new Loader();
			
			my_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			if(callback!=null)
				my_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callback);
			
			my_loader.load(new URLRequest(this._path));
		}
		
		private function onLoadComplete (event:Event):void
		{
			this._img = new Bitmap(event.target.content.bitmapData);
//			this.hsbArray = new Array(this._img.width);
			this._template.onLoadComplete(event);
		}
		
		public override function writeNonJSONPropertiesToZip(output:IZipOutput):void {
			output.process(this._fonter, "fonter");
			output.process(this._colorer, "colorer");
			output.putBitmapDataToPNGFile("direction.png", this.direction);
			output.putBitmapDataToPNGFile("color.png", this.color);
			//			output.process(this._nudger, "nudger");
			//			output.process(this._angler, "angler");
			//			output.process(this._placer, "placer");
		}
		
		public override function readNonJSONPropertiesFromZip(input:IZipInput): void{
			//TODO	
		}
		
		public override function saveProperties(dict:Object):void{
		}
		
		public override function get type():String{
			return "WordLayer";
		}
		public override function set type(t:String):void{
			//dummy method; do nothing 
		}
		
	}
}