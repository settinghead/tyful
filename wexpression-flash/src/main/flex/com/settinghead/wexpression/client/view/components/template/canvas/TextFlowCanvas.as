package com.settinghead.wexpression.client.view.components.template.canvas
{
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.template.WordLayer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.core.BitmapAsset;
	import mx.events.FlexEvent;
	
	import org.peaceoutside.utils.ColorMath;
	
	import spark.components.BorderContainer;
	
	public class TextFlowCanvas extends BorderContainer
	{
		
		public function TextFlowCanvas(l:WordLayer)
		{
			super();
			this.layer = l;
			this.addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
		}
		
		private var oldMouseX:Number, oldMouseY:Number;
		private var drawingState:Boolean = false;
		private var layer:WordLayer;
//		private var bmp:Bitmap;
		private var bmpDirection:Bitmap;
		
		protected function this_mouseDownHandler(event:MouseEvent):void
		{
			this.drawingState = true;
			oldMouseX = this.mouseX;
			oldMouseY = this.mouseY;
		}
		
		
		protected function this_mouseUpHandler(event:MouseEvent):void
		{
			this.drawingState = false;
			
		}
		
		[Bindable]
		public var angle:Number;
		[Bindable]
		public var thickness:Number;
		
		[Embed("SmallA.png")]
		public static var SmallA:Class;
		protected function this_mouseMoveHandler(event:MouseEvent):void
		{
			if(drawingState){
				var shape:Shape = new Shape();
				var dirShape:Shape = new Shape();
				var color:uint = ColorMath.HSLToRGB(angle/BBPolarTreeVO.TWO_PI,0.5,0.5);
				shape.graphics.lineStyle(thickness,color
					,1);
				var a:BitmapAsset = new SmallA();
				var m:Matrix = a.transform.matrix;
				m.rotate(angle);
				dirShape.graphics.lineStyle(thickness,0,0.7,true);
				dirShape.graphics.lineBitmapStyle(a.bitmapData,m,true,true);
				shape.graphics.moveTo(oldMouseX, oldMouseY);
				dirShape.graphics.moveTo(oldMouseX, oldMouseY);
				shape.graphics.lineTo(this.mouseX,this.mouseY);
				dirShape.graphics.lineTo(this.mouseX,this.mouseY);
				
				
				layer.img.bitmapData.draw(shape);
				bmpDirection.bitmapData.draw(dirShape);
				
				oldMouseX = this.mouseX;
				oldMouseY = this.mouseY;
			}
		}
		
		protected function this_creationCompleteHandler(event:FlexEvent):void
		{
			populateLayer();
		}
		
		private function populateLayer():void{
			if(this.layer!=null)
			{
				if(layer.img!=null) this.removeChild(layer.img);
				if(bmpDirection!=null) this.removeChild(bmpDirection);
				
				if((layer as WordLayer).img!=null){
					layer.img = (layer as WordLayer).img;
				}
				else{
					layer.img = new Bitmap(new BitmapData(layer.width, layer.height, true, 0xffffff));
					layer.img.visible = false;
				}
				
				bmpDirection = new Bitmap(new BitmapData(layer.width, layer.height, true, 0xffffff));
				
				this.width = layer.width;
				this.height = layer.height;
				bmpDirection.x = layer.img.x=0; bmpDirection.y = layer.img.y = 0;
				this.addChild(layer.img);
				
				this.addChild(bmpDirection);
				//					this.patchLayer.patchQueue = template.patchIndex.map.getQueue(3);
			}
			
		}
	}
}