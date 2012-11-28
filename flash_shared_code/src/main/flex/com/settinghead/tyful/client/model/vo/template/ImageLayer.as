package com.settinghead.tyful.client.model.vo.template
{
	import com.settinghead.tyful.client.model.zip.IZipInput;
	import com.settinghead.tyful.client.model.zip.IZipOutput;
	import com.settinghead.tyful.client.model.zip.IZippable;
	
	import flash.display.BitmapData;

	public class ImageLayer extends Layer implements IZippable
	{
		private var _img:BitmapData;

		public function ImageLayer(n:String, template:TemplateVO, image:BitmapData, index:int=-1, autoAddAndConnect:Boolean=true)
		{
			super(n, template, index, autoAddAndConnect);
			this.image = image;
		}
		
		public function get image():BitmapData 
		{
			return _img;
		}
		
		public function set image(value:BitmapData):void 
		{
			this._img = value;
		}
		
		public override function getWidth():Number{
			return image.width;
		}
		
		public override function getHeight():Number{
			return image.height;
		}
		
		public override function generateEffectiveBorder():void{
			this._effectiveBorder =
				this.image.getColorBoundsRect(
					0xFF000000,0x00000000,false);
		}
//		public override function containsPoint(x:Number, y:Number,transformed:Boolean,  refX:Number=-1,refY:Number=-1):Boolean{
//			return ((image.getPixel32(x,y) >> 24 &0xff)!=0); 
//		}
//		
		
		public override function writeNonJSONPropertiesToZip(output:IZipOutput):void {
			output.putBitmapDataToPNGFile("image.png", this.image);
		}
		
		
		
		public override function readNonJSONPropertiesFromZip(input:IZipInput): void{
			//TODO	
		}
		
		public override function saveProperties(dict:Object):void{

		}
		
		public override function get type():String{
			return "ImageLayer";
		}
		public override function set type(t:String):void{
			//dummy method; do nothing 
		}
		
	}
}