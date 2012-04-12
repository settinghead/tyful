package com.settinghead.wexpression.client.model.vo
{
	import flash.display.BitmapData;

	public class ShopItemVO
	{
		private var _img:BitmapData;
		private var _thumb:BitmapData;
		private var _item_url:String;
		private var _overlayImageUrl:String;
		
		public function ShopItemVO(url:String)
		{
			this._item_url = url;
		}
		
		public function get image():BitmapData{
			return _img;
		}
		
		public function get thumbnail():BitmapData{
			return _thumb;
		}
		
		public function get itemUrl():String{
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