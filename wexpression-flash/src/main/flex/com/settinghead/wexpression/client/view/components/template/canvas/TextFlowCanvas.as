package com.settinghead.wexpression.client.view.components.template.canvas
{
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.template.WordLayer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.peaceoutside.utils.ColorMath;
	
	import spark.components.BorderContainer;
	import spark.primitives.BitmapImage;
	
	public class TextFlowCanvas extends UIComponent
	{
		
		public function TextFlowCanvas(l:WordLayer)
		{
			super();
			this.layer = l;
			this.addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
			this.addEventListener("creationComplete", this_creationCompleteHandler);
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
				
				for(var i:int=0;i<this.numChildren;i++)
					this.removeChildAt(0);
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
				
				for(var w:Number = 0; w<layer.img.width;w+=a.width){
					for(var h:Number = 0; h<layer.img.height;h+=a.height){
						var a:BitmapAsset = new SmallA();
						var m:Matrix = new Matrix();
						
						var angle:Number = layer.getHue(w+a.width/2, h+a.height/2)*BBPolarTreeVO.TWO_PI;
						m.tx -= a.width/2;
						m.ty -= a.height/2;
						m.rotate(-angle);
						m.tx += a.width/2;
						m.ty += a.height/2;
						var dirShape:Shape = new Shape();
						dirShape.graphics.lineStyle(1,0,0.7,false);
						dirShape.graphics.lineBitmapStyle(a.bitmapData,m,true,true);

						for(var ox:Number = 0; ox<a.width;ox++)
							for(var oy:Number = 0; oy<a.height;oy++){
								if(layer.getBrightness(ox+w,oy+h)>0){
									dirShape.graphics.moveTo(ox, oy);
									dirShape.graphics.lineTo(ox,oy+1);
								}
							}
						m = new Matrix();
						m.tx += w;
						m.ty += h;
						bmpDirection.bitmapData.draw(dirShape,m);

					}
				}
				
				this.addChild(layer.img);
				this.addChild(bmpDirection);
				//this.patchLayer.patchQueue = template.patchIndex.map.getQueue(3);
			}
		}
		private function addBitmap(bm:Bitmap ):void	
		{
			var bitmapHolder:UIComponent = new UIComponent();	
			var mySprite:Sprite = new Sprite();
			mySprite.addChild(bm);
			bitmapHolder.addChild(mySprite);
			this.addChild(bitmapHolder);
			
		}

	}
}