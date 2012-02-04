package com.settinghead.wexpression.client.model
{

	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.model.LoadupResourceProxy;
	
	public class EntityProxy extends Proxy implements IProxy
	{
		public function EntityProxy( name :String, data:Object = null )
		{
			super( name, data );
		}
		
		protected function sendLoadedNotification( noteName:String, noteBody:String, srName:String ):void
		{
			var srProxy:LoadupResourceProxy = facade.retrieveProxy( srName ) as LoadupResourceProxy;
			if ( ! srProxy.isTimedOut() )
			{
				sendNotification( noteName, noteBody );
			}
		}
		
	}
}