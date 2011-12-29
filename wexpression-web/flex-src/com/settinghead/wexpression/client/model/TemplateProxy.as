package com.settinghead.wenwentu.client.model
{
	import mx.collections.ArrayCollection;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class TemplateProxy extends Proxy
	{
		public static const NAME:String = "TemplateProxy";
		
		public function TemplateProxy( )
		{
			super( NAME, new ArrayCollection );
		}
		
		// return data property cast to proper type
		public function get templates():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		// add an item to the data    
		public function addItem( item:Object ):void
		{
			templates.addItem( item );
		}
		
	}
}