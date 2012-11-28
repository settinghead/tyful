package com.settinghead.tyful.client.model.vo.shop
{
	import com.settinghead.tyful.client.model.vo.PreviewUrlVO;
	
	import flash.display.BitmapData;
	
	import mx.controls.Alert;

	public class ShopItemVO
	{
		private var _img:BitmapData;
		private var _thumb:BitmapData;
		private var _item_url:String;
		private var _overlayImageUrl:String;
		private var _previewUrl:PreviewUrlVO;
		private var _imageUrl:String;
		private var _description:String;
		private var _name:String;
		
		public function ShopItemVO(name:String, u:PreviewUrlVO, 
								   url:String, imageUrl:String= null, 
								   description:String = null)
		{
			this._item_url = url;
			this._previewUrl = u;
			this._description = description;
			this._name = name;
			this._imageUrl = imageUrl;
		}
		
		public function get image():BitmapData{
			return _img;
		}
		
		public function get thumbnail():BitmapData{
			return _thumb;
		}
		
		public function get name():String{
			return _name;
		}
		
		public function get imageUrl():String{
			return _imageUrl;
		}
		
		public function description():String{
			return _description;
		}
		
		public function get itemUrl():String{
			if(_previewUrl.url!=null)
			 	return _item_url.replace("[preview]", encodeURIComponent(_previewUrl.url));
			else
				return _item_url;
		}
		
		public function set image(img:BitmapData):void{
			this._img = img;
		}
		
		public function set overlayImageUrl(url:String):void{
			this._overlayImageUrl = url;
		}
		
		public function get overlayImageUrl():String{
			return this._overlayImageUrl;
		}
		
		public function set thumb(thb:BitmapData):void{
			this._thumb = thb;
		}
		
		public function set itemUrl(url:String):void{
			this._item_url = url;
		}
	}
}