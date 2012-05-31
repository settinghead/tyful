package org.sepy.graphics.filters
{
	import flash.events.EventDispatcher;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import org.sepy.events.ImageFilterEvent;

	public class BaseImageFilter extends EventDispatcher
	{
		private var _delayed:Boolean;
		
		public function BaseImageFilter(delayed:Boolean = false)
		{
			super();
			
			_delayed = delayed;
		}
		
		public function apply(src:BitmapData, dest:BitmapData, region:Rectangle = null, point:Point = null):void
		{
			region = region || new Rectangle(0, 0, src.rect.width, src.rect.height);
			point = point || new Point(0, 0);
			
			doFilter(src, dest, region, point);
			if(!_delayed)
				completed(dest);
		}
		
		protected function progress(p:uint, dest:BitmapData):void
		{
			var event:ImageFilterEvent;
			
			event = new ImageFilterEvent(ImageFilterEvent.PROGRESS);
			event.dest = dest;
			event.progress = p;
			
			dispatchEvent(event);
		}
		
		protected function completed(dest:BitmapData):void
		{
			var event:ImageFilterEvent;
			
			event = new ImageFilterEvent(ImageFilterEvent.COMPLETE);
			event.dest = dest;
			
			dispatchEvent(event);
		}
		
		protected virtual function doFilter(src:BitmapData, dest:BitmapData, rect:Rectangle, point:Point):void
		{
			
		}
	}
}