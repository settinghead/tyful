package com.settinghead.tyful.client.model.polarcore
{
	import flash.events.Event;
	
	public class FeedEvent extends Event
	{
		public var numFeeds:uint;
		public var shrinkage:Number;
		public function FeedEvent(numFeeds:uint, shrinkage:Number)
		{
			super(AbstractPolarCore.FEED);
			this.numFeeds = numFeeds;
			this.shrinkage = shrinkage;
		}
	}
}