/**
 * 
 */
package com.settinghead.wenwentu.client {
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
	
	/**
	 * @author settinghead
	 * 
	 */
	public class TemplateImage implements ImageShape {
		public var _img:Bitmap;
		var tree:BBPolarRootTree;
		private var _bounds:Rectangle= null;
		private static const SAMPLE_DISTANCE:Number= 25;
		private static const MISS_PERCENTAGE_THRESHOLD:Number= 0.1;
	
		private var _path:String;
		// Applet applet = new Applet();
		// Frame frame = new Frame("Roseindia.net");
	
		public function TemplateImage(path:String) {
			this._path = path;
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
		
		public function get objectWidth():Number{
			return _img.width;
		}
		public function get objectHeight():Number{
			return _img.height;
		}
	}
}