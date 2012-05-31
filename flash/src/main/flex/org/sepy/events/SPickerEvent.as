// ActionScript file

package org.sepy.events
{
	import flash.events.Event;
	
	/**
	 * Event dispatched from the Color Picker component
	 * 
	 */
	public class SPickerEvent extends Event
	{
		
		/**
		 * dispatched every time the internal color selection
		 * is changing
		 */
		public static const CHANGING:String   = "changing";
		
		/**
		* 
		*/
		public static const SWATCH_ADD:String   = "swatchAdd";
		
		public var value:uint;
		
		public function SPickerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new SPickerEvent(type, bubbles, cancelable);
		}
	}
}