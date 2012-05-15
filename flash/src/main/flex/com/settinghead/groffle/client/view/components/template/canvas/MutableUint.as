package com.settinghead.groffle.client.view.components.template.canvas
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;

	dynamic public class MutableUint extends Proxy implements IEventDispatcher
	{
		protected var eventDispatcher:EventDispatcher;

		public function MutableUint(v:uint = 0)
		{
			this._value = v;
			eventDispatcher = new EventDispatcher(this);
		}
		
		private var _value:uint;
		
		[Bindable(event="UintChanged")]
		public function get v():uint{
			return _value;
		}
		
		public function set v(val:uint):void{
			this._value = val;
			dispatchEvent(new Event("UintChanged"));
		}
		
		public function clone():MutableUint{
			return new MutableUint(v);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
	}
}