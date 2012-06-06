package com.settinghead.groffle.client.model.vo.template
{
	import flash.display.BitmapData;

	public class ImageLayer extends Layer
	{
		private var _img:BitmapData;

		public function ImageLayer(n:String, template:TemplateVO, index:int=-1, width:Number = -1, height:Number = -1, autoAddAndConnect:Boolean=true)
		{
			super(n, template, index, autoAddAndConnect);
		}
		
		public function get image():BitmapData 
		{
			return _img;
		}
		
		public function set image(value:BitmapData):void 
		{
			this._img = value;
		}
	}
}