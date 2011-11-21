package com.settinghead.wenwentu.client.model.vo
{
	import com.settinghead.wenwentu.client.TemplateImage;
	import com.settinghead.wenwentu.client.WordCramRenderer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	[Bindable]
	public class TemplateVO extends TemplateImage
	{
		private var _thumbnail:BitmapData;
		
		public function TemplateVO(path:String)
		{
			super(path);
		}
		
		public function get thumbnail():BitmapData{			
			if(this._thumbnail ==null && this.img!=null )
				this._thumbnail = createThumbnail(this.img.bitmapData);
			return this._thumbnail;
		}
		
		private static function createThumbnail(bmp:BitmapData):BitmapData{
			return resizeImage(bmp, 100, 100);
		}
		
		private static const IDEAL_RESIZE_PERCENT:Number = .5;
		public static function resizeImage(source:BitmapData, width:uint, height:uint, constrainProportions:Boolean = true):BitmapData
		{
			var scaleX:Number = width/source.width;
			var scaleY:Number = height/source.height;
			if (constrainProportions) {
				if (scaleX > scaleY) scaleX = scaleY;
				else scaleY = scaleX;
			}
			
			var bitmapData:BitmapData = source;
			
			if (scaleX >= 1 && scaleY >= 1) {
				bitmapData = new BitmapData(Math.ceil(source.width*scaleX), Math.ceil(source.height*scaleY), true, 0);
				bitmapData.draw(source, new Matrix(scaleX, 0, 0, scaleY), null, null, null, true);
				return bitmapData;
			}
			
			// scale it by the IDEAL for best quality
			var nextScaleX:Number = scaleX;
			var nextScaleY:Number = scaleY;
			while (nextScaleX < 1) nextScaleX /= IDEAL_RESIZE_PERCENT;
			while (nextScaleY < 1) nextScaleY /= IDEAL_RESIZE_PERCENT;
			
			if (scaleX < IDEAL_RESIZE_PERCENT) nextScaleX *= IDEAL_RESIZE_PERCENT;
			if (scaleY < IDEAL_RESIZE_PERCENT) nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			var temp:BitmapData = new BitmapData(bitmapData.width*nextScaleX, bitmapData.height*nextScaleY, true, 0);
			temp.draw(bitmapData, new Matrix(nextScaleX, 0, 0, nextScaleY), null, null, null, true);
			bitmapData = temp;
			
			nextScaleX *= IDEAL_RESIZE_PERCENT;
			nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			while (nextScaleX >= scaleX || nextScaleY >= scaleY) {
				var actualScaleX:Number = nextScaleX >= scaleX ? IDEAL_RESIZE_PERCENT : 1;
				var actualScaleY:Number = nextScaleY >= scaleY ? IDEAL_RESIZE_PERCENT : 1;
				temp = new BitmapData(bitmapData.width*actualScaleX, bitmapData.height*actualScaleY, true, 0);
				temp.draw(bitmapData, new Matrix(actualScaleX, 0, 0, actualScaleY), null, null, null, true);
				bitmapData.dispose();
				nextScaleX *= IDEAL_RESIZE_PERCENT;
				nextScaleY *= IDEAL_RESIZE_PERCENT;
				bitmapData = temp;
			}
			
			return bitmapData;
		}
	}
}