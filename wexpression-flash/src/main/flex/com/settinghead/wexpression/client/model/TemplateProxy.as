package com.settinghead.wexpression.client.model
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.vo.template.Layer;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.model.vo.template.WordLayer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
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
			load();
		}
		
		public function load() :void{
			if(_pathToLoad!=null){
				_template = new TemplateVO(_pathToLoad);
				var l:WordLayer = new WordLayer(_template);
				//TODO: different path for template and layer PNG
				l.path = _pathToLoad;
				l.loadLayerFromPNG(templateLoadComplete);
			}
		}
		
		private function templateLoadComplete(event:Event):void{	
			facade.sendNotification(ApplicationFacade.TEMPLATE_LOADED, _template);
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