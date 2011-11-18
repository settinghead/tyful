package org.peaceoutside.utils 
{
	
	public class ColorMath 
	{
		
		private static const HLS_VECTOR:Vector.<int> = new Vector.<int>(0x1000000);
		private static var HLSInitialized:Boolean = false;
		
		public static function PrecalculatedHLS(color:int = 0):int
		{
			if (!ColorMath.HLSInitialized)
			{
				for (var i:int = 0; i < 0x1000000; ++i)
				{
					ColorMath.HLS_VECTOR[i] = ColorMath.HLS(i);
				}
				ColorMath.HLSInitialized = true;
			}
			return ColorMath.HLS_VECTOR[color];
		}
		
		public static function HSLToRGB(h:Number,s:Number,l:Number):int{
			var r:Number;
			var g:Number;
			var b:Number;
			var v:Number = l <= 0.5 ? l * (1 + s) : l + s - l * s;
			
			if (v <= 0)
			{
				return(0);
			}
			else
			{
				var m:Number;
				var sv:Number;
				var sextant:int;
				var fract:Number;
				var vsf:Number;
				var mid1:Number;
				var mid2:Number;
				
				m = l + l - v;
				sv = (v - m) / v;
				h *= 6;
				sextant = h;
				fract = h - sextant;
				vsf = v * sv * fract;
				mid1 = m + vsf;
				mid2 = v - vsf;
				
				switch(sextant)
				{
					case 1: r = mid2; g = v; b = m; break;
					case 2: r = m; g = v; b = mid1; break;
					case 3: r = m; g = mid2; b = v; break;
					case 4: r = mid1; g = m; b = v; break;
					case 5: r = v; g = m; b = mid2; break;
					default: r = v; g = mid1; b = m; break;
				}
			}
			
			r *= 0xFF;
			g *= 0xFF;
			b *= 0xFF;
			
			return (r << 16) | (g << 8) | b;
		}
		
		public static function HLS(color:int = 0):int
		{
			var h:Number = ((color & 0xFF0000) >> 16) * 0.003921568627450980392156862745098;
			var l:Number = ((color & 0xFF00) >> 8) * 0.003921568627450980392156862745098;
			var s:Number = (color & 0xFF) * 0.003921568627450980392156862745098;
			var r:Number;
			var g:Number;
			var b:Number;
			var v:Number = l <= 0.5 ? l * (1 + s) : l + s - l * s;
			
			if (v <= 0)
			{
				return(0);
			}
			else
			{
				var m:Number;
				var sv:Number;
				var sextant:int;
				var fract:Number;
				var vsf:Number;
				var mid1:Number;
				var mid2:Number;
				
				m = l + l - v;
				sv = (v - m) / v;
				h *= 6;
				sextant = h;
				fract = h - sextant;
				vsf = v * sv * fract;
				mid1 = m + vsf;
				mid2 = v - vsf;
				
				switch(sextant)
				{
					case 1: r = mid2; g = v; b = m; break;
					case 2: r = m; g = v; b = mid1; break;
					case 3: r = m; g = mid2; b = v; break;
					case 4: r = mid1; g = m; b = v; break;
					case 5: r = v; g = m; b = mid2; break;
					default: r = v; g = mid1; b = m; break;
				}
			}
			
			r *= 0xFF;
			g *= 0xFF;
			b *= 0xFF;
			
			return (r << 16) | (g << 8) | b;
		}
		
		public static function color( x:int, y:int, z:int):int {
				if (x > 255)
					x = 255;
				else if (x < 0)
					x = 0;
				if (y > 255)
					y = 255;
				else if (y < 0)
					y = 0;
				if (z > 255)
					z = 255;
				else if (z < 0)
					z = 0;
				
				return 0xff000000 | (x << 16) | ( y << 8) | z;
		}
		
		public static function RGBtoHSB(rgbPixel:uint):int {
			var r:int = (rgbPixel & 0xFF0000) >> 16;
			var g:int = (rgbPixel & 0xFF00) >> 8;
			var b:int = rgbPixel & 0xFF;
			var hue:Number, saturation:Number, brightness:Number;
			
			var cmax:Number = (r > g) ? r : g;
			if (b > cmax) cmax = b;
			var cmin:Number = (r < g) ? r : g;
			if (b < cmin) cmin = b;
			
			brightness = cmax / 255.0;
			if (cmax != 0)
				saturation = (cmax - cmin) / cmax;
			else
				saturation = 0;
			if (saturation == 0)
				hue = 0;
			else {
				var redc:Number = ( (cmax - r)) / ((cmax - cmin));
				var greenc:Number = ( (cmax - g)) / ((cmax - cmin));
				var bluec:Number = ((cmax - b)) / ((cmax - cmin));
				if (r == cmax)
					hue = bluec - greenc;
				else if (g == cmax)
					hue = 2.0 + redc - bluec;
				else
				hue = 4.0 + greenc - redc;
				hue = hue / 6.0;
				if (hue < 0)
					hue = hue + 1.0;
			}
			
			var h:int = hue*255;
			var s:int = saturation*255;
			var bb:int = brightness*255;
			return 0xff000000 | (h << 16) | (s << 8) | bb;

		}
	}
}