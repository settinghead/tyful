package org.sepy.graphics.filters
{
	public class WebcolorsImageFilter extends BaseImageCustomFilter
	{
		private var round:Function;
		
		public function WebcolorsImageFilter(rows_count:uint=1)
		{
			super(rows_count);
			
			round = Math.round;
		}
		
		protected override function step(r:uint, g:uint, b:uint, x:uint, y:uint):uint
		{
			var l_round:Function;
			
			l_round = round;
			r = l_round(r / 51) * 51;
			g = l_round(g / 51) * 51;
			b = l_round(b / 51) * 51;
			
			return r << 16 | g << 8 | b;
		}
	}
}