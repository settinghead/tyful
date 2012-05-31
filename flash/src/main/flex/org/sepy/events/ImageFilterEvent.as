package org.sepy.events
{
	import flash.events.Event;
	import flash.display.BitmapData;

	public class ImageFilterEvent extends Event
	{
		public static const COMPLETE:String   = "ImageFilterEvent_complete";
		public static const PROGRESS:String  = "ImageFilterEvent_progress";;
		
		public var dest:BitmapData;
		public var progress:uint;
		
		public function ImageFilterEvent(type:String)
		{
			super(type, false, false);
			
			dest = null;
			progress = 0;
		}
		
		public override function clone():Event
		{
			return new ImageFilterEvent(type);
		}
	}
}