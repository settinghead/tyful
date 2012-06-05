package com.settinghead.groffle.client.view.components
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	import mx.skins.spark.ProgressBarSkin;
	
	public class ColoredProgressBarSkin extends ProgressBarSkin
	{
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			graphics.clear();
			
			var fullWidth:int = w;
			if (parent != null && (parent as UIComponent).mask != null)
				fullWidth = (parent as UIComponent).mask.width;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(fullWidth, h);
			var colors:Array = [0x00ff00, 0x00ff00, 0xff0000, 0xff0000];
			
			this.graphics.lineStyle();
			this.graphics.beginGradientFill(GradientType.LINEAR, colors, [1,1,1,1], [0,128,128,255], matrix);
			this.graphics.drawRoundRect(2, 2, w - 4, h - 4, h - 4); 
		}	}
}