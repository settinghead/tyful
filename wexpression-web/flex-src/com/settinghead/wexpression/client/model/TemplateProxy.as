package com.settinghead.wexpression.client.model
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.vo.TemplateVO;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	public class TemplateProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "TemplateProxy";
		public static const SRNAME:String = "TemplateSRProxy";
		private var _pathToLoad:String;
		private var _template:TemplateVO;

		public function TemplateProxy( )
		{
			super( NAME, new ArrayCollection );
		}
		
		public function set templatePath(path:String):void{
			this._pathToLoad = path;
		}
		
		public function load() :void{
			if(_pathToLoad!=null){
				_template = new TemplateVO(_pathToLoad);
				_template.loadTemplate(templateLoadComplete);
			}
		}
		
		private function templateLoadComplete(event:Event):void{
			facade.sendNotification(ApplicationFacade.EDIT_TEMPLATE, _template);
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