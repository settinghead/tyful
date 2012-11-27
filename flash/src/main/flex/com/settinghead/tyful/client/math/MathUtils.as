package com.settinghead.tyful.client.math
{
	public class MathUtils
	{
		public static  const TWO_PI:Number = Math.PI * 2;
		public function MathUtils()
		{
		}
		
		public static function lerp(start:Number, stop:Number, amt:Number):Number{
			return start + (stop - start) * amt;
		}
		
		public static function norm(value:Number, start:Number, stop:Number):Number{
			return (value - start) / (stop - start);			
		}
		
		public static function map( value:Number, istart:Number, istop:Number, ostart:Number, ostop:Number):Number {
				return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
			}
	}
}