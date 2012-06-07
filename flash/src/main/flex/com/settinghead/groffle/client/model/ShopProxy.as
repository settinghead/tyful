package com.settinghead.groffle.client.model
{
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSONDecoder;
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.vo.PreviewUrlVO;
	import com.settinghead.groffle.client.model.vo.shop.ShopVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	public class ShopProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "ShopProxy";
		public static const SRNAME:String = "ShopSRProxy";
		private var urlLoader : MultipartURLLoader;
		private var _previewUrl:PreviewUrlVO = new PreviewUrlVO();
		private var _templateProxy:TemplateProxy = null;
		
		public function ShopProxy()
		{
			super(NAME, null);
		}
		
		private function get templateProxy():TemplateProxy{
			if(_templateProxy==null)_templateProxy = 
				facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			return _templateProxy;
		}

		
		
		// return data property cast to proper type
		public function get shop():ArrayCollection
		{
			return data as ArrayCollection;

		}
		
		// return data property cast to proper type
		public function get previewUrl():PreviewUrlVO
		{
			return _previewUrl;
		}
		
		// add an item to the data
		public function addItem( item:Object ):void
		{
			shop.addItem( item );
		}
		

		private var loader : URLLoader;
		private var retrieveAttempt:int = 0;
		public function load() :void{
			if(this.shop==null)
				this.setData(new ArrayCollection());
			var url:String = (retrieveAttempt>3)?"/shop/generic":"/shop/predict";
			var request : URLRequest = 
				new URLRequest  ( url );
			var urlVariables : URLVariables = new URLVariables ();
			if(templateProxy.template!=null)
				urlVariables['templateId']=templateProxy.template.id;
			request.data = urlVariables;
			request.method = URLRequestMethod.GET;
			loader = new URLLoader ();
			loader.addEventListener( Event.COMPLETE, jsonLoaded );
			loader.load ( request );
		}
		
		public function jsonLoaded(e:Event):void{
			var obj:Object = new JSONDecoder(loader.data as String,false).getValue();
			if(obj is Array){
				var l:Array = (obj as Object) as Array;
				var shop:ShopVO = new ShopVO(previewUrl, l);
				this.setData(shop);
			}
			else
				//retry
			{
				retrieveAttempt++;
				setTimeout(load,3000);
			}
		}
		
//		public function prepareSampleShop():void{
//
//			this.shop.removeAll();
//
//			var maleTee:ShopItemVO =
//				new ShopItemVO("Male Tee",previewUrl, "http://www.zazzle.com/api/create/at-238390271796358057?rf=238390271796358057&ax=Linkover&pd=235647948106072294&fwd=ProductPage&ed=true&tc=&ic=&standardtee=[preview]");
//
//			var femaleTee:ShopItemVO = new ShopItemVO("Female Tee", previewUrl, "http://www.zazzle.com/female");
//			this.addItem(maleTee);
//			this.addItem(femaleTee);
//		}
		
		private var tmpImg:BitmapData = null;
		
		public function uploadImage(img:BitmapData):void{
			//_previewUrl.url = null;
			tmpImg = img;

			var b:ByteArray = PNGEncoder2.encode(img);
			// set up the request & headers for the image upload;
//			var urlRequest : URLRequest = new URLRequest();
//			//urlRequest.url = 'http://file.wenwentu.com/r/';
//			urlRequest.url = 'http://localhost:5000/r/';
//			urlRequest.method = 'POST';
//			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
//			urlRequest.method = URLRequestMethod.POST;
//			urlRequest.data = b;
//			urlRequest.requestHeaders.push(header);

			urlLoader = new MultipartURLLoader();
			// create the image loader & send the image to the server;
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, uploadComplete);
			urlLoader.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, dataPrepareComplete);
			urlLoader.addFile(b,"upload.png","image");
			//			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load( decodeURIComponent(FlexGlobals.topLevelApplication.parameters.relayUrl),true);
//			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, uploadError);
//			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadError);
		}
		public function uploadError(e:Event):void{
			Alert.show(e.toString());
		}
		
		public function dataPrepareComplete(e:Event):void{
			if(urlLoader.PREPARED)
				urlLoader.startLoad();
		}
		
		public function uploadComplete(e:Event):void{
			var id:String = new JSONDecoder(urlLoader.loader.data,false).getValue().id;
			//			_previewUrl.url = "http://file.wenwentu.com/r/"+id;
			_previewUrl.url = decodeURIComponent(FlexGlobals.topLevelApplication.parameters.relayUrl)+id;
			facade.sendNotification(ApplicationFacade.SHOW_SHOP);
		}
	}
}