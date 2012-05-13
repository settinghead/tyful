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
		
		public static function HSLtoRGB(a:Number=1,hue:Number=0,saturation:Number=0.5,lightness:Number=1):uint{
			a = Math.max(0,Math.min(1,a));
			saturation = Math.max(0,Math.min(1,saturation));
			lightness = Math.max(0,Math.min(1,lightness));
			hue = hue%360;
			if(hue<0)hue+=360;
			hue/=60;
			var C:Number = (1-Math.abs(2*lightness-1))*saturation;
			var X:Number = C*(1-Math.abs((hue%2)-1));
			var m:Number = lightness-0.5*C;
			C=(C+m)*255;
			X=(X+m)*255;
			m*=255;
			if(hue<1) return (Math.round(a*255)<<24)+(C<<16)+(X<<8)+m;
			if(hue<2) return (Math.round(a*255)<<24)+(X<<16)+(C<<8)+m;
			if(hue<3) return (Math.round(a*255)<<24)+(m<<16)+(C<<8)+X;
			if(hue<4) return (Math.round(a*255)<<24)+(m<<16)+(X<<8)+C;
			if(hue<5) return (Math.round(a*255)<<24)+(X<<16)+(m<<8)+C;
			return (Math.round(a*255)<<24)+(C<<16)+(m<<8)+X;
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
		
		public static function getBrightness(rgb:Number):int{
			var r:int = (rgb) >> 16 & 0xFF;
			var g:int = (rgb) >> 8 & 0xFF;
			var b:int = rgb & 0xFF;
			var cmax:Number = (r > g) ? r : g;
			if (b > cmax) cmax = b;
			
			return cmax/255;
		}
		
		public static function RGBtoHSB(rgbPixel:Number):int {
			var r:int = (rgbPixel) >> 16 & 0xFF;
			var g:int = (rgbPixel) >> 8 & 0xFF;
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
		
		//RGB distance between two colors
		//max return value: 1; min return value: 0
		public static function dist(c1:uint, c2:uint):Number{
			var r1:Number = (c1) >> 16 & 0xFF;
			var g1:Number = (c1) >> 8 & 0xFF;
			var b1:Number = c1 & 0xFF;
			var r2:Number = (c2) >> 16 & 0xFF;
			var g2:Number = (c2) >> 8 & 0xFF;
			var b2:Number = c2 & 0xFF;
			return Math.abs(r1-r2)/256/3 + Math.abs(g1-g2)/256/3 + Math.abs(b1-b2)/256/3;
		}
	}
}