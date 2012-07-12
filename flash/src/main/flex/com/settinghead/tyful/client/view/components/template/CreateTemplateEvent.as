package com.settinghead.tyful.client.view.components.template
{
	import flash.events.Event;
	
	public class CreateTemplateEvent extends Event
	{
		public function CreateTemplateEvent(type:String, width:int, height:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.width = width;
			this.height = height;
		}
		
		public var width:int;
		public var height:int;
	}
}