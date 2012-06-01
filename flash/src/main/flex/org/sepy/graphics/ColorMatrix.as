package org.sepy.graphics
{
	import org.sepy.geom.Matrix2d;
	
	public class ColorMatrix extends Matrix2d
	{
		
		public static const BRIGHTNESS_MIN:int = -255;
		public static const BRIGHTNESS_MAX:int = 255;
		
		public static const HUE_MIN:int = -180;
		public static const HUE_MAX:int = 180;
		
		public static const SATURATION_MIN:int = -100;
		public static const SATURATION_MAX:int = 100;
		
		public static const CONTRAST_MIN:int = -100;
		public static const CONTRAST_MAX:int = 100;		
		
		// constant for contrast calculations:
		private static var DELTA_INDEX:Array = [
			0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
			0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
			0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
			0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 
			0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
			1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
			1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25, 
			2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
			4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
			7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8, 
			10.0
		];
		
		public function ColorMatrix(matrix:Array = null)
		{
			super(5, 5);
			
			setFlatData(matrix ? matrix : IDENTITY, true);
		}
		
		public function adjustColor(brightness:int, contrast:int, saturation:int, hue:int):void
		{
			adjustHue(hue);
			adjustContrast(contrast);
			adjustSaturation(saturation);
			adjustBrightness(brightness);			
		}
	
		public function adjustBrightness(val:int):void
		{
			val = fixValue(val, 255);
			if(!val)
				return;
			
			multiply([
				1,0,0,0,val,
				0,1,0,0,val,
				0,0,1,0,val,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		public function adjustContrast(val:int):void
		{
			var x:Number;
			
			val = fixValue(val, 100);
			if(!val)
				return;
			
			if (val < 0)
				x = 127 + val / 100 * 127;
			else {
				x = val % 1;
				x = (x == 0) ? DELTA_INDEX[val] : DELTA_INDEX[(val<<0)]*(1-x)+DELTA_INDEX[(val<<0)+1]*x;
				x = x * 127 + 127;
			}
			
			multiply([
				x/127,0,0,0,0.5*(127-x),
				0,x/127,0,0,0.5*(127-x),
				0,0,x/127,0,0.5*(127-x),
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		public function grayScale():void
		{
			adjustSaturation(-100);
		}
		
		public function adjustSaturation(val:int):void
		{
			var x:Number;
			/*
			var lumR:Number = 0.212671;
			var lumG:Number = 0.715160;
			var lumB:Number = 0.072169;
			*/
			var lumR:Number = 0.3086;
			var lumG:Number = 0.6094;
			var lumB:Number = 0.0820;
			
			val = fixValue(val, 100);
			if(!val)
				return;
				
			x = 1 + ((val > 0) ? 3 * val / 100 : val / 100);
			
			multiply([
				lumR*(1-x)+x,lumG*(1-x),lumB*(1-x),0,0,
				lumR*(1-x),lumG*(1-x)+x,lumB*(1-x),0,0,
				lumR*(1-x),lumG*(1-x),lumB*(1-x)+x,0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		public function adjustHue(val:int):void
		{
			var cosVal:Number;
			var sinVal:Number;
			var lumR:Number = 0.213;
			var lumG:Number = 0.715;
			var lumB:Number = 0.072;
			
			val = fixValue(val, 180) / 180 * Math.PI;
			if(!val)
				return;
				
			cosVal = Math.cos(val);
			sinVal = Math.sin(val);
			
			multiply([
				lumR+cosVal*(1-lumR)+sinVal*(-lumR),lumG+cosVal*(-lumG)+sinVal*(-lumG),lumB+cosVal*(-lumB)+sinVal*(1-lumB),0,0,
				lumR+cosVal*(-lumR)+sinVal*(0.143),lumG+cosVal*(1-lumG)+sinVal*(0.140),lumB+cosVal*(-lumB)+sinVal*(-0.283),0,0,
				lumR+cosVal*(-lumR)+sinVal*(-(1-lumR)),lumG+cosVal*(-lumG)+sinVal*(lumG),lumB+cosVal*(1-lumB)+sinVal*(lumB),0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		private function multiply(matrix:Array):void
		{
			var temp:Array;
			var i:uint;
			
			temp = new Array();
			i = 0;
			for (var y:uint = 0; y < 5; y++ )
			{
				for (var x:uint = 0; x < 5; x++ )
				{
					temp[i + x] = data[i    ] * matrix[x     ] + 
								   data[i+1] * matrix[x +  5] + 
								   data[i+2] * matrix[x + 10] + 
								   data[i+3] * matrix[x + 15] +
								   (x == 5 ? data[i+5] : 0);
				}
				i+=5;
			}
			
			setFlatData(temp, true);
		}
		
		private function fixValue(val:int, limit:int):int
		{
			return Math.min(limit, Math.max(-limit, val));
		}			
	}
}