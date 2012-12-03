package com.settinghead.tyful.client.model.polarcore
{
	import flash.events.Event;

	public class NativeClientPolarCore extends AbstractPolarCore
	{
		public function NativeClientPolarCore()
		{
		}
		
		public override function load():void{
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
	}
}