package com.settinghead.wexpression.client.view.components.template.canvas
{
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;
	import com.settinghead.wexpression.client.model.vo.template.Layer;
	import com.settinghead.wexpression.client.model.vo.template.WordLayer;
	import com.settinghead.wexpression.client.view.components.template.TemplateEditor;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.peaceoutside.utils.ColorMath;
	
	import spark.components.BorderContainer;
	import spark.components.supportClasses.ItemRenderer;
	import spark.primitives.BitmapImage;
	
	public class TextFlowCanvas extends ItemRenderer
	{
		
		public function TextFlowCanvas()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, this_mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this_mouseOutHandler);
			this.addEventListener(FocusEvent.FOCUS_OUT, this_focusOutHandler);
			this.addEventListener("creationComplete", this_creationCompleteHandler);
			this.autoDrawBackground = false;
		}
		
		private var _templateEditor:TemplateEditor;
		public function set templateEditor(v:TemplateEditor):void{
			this._templateEditor = v;
			BindingUtils.bindProperty(this, "thickness", _templateEditor.thicknessPicker, "thickness");
			BindingUtils.bindProperty(this, "angle", _templateEditor.directionPicker, "angle");
			BindingUtils.bindProperty(this, "currentLayer", _templateEditor.layerButtons, "selectedItem");
			
		}
		
		public function get templateEditor():TemplateEditor{
			return _templateEditor;
		}
		
		private var oldMouseX:Number, oldMouseY:Number;
		private var drawingState:Boolean = false;
		private var bmpDirection:Bitmap;
		private var bmpElement:BitmapImage;
		private var bmpDirElement:BitmapImage;

		
		
		protected function this_mouseDownHandler(event:MouseEvent):void
		{
			if(isCurrentLayer){
				this.drawingState = true;
				oldMouseX = this.mouseX;
				oldMouseY = this.mouseY;
			}
		}
		
		private function get layer():WordLayer{
			return data as WordLayer;
		}
		
		protected function this_mouseUpHandler(event:MouseEvent):void
		{
			if(isCurrentLayer){
				this.drawingState = false;
			}
		}
		
		protected function this_mouseOutHandler(event:MouseEvent):void
		{
			//			Mouse.show();
			//			this.drawingState = false;
		}
		
		protected function this_focusOutHandler(event:MouseEvent):void
		{
						Mouse.hide();
						this.drawingState = false;
		}
		
		
		
		protected function this_mouseOverHandler(event:MouseEvent):void
		{
			Mouse.hide();
		}
		
		private var cursor:UIComponent;
		
		private var _angle:Number;
		private var _thickness:Number;
		[Bindable]
		public function get angle():Number{
			return _angle;
		}
		public function set angle(a:Number):void{
			this._angle = a;
			rebuildCursor();
		}
		[Bindable]
		public function get thickness():Number{
			return _thickness;
		}
		public function set thickness(t:Number):void{
			this._thickness = t;
			rebuildCursor();
		}
		
		public function set currentLayer(l:Layer):void{
			this._isCurrentLayer = (l==this.layer);
			this.mouseEnabled=_isCurrentLayer;
			if(_isCurrentLayer){
				this.alpha = 1;
			}
			else{
				this.alpha = 0.5;
				Mouse.hide();
			}

		}
		
		private var _isCurrentLayer:Boolean;
		
		public function get isCurrentLayer():Boolean{
			return _isCurrentLayer;
		}
		
		private function rebuildCursor():void{
			if(cursor!=null){
				cursor.graphics.clear();
				var a:BitmapAsset = new SmallA();
				var m:Matrix = a.transform.matrix;
				m.tx -= a.width/2;
				m.ty -= a.height/2;
				m.rotate(-angle);
				m.tx += a.width/2;
				m.ty += a.height/2;
				cursor.width = thickness;
				cursor.height = thickness;
				cursor.graphics.lineBitmapStyle(a.bitmapData,m,true,true);
				cursor.graphics.beginBitmapFill(a.bitmapData,m,true, true);
				cursor.graphics.drawCircle(0, 0, thickness/2);
				cursor.graphics.endFill();
			}
		}
		
		[Embed("SmallA.png")]
		public static var SmallA:Class;
		protected function this_mouseMoveHandler(event:MouseEvent):void
		{
			if(this.mouseX>0 && this.mouseX<this.width && this.mouseY > 0 && this.mouseY < this.height){
				this.cursor.visible = true;
				cursor.x = this.mouseX;
				cursor.y = this.mouseY;
			}
			else{
				this.drawingState = false;
				this.cursor.visible = false;
				Mouse.show();
			}
			
			if(drawingState){
				var shape:Shape = new Shape();
				var dirShape:Shape = new Shape();
				var color:uint = ColorMath.HSLToRGB(angle/BBPolarTreeVO.TWO_PI,0.5,0.5);
				shape.graphics.lineStyle(thickness,color
					,1);
				var a:BitmapAsset = new SmallA();
				var m:Matrix = a.transform.matrix;
				m.rotate(-angle);
				dirShape.graphics.lineStyle(thickness,0,0.8,true);
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
			initCursor();
			rebuildCursor();
		}
		
		private function initCursor():void{
			cursor = new UIComponent();
			cursor.depth = 999;
			cursor.graphics.clear();
			
			cursor.blendMode = BlendMode.HARDLIGHT;
			this.addElement(cursor);
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
				bmpDirection.alpha = 0.8;

				
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
						dirShape.graphics.lineStyle(1,0,0.3,false);
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
				
				bmpElement = new BitmapImage();
				bmpElement.source = layer.img;
				bmpDirElement = new BitmapImage();
				bmpDirElement.source = bmpDirection;
				bmpDirElement.alpha = 0.8;
				
				this.addElement(bmpElement);
				this.addElement(bmpDirElement);
				//this.patchLayer.patchQueue = template.patchIndex.map.getQueue(3);
			}
		}
		

	}
}