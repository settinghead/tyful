/**
 * 
 */
package com.settinghead.wexpression.client {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.utils.HSBColor;
	
	import org.peaceoutside.utils.ColorMath;
	
	/**
	 * @author settinghead
	 * 
	 */
	public class TemplateImage extends Sprite implements ImageShape {
		public var img:BitmapData;
		var tree:BBPolarRootTree;
		private var _bounds:Rectangle= null;
		private static const SAMPLE_DISTANCE:Number= 25;
		private static const MISS_PERCENTAGE_THRESHOLD:Number= 0.1;
	
		// Applet applet = new Applet();
		// Frame frame = new Frame("Roseindia.net");
	
		public function TemplateImage(path:String) {
			var my_loader:Loader = new Loader();
			my_loader.load(new URLRequest(path));
			img = Bitmap(my_loader.content).bitmapData;
		}
		
		public function getBrightness(x:int, y:int):Number {
			var rgbPixel : uint = img.getPixel( x, y );
			var colour : HSBColor = HSBColor.convertRGBtoHSB( rgbPixel );
			return colour.brightness;
		}
	
		public function getHue(x:int, y:int):Number {
			var rgbPixel : uint = img.getPixel( x, y );
			var colour : HSBColor = HSBColor.convertRGBtoHSB( rgbPixel );
			return colour.brightness;
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
	
		public function contains(x:Number, y:Number, width:Number, height:Number):Boolean {
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
					var sampleX:int= int((relativeX + x));
					var sampleY:int= int((relativeY + y));
					if (getBrightness(int((sampleX)), int((sampleY))) < 0.01&& ++darkCount >= threshold)
						return false;
					i++;
				}
	
				return true;
	
			} else {
				return tree.contains(x, y, x + width, y + height);
			}
		}
	
		public function intersects(x:Number, y:Number, width:Number, height:Number):Boolean {
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
				return tree.overlaps(x, y, x + width, y + height);
			}
		}
	
		//	function HEXtoHSV(c:uint):Object {
		//		
		//		var hsvColor:Object = {};
		//		var RGB:Array = [0,0,0];
		//		var hexColor:String = c.toString(16);
		//		
		//		if (hexColor.length == 1){
		//			hexColor="000000";
		//		} else if (hexColor.length == 4){
		//			hexColor="00"+hexColor;
		//		}
		//		
		//		RGB[0] = parseInt(hexColor.substr(0,2),16)/255;
		//		RGB[1] = parseInt(hexColor.substr(2,2),16)/255;
		//		RGB[2] = parseInt(hexColor.substr(4,2),16)/255;
		//		
		//		
		//		var min:Number = RGB[0];
		//		if (RGB[1] < min){min = RGB[1];}
		//		if (RGB[2] < min){min = RGB[2];}
		//		
		//		var max:Number = RGB[0];
		//		if (RGB[1] > max){max = RGB[1];}
		//		if (RGB[2] > max){max = RGB[2];}
		//		
		//		hsvColor.v = max * 100;
		//		
		//		var deltaColor:Number = max - min;
		//		
		//		if (max != 0){
		//			hsvColor.s = deltaColor / max * 100;
		//		} else {
		//			hsvColor.s = 0;
		//			hsvColor.h = -1;
		//		}
		//		
		//		if( RGB[0] == max ){
		//			hsvColor.h = ( RGB[1] - RGB[2] ) / deltaColor;
		//		}else if( RGB[1] == max ){
		//			hsvColor.h = 2 + ( RGB[2] - RGB[0] ) / deltaColor;
		//		}else{
		//			hsvColor.h = 4 + ( RGB[0] - RGB[1] ) / deltaColor;
		//		}
		//		hsvColor.h *= 60;
		//		
		//		if( hsvColor.h < 0 ){hsvColor.h += 360;}
		//		
		//		return hsvColor;
		//		
		//	}
		
	}
}