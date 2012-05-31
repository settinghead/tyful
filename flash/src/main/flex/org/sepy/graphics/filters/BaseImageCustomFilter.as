package org.sepy.graphics.filters
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class BaseImageCustomFilter extends BaseImageFilter
	{
		private var _y:uint;
		private var _src:BitmapData;
		private var _dest:BitmapData;
		private var _region:Rectangle;
		private var _point:Point
		private var timer:Timer;
		private var _rows_count:uint;
		private var _rect:Rectangle;
		private var _gap:uint;
		protected var fillgap:Boolean;
		
		private static var ceil:Function = Math.ceil;
		
		public function BaseImageCustomFilter(rows_count:uint=1)
		{
			super(true);
			
			_rows_count = rows_count;
			_y = 0;
			_gap = 1;
			_src = null;
			_dest = null;
			_region = null;
			_point = null;
			_rect = null;
			timer = null;
			fillgap = true;
		}
		
		public function stop():void
		{
			timer.stop();
		}
		
		protected function get src():BitmapData
		{
			return _src;
		}
		
		protected function get dest():BitmapData
		{
			return _dest;
		}
		
		public function set gap(value:uint):void
		{
			_gap = value;
		}
		
		public function get gap():uint
		{
			return _gap;
		}
		
		protected override function doFilter(src:BitmapData, dest:BitmapData, region:Rectangle, point:Point):void
		{
			// setup
			_src = src;
			_dest = dest;
			_region = region;
			_point = point;
			_y = _region.y;
			
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, nextStep);
			
			timer.start();
		}
		
		protected virtual function step(r:uint, g:uint, b:uint, x:uint, y:uint):uint
		{
			return 0;
		}
		
		private function nextStep(event:Event):void
		{
			var rect:Rectangle;
			
			rect = _region;
			if(_y > rect.bottom)
			{
				timer.stop();
				completed(_dest);
			}else
			{
				var color:uint;
				var r:uint;
				var g:uint;
				var b:uint;
				var count:uint;
				
				count = _rows_count;
				while(count-- > 0)
				{
					if(_y > rect.bottom)
					{
						timer.stop();
						completed(_dest);
						
						return;
					}
					
					for(var x:uint = rect.x; x < rect.right; x += _gap)
					{
						if(!_region.containsPoint(new Point(x, _y)))
							continue;
							
						color = _src.getPixel(x, _y);
						r = (color >> 16) & 0xFF;
						g = (color >> 8) & 0xFF;
						b = (color) & 0xFF;
						
						color = step(r, g, b, x, _y);
						
						if(_gap == 1)
							_dest.setPixel(x, _y, color);
						else
							if(fillgap)
								_dest.fillRect(new Rectangle(x, _y, _gap, _gap), color);
					}
					_y += _gap;
				}
				
				// mettere a posto
				progress(ceil((_y - rect.y) / rect.height * 100), _dest);
			}
		}
	}
}