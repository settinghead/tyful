package org.sepy.color
{
	/**
	 * The HSL color space, also called HLS or HSI, stands for Hue, Saturation, Lightness 
	 * (also Luminance or Luminosity) / Intensity. While HSV (Hue, Saturation, Value) 
	 * can be viewed graphically as a color cone or hexcone, HSL can be drawn as a 
	 * double cone or double hexcone as well as a sphere. Both systems are non-linear 
	 * deformations of the RGB colour cube.
	 * 
	 */
	public class HLS
	{
		private var _hue:uint;
		private var _luminance:uint;
		private var _saturation:uint;
		
		private static var min_func:Function = Math.min;
		private static var max_func:Function = Math.max;
		
		public function HLS(hh:uint = 0, ll:uint = 0, ss:uint = 0):void
		{
			_hue = hh;
			_luminance = ll;
			_saturation = ss;
		}
		
		/**
		 * 0-240 value
		 * 
		 */
		public function get hue():uint
		{
			return _hue
		}
		
		/**
		 * 0 - 240 value
		 * 
		 */
		public function get luminance():uint
		{
			return _luminance
		}
		
		/**
		 * 0 - 240 value
		 */
		public function get saturation():uint
		{
			return _saturation;
		}
		
		public function set hue(value:uint):void
		{
			_hue = checkBounds(value, 0, 240);
		}

		public function set luminance(value:uint):void
		{
			_luminance = checkBounds(value, 0, 240);
		}

		public function set saturation(value:uint):void
		{
			_saturation = checkBounds(value, 0, 240);
		}
		
		private function checkBounds(value:uint, min:uint, max:uint):uint
		{
			if(value < min || value > max)
				value = min_func(max, max_func(min, value));
				
			return value;
		}
	}
}