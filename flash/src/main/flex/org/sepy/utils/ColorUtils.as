package org.sepy.utils
{
	import org.sepy.color.HLS;
	import org.sepy.color.LAB;
	
	public class ColorUtils
	{
		protected static const RGBMAX:uint = 255;
		protected static const HLSMAX:uint = 240;

		
		/**
		 * Convert an rgb color, passed as combination of red green and blue,
		 * into an HLS instance
		 * 
		 * @see org.sepy.color.HLS
		 */
		public static function RGB2HLS(r:uint, g:uint, b:uint):HLS
		{
			var min:Number;
			var max:Number;	
			var hls:HLS = new HLS();

			max = Math.max(r,g,b);
			min = Math.min(r,g,b);
			
			var L:Number
			var S:Number
			var H:Number
			
			var Rdelta:Number
			var Bdelta:Number
			var Gdelta:Number
			
			L = (((max+min)*HLSMAX) + RGBMAX )/(2*RGBMAX);
			
			if (max == min) {
				S = 0;
				H = (HLSMAX*2/3);
			} else 
			{
				if (L <= (HLSMAX/2))
				{
					S = ( ((max-min)*HLSMAX) + ((max+min)/2) ) / (max+min);
				} else
				{
					S = ( ((max-min)*HLSMAX) + ((2*RGBMAX-max-min)/2) ) / (2*RGBMAX-max-min);
				}

				Rdelta = ( ((max-r)*(HLSMAX/6)) + ((max-min)/2) ) / (max-min);
				Gdelta = ( ((max-g)*(HLSMAX/6)) + ((max-min)/2) ) / (max-min);
				Bdelta = ( ((max-b)*(HLSMAX/6)) + ((max-min)/2) ) / (max-min);

			    if (r == max)
			    {
					H = Bdelta - Gdelta;
			    } else if (g == max)
			    {
					H = (HLSMAX/3) + Rdelta - Bdelta;
				} else 
				{
					H = ((2*HLSMAX)/3) + Gdelta - Rdelta;
				}

				if (H < 0)
				{
					H += HLSMAX;
				}
				if (H > HLSMAX)
				{
					H -= HLSMAX;
				}
			}
			hls.hue = H;
			hls.luminance = L
			hls.saturation = S;
			return hls;
		} // RGB2HLS



		/**
		 * Convert an HLS instance color into an rgb value
		 * 
		 * @see org.sepy.color.HLS
		 */
		public static function HLS2RGB(hls:HLS):uint
		{
			var R:uint;
			var G:uint;
			var B:uint;
			
			var Magic2:Number;
			var Magic1:Number;
			
			if(hls.saturation == 0)
			{
				R = G = B= (hls.luminance*RGBMAX)/HLSMAX;
				if(hls.hue != (HLSMAX*2/3))
				{
					return 0;
				}
			} else 
			{ 
				if (hls.luminance <= (HLSMAX/2))
				{
					Magic2 = (hls.luminance*(HLSMAX + hls.saturation) + (HLSMAX/2))/HLSMAX;
				} else
				{
					Magic2 = hls.luminance + hls.saturation - ((hls.luminance * hls.saturation) + (HLSMAX/2))/HLSMAX;
				}
				Magic1 = 2 * hls.luminance - Magic2;

				/* get RGB, change units from HLSMAX to RGBMAX */ 
				R = (HueToRGB(Magic1,Magic2,hls.hue +(HLSMAX/3))*RGBMAX + (HLSMAX/2))/HLSMAX;
				G = (HueToRGB(Magic1,Magic2,hls.hue)*RGBMAX + (HLSMAX/2)) / HLSMAX;
				B = (HueToRGB(Magic1,Magic2,hls.hue-(HLSMAX/3))*RGBMAX + (HLSMAX/2))/HLSMAX;
      		}
      		return R << 16 | G << 8 | B;
		} // HLS2RGB
		
		
		public static function RGB2LAB(red:uint, green:uint, blue:uint):LAB
		{

			var result:Array = new Array(3);
		  
			result[0]=(0.490*red+0.310*green+0.200*blue );
			result[1]=(0.177*red+0.812*green+0.011*blue );
			result[2]=(0.000*red+0.010*green+0.990*blue );
		  
		  
			result[0]/=255;
			result[1]/=255;
			result[2]/=255;
			
			var L:Number;
		
			if (result[1] > 0.008856)
			{
				L=116*(Math.pow(result[1],1.0/3.0))-16;
			} else {
				L=903.3*result[1];
			}  
		
			var a:Number = 500*(flab(result[0])-flab(result[1]));
			var b:Number = 200*(flab(result[1])-flab(result[2]));
		
			return new LAB(L, a, b)
		} // RGB2LAb

		
		private static function flab(x:Number):Number
		{
			var res:Number;
			if (x>0.008856)
			{
				res = Math.pow(x,1.0/3.0);
			} else 
			{
				res = 7.787* x + (16.0/116.0);
			}
			return res;
		} // flab


		public static function LAB2RGB(lab:Array):uint
		{

		  var  P:Number = (lab[0]+ 16) / 116.0;
		  var x:Number = Math.pow((P+lab[1]/500.0),3);
		  var y:Number = Math.pow(P,3);
		  var z:Number = Math.pow((P-lab[2]/200.0),3);

			lab[0]=(2.365*x-0.896*y-0.468*z);
			lab[1]=(-0.515*x+1.425*y+0.088*z);
			lab[2]=(0.005*x-0.014*y+1.009*z);

			return (lab[0]*255) << 16 | (lab[1]*255) << 8 | lab[2]*255
		} // LAB2RGB

		
		private static function HueToRGB(n1:Number, n2:Number, hue:Number):Number
		{
			if (hue < 0)
			{
				hue += HLSMAX;
			}
			if (hue > HLSMAX)
			{
				hue -= HLSMAX;
			}

			if (hue < (HLSMAX/6))
			{
				return ( n1 + (((n2-n1)*hue+(HLSMAX/12))/(HLSMAX/6)) );
			}
			if (hue < (HLSMAX/2))
			{
				return ( n2 );
			}
			if (hue < ((HLSMAX*2)/3))
			{
				return ( n1 +    (((n2-n1)*(((HLSMAX*2)/3)-hue)+(HLSMAX/12))/(HLSMAX/6)));
			} else
			{
				return ( n1 );
			}
		}
	}
}