package com.settinghead.wexpression.client.model
{
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSONDecoder;
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.vo.PreviewUrlVO;
	import com.settinghead.wexpression.client.model.vo.ShopItemVO;
	import com.settinghead.wexpression.client.view.components.shop.ShopItemList;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	import spark.primitives.BitmapImage;
	
	public class ShopProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "ShopProxy";
		public static const SRNAME:String = "ShopSRProxy";
		private var urlLoader : MultipartURLLoader;
		private var _previewUrl:PreviewUrlVO = new PreviewUrlVO();
		
		public function ShopProxy()
		{
			super(NAME, new ArrayCollection());
		}
		
		public function load() :void{
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
		
		public function prepareShop(img:BitmapData):void{
			tmpImg = img;
			uploadImage(img);
		}
		
		public function postPrepareShop(img:BitmapData):void{

			this.shop.removeAll();

			var maleTee:ShopItemVO = new ShopItemVO("http://www.zazzle.com/api/create/at-238390271796358057?rf=238390271796358057&ax=Linkover&pd=235647948106072294&fwd=ProductPage&ed=true&tc=&ic=&standardtee=[preview]", previewUrl);

			maleTee.image = img;
			var femaleTee:ShopItemVO = new ShopItemVO("http://www.zazzle.com/female", previewUrl);
			femaleTee.image = img;
			this.addItem(maleTee);
			this.addItem(femaleTee);
		}
		
		private var tmpImg:BitmapData = null;
		
		public function uploadImage(img:BitmapData):void{
			var b:ByteArray = PNGEncoder.encode(img);
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
			urlLoader.addFile(b,"upload.png");
			
			//			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
	
			urlLoader.load( FlexGlobals.topLevelApplication.parameters.relayUrl,true);
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
			_previewUrl.url = FlexGlobals.topLevelApplication.parameters.relayUrl+id;

			postPrepareShop(tmpImg);
		}
	}
}