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
	}
}