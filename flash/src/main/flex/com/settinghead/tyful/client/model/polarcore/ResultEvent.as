package com.settinghead.tyful.client.model.polarcore
{
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	
	import flash.events.Event;
	
	public class ResultEvent extends Event
	{
		public function ResultEvent(slap:PlaceInfo)
		{
			super(AbstractPolarCore.RESULT);
			this.slap = slap;
		}
		
		public var slap:PlaceInfo;
	}
}