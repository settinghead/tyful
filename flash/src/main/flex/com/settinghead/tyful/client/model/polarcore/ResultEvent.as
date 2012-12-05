package com.settinghead.tyful.client.model.polarcore
{
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	
	import flash.events.Event;
	
	public class ResultEvent extends Event
	{
		public function ResultEvent(shape:DisplayWordVO)
		{
			super(AbstractPolarCore.RESULT);
			this.shape = shape;
		}
		
		public var shape:DisplayWordVO;
	}
}