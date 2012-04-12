package com.settinghead.wexpression.client.model
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.zip.IZipInput;
	import com.settinghead.wexpression.client.model.zip.IZipOutput;
	import com.settinghead.wexpression.client.model.zip.ZipInputImpl;
	import com.settinghead.wexpression.client.model.zip.ZipOutputImpl;
	import com.settinghead.wexpression.client.model.vo.template.Layer;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.model.vo.template.WordLayer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
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
		private var urlLoader : URLLoader;

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
				template = new TemplateVO(_pathToLoad);
				var l:WordLayer = new WordLayer("layer1", template);
				//TODO: different path for template and layer PNG
				l.path = _pathToLoad;
				l.loadLayerFromPNG(templateLoadComplete);
			}
		}
		
		private function templateLoadComplete(event:Event):void{	
			facade.sendNotification(ApplicationFacade.TEMPLATE_LOADED, template);
			facade.sendNotification(ApplicationFacade.EDIT_TEMPLATE, template);
		}
		
		
		public function get template():TemplateVO{
			return this.getData() as TemplateVO;
		}
		
		public function set template(t:TemplateVO):void{
			this.setData(t);
		}
		
		public function toFile(template:TemplateVO = null):ByteArray{
			if(template==null) template = this.template;
			var zipOutput:IZipOutput = new ZipOutputImpl();
			zipOutput.process(template);
			var zipBytes:ByteArray = zipOutput.zipUp();
			return zipBytes;
		}
		
		public function fromFile(b:ByteArray):void{
			var zipInput:IZipInput = new ZipInputImpl();
			template = new TemplateVO(null);
			zipInput.fulfil(template, b);
		}
		
		public function uploadTemplate():void{
			var b:ByteArray = toFile();
			// set up the request & headers for the image upload;
			var urlRequest : URLRequest = new URLRequest();
			urlRequest.url = 'templates/u';
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = b;
			urlRequest.requestHeaders.push(header);
			// create the image loader & send the image to the server;
			urlLoader = new URLLoader();
			//			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, uploadComplete);
			urlLoader.load( urlRequest );
		}
		
		public function uploadComplete(e:Event):void{
			sendNotification(ApplicationFacade.TEMPLATE_UPLOADED, urlLoader.data);
		}
	}
}