package com.settinghead.groffle.client.view.components.template.canvas
{
	import com.notifications.Notification;
	import com.settinghead.groffle.client.model.algo.tree.BBPolarTreeVO;
	import com.settinghead.groffle.client.model.vo.template.Layer;
	import com.settinghead.groffle.client.model.vo.template.WordLayer;
	import com.settinghead.groffle.client.view.components.template.TemplateEditor;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	import flashx.textLayout.elements.BreakElement;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.peaceoutside.utils.ColorMath;
	
	import spark.components.BorderContainer;
	import spark.components.supportClasses.ItemRenderer;
	import spark.primitives.BitmapImage;
	import com.settinghead.groffle.client.view.components.template.canvas.assets.Assets;
	
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
			BindingUtils.bindProperty(this, "thickness", _templateEditor, "thickness");
			BindingUtils.bindProperty(this, "angle", _templateEditor, "angle");
			BindingUtils.bindProperty(this, "colorPattern", _templateEditor, "colorPattern");
			BindingUtils.bindProperty(this, "currentLayer", _templateEditor.layerButtons, "selectedItem");	
			BindingUtils.bindProperty(this, "currentDrawingTool", _templateEditor, "currentDrawingTool");	
		}
		
		public function get templateEditor():TemplateEditor{
			return _templateEditor;
		}
		
		private var oldMouseX:Number, oldMouseY:Number;
		private var drawingState:Boolean = false;
		private var bmpDirection:Bitmap;
		private var bmpElement:BitmapImage;
		private var bmpDirElement:BitmapImage;
		private var colorSheetElement:BitmapImage;
		private var _currentDrawingTool:int;
		private var brushRegion:Array = [Number.POSITIVE_INFINITY,Number.POSITIVE_INFINITY,Number.NEGATIVE_INFINITY,Number.NEGATIVE_INFINITY];
		
	
		
		private var a:BitmapAsset = Assets.getSmallA();
		
		private static var HintShowed:Boolean = false;
		
		protected function this_mouseDownHandler(event:MouseEvent):void
		{
//			Alert.show(layer.direction.getPixel32(mouseX,mouseY).toString());
			if(isCurrentLayer){
				this.drawingState = true;
				oldMouseX = this.mouseX;
				oldMouseY = this.mouseY;
				stage.focus = this;

			}
		}
		
		public function get layer():WordLayer{
			return data as WordLayer;
		}
		
		protected function this_mouseUpHandler(event:MouseEvent):void
		{
			
			if(isCurrentLayer){
				this.drawingState = false;
				if(this.currentDrawingTool==TemplateEditor.BRUSH){
					//redraw direciton map so it's more readable
//					Alert.show(this.brushRegion[0].toString()+", "+
//						this.brushRegion[1].toString()+", "+
//						this.brushRegion[2].toString()+", "+
//						this.brushRegion[3].toString());
					redrawDireciton(brushRegion[0],brushRegion[1],brushRegion[2],brushRegion[3]);
					resetDrawingRegion();
				}
				
				if(!HintShowed){
				    Notification.show("Use 'A' and 'S' on the keyboard to rotate text direction for the bursh, and use 'Z' and X' to increase or decrease bruth thickness."
					,"Brush Hint",20000,null,null,this);
					HintShowed = true;
				}
				
			}
			
		}
		
		protected function this_mouseOutHandler(event:MouseEvent):void
		{
//			if(this.drawingState && this.currentDrawingTool==TemplateEditor.BRUSH){
//				//redraw direciton map so it's more readable
//				redrawDireciton(brushRegion[0],brushRegion[1],brushRegion[2],brushRegion[3]);
//				resetDrawingRegion();
//			}
			Mouse.show();
			//this.drawingState = false;
		}
		
		protected function this_focusOutHandler(event:FocusEvent):void
		{
			if(this.cursor!=null)this.cursor.visible = false;
			this.drawingState = false;
		}
		
		protected function this_mouseOverHandler(event:MouseEvent):void
		{

			Mouse.hide();
		}
		
		private var cursor:UIComponent;
		
		private var _angle:Number;
		private var _thickness:Number;
		private var _colorPattern:BitmapData;
		[Bindable]
		public function get angle():Number{
			return _angle;
		}
		public function set angle(a:Number):void{
			if(this._angle!=a){
				this._angle = a;
				rebuildCursor();
			}
		}
		[Bindable]
		public function get thickness():Number{
			return _thickness;
		}
		public function set thickness(t:Number):void{
			if(this._thickness!=t)
			{
				this._thickness = t;
				rebuildCursor();
			}
		}
		[Bindable]
		public function get colorPattern():BitmapData{
			return _colorPattern;
		}
		public function set colorPattern(p:BitmapData):void{
			this._colorPattern = p;
			rebuildCursor();
		}
		
		public function get currentDrawingTool():int{
			return _currentDrawingTool;
		}
		public function set currentDrawingTool(v:int):void{
			_currentDrawingTool = v;
			rebuildCursor();
		}
		
		public function set currentLayer(l:Layer):void{
			this._isCurrentLayer = (l==this.layer);
			this.mouseEnabled=_isCurrentLayer;
			if(_isCurrentLayer){
				this.alpha = 1;
				if(this.cursor!=null)this.cursor.visible=true;
			}
			else{
				this.alpha = 0.5;
				if(this.cursor!=null)this.cursor.visible = false;
			}

		}
		
		private var _isCurrentLayer:Boolean;
		
		public function get isCurrentLayer():Boolean{
			return _isCurrentLayer;
		}
		
		private function rebuildCursor():void{
			if(cursor!=null){
				switch(currentDrawingTool){
					case TemplateEditor.BRUSH:
						var colorLayer:UIComponent = new UIComponent();
						colorLayer.graphics.clear();
						colorLayer.x = 0;
						colorLayer.y = 0;
						colorLayer.width = thickness;
						colorLayer.height = thickness;
						colorLayer.graphics.lineBitmapStyle(colorPattern,null,true,true);
						colorLayer.graphics.beginBitmapFill(colorPattern,null,true,true);
						colorLayer.graphics.drawCircle(0, 0, thickness/2);
						colorLayer.graphics.endFill();
						//var a:BitmapAsset = new SmallA();

						var textLayer:UIComponent = new UIComponent();
						textLayer.graphics.clear();
						var m:Matrix = a.transform.matrix;
						m.tx -= a.width/2;
						m.ty -= a.height/2;
						m.rotate(-angle);
						m.tx += a.width/2;
						m.ty += a.height/2;
						textLayer.width = thickness;
						textLayer.height = thickness;
						textLayer.x = 0;
						textLayer.y = 0;
						textLayer.graphics.lineBitmapStyle(a.bitmapData,m,true,true);
						textLayer.graphics.beginBitmapFill(a.bitmapData,m,true, true);
						textLayer.graphics.drawCircle(0, 0, thickness/2);
						textLayer.graphics.endFill();
						
						while(cursor.numChildren>0)
							cursor.removeChildAt(0);
						cursor.graphics.clear();
						
						cursor.width = colorLayer.width;
						cursor.height = colorLayer.height;
						cursor.addChild(colorLayer);
						cursor.addChild(textLayer);
						break;
					case TemplateEditor.FILL:
						break;
					case TemplateEditor.ERASE:
						var blankLayer:UIComponent = new UIComponent();
						blankLayer.graphics.clear();
						blankLayer.x = 0;
						blankLayer.y = 0;
						blankLayer.width = thickness;
						blankLayer.height = thickness;
						blankLayer.graphics.beginFill(0xffffff,1);
						blankLayer.graphics.drawCircle(0, 0, thickness/2);
						blankLayer.graphics.endFill();
						cursor.addChild(blankLayer);
						break;
				}

				
			}
		}

		
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
				var colorShape:Shape = new Shape();
				switch(currentDrawingTool){
					case TemplateEditor.BRUSH:
						//update drawing state
						updateDrawingRegion();
						
						var blendMode:String = templateEditor.chkLockBoundary.selected?
							BlendMode.SHADER :BlendMode.NORMAL;
						
						if(templateEditor.chkDrawAngle.selected){
							var dirColor:uint = ColorMath.HSLtoRGB(angle/BBPolarTreeVO.TWO_PI*360,0.5,0.5);
							shape.graphics.lineStyle(thickness, dirColor, 1);
							dirShape.graphics.lineStyle(thickness,0,0.5,true);
	//						var a:BitmapAsset = new SmallA();
							var m:Matrix = a.transform.matrix;
							m.rotate(-angle);
							dirShape.graphics.lineBitmapStyle(a.bitmapData,m,true,true);
							shape.graphics.moveTo(oldMouseX, oldMouseY);
							dirShape.graphics.moveTo(oldMouseX, oldMouseY);
							shape.graphics.lineTo(this.mouseX,this.mouseY);
							dirShape.graphics.lineTo(this.mouseX,this.mouseY);
							
							layer.direction.draw(shape,null,null,blendMode);
							bmpDirection.bitmapData.draw(dirShape,null,null,blendMode);
							
						}
						if(templateEditor.chkDrawColor.selected){
							colorShape.graphics.lineStyle(thickness,0,1,true);
							colorShape.graphics.lineBitmapStyle(colorPattern,m,true,true);
							colorShape.graphics.moveTo(oldMouseX, oldMouseY);
							colorShape.graphics.lineTo(this.mouseX,this.mouseY);
							layer.colorSheet.bitmapData.draw(colorShape,null,null,blendMode);
						}
						
						break;
					case TemplateEditor.FILL:
						break;
					case TemplateEditor.ERASE:
						shape.graphics.lineStyle(thickness, 0xff0000, 1);
						colorShape.graphics.lineStyle(thickness, 0xff0000, 1);
						dirShape.graphics.lineStyle(thickness, 0xff0000, 1);
						shape.graphics.moveTo(oldMouseX, oldMouseY);
						dirShape.graphics.moveTo(oldMouseX, oldMouseY);
						colorShape.graphics.moveTo(oldMouseX, oldMouseY);
						shape.graphics.lineTo(this.mouseX,this.mouseY);
						dirShape.graphics.lineTo(this.mouseX,this.mouseY);
						colorShape.graphics.lineTo(this.mouseX,this.mouseY);
						layer.direction.draw(shape,null,null,BlendMode.ERASE);
						bmpDirection.bitmapData.draw(dirShape,null,null,BlendMode.ERASE);
						layer.colorSheet.bitmapData.draw(colorShape,null,null,BlendMode.ERASE);
						break;
				}
				
				

				
				oldMouseX = this.mouseX;
				oldMouseY = this.mouseY;
			}
		}
		
		protected function this_creationCompleteHandler(event:FlexEvent):void
		{
			this._templateEditor.initColors();
			populateLayer();
			initCursor();
			this.colorPattern = _templateEditor.colorPattern;
			rebuildCursor();
			if(isCurrentLayer)
				stage.focus = this;

		}
		
		private function initCursor():void{
			cursor = new UIComponent();
			cursor.depth = 999;
			cursor.graphics.clear();
			
			//cursor.blendMode = BlendMode.HARDLIGHT;
			cursor.alpha = 0.9;
			this.addElement(cursor);
		}
		
		private function populateLayer():void{
			if(this.layer!=null)
			{
				
				for(var i:int=0;i<this.numChildren;i++)
					this.removeChildAt(0);
				if((layer as WordLayer).direction!=null){
					layer.direction = (layer as WordLayer).direction;
				}
				else{
					layer.direction = new BitmapData(layer.width, layer.height, true, 0xffffff);
//					layer.direction.visible = false;
				}
				
				
				bmpDirection = new Bitmap(new BitmapData(layer.width, layer.height, true, 0x00ffffff));

				
				this.width = layer.width;
				this.height = layer.height;
				bmpDirection.x =0; bmpDirection.y = 0;
				
				redrawDireciton(0,0,layer.direction.width,layer.direction.height);
				
				
//				bmpElement = new BitmapImage();
//				bmpElement.source = new Bitmap(layer.direction);
				colorSheetElement = new BitmapImage();
				colorSheetElement.source = layer.colorSheet;
				bmpDirElement = new BitmapImage();
				bmpDirElement.source = bmpDirection;
				
//				this.addElement(bmpElement);
				this.addElement(colorSheetElement);
				this.addElement(bmpDirElement);
				//this.patchLayer.patchQueue = template.patchIndex.map.getQueue(3);
			}
		}
		
		private function redrawDireciton(xs:Number,ys:Number,xe:Number,ye:Number):void{
//			var str:String = "";
			//expand the region a little to align with global grid lines
			xs = xs - xs%a.width; if(xs<0) xs = 0;
			ys = ys - ys%a.height; if(ys<0) ys =0;
			xe = xe + xe%a.width; if (xe>=layer.width) xe = layer.width-1;
			ye = ye + ye%a.height; if(ye>=layer.height) ye = layer.height-1;
			var dirErase:Shape = new Shape();
			dirErase.graphics.lineStyle(1,0xff0000);
			dirErase.graphics.beginFill(0xff0000,1);
			dirErase.graphics.drawRect(xs,ys,xe-xs,ye-ys);
			dirErase.graphics.endFill();
			bmpDirection.bitmapData.draw(dirErase,new Matrix(),null,BlendMode.ERASE);
		
			for(var w:Number = xs; w<xe;w+=a.width){
				for(var h:Number = ys; h<ye;h+=a.height){
					var m:Matrix = new Matrix();

					var angle:Number = layer.getHue(w+a.width/2, h+a.height/2)*BBPolarTreeVO.TWO_PI;
//					str = str+" "+angle.toString();
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
							if(layer.containsPoint(ox+w,oy+h,false,-1,-1,1)){
								dirShape.graphics.moveTo(ox, oy);
								dirShape.graphics.lineTo(ox,oy+1);
							}
						}
					m = new Matrix();
					m.tx += w;
					m.ty += h;
//					dirShape.x = w;
//					dirShape.y = h;
					bmpDirection.bitmapData.draw(dirShape,m);
				}
			}

		}
		
		private function resetDrawingRegion():void{
			this.brushRegion[0]=this.brushRegion[1]=Number.POSITIVE_INFINITY;		
			this.brushRegion[2]=this.brushRegion[3]=Number.NEGATIVE_INFINITY;
		}
		
		private function updateDrawingRegion():void{
			var x1:Number = this.mouseX-thickness/2;
			var y1:Number = this.mouseY-thickness/2;
			var x2:Number = this.mouseX+thickness/2;
			var y2:Number = this.mouseY+thickness/2;
			if(x1<0) x1=0; if(y1<0) y1=0; if(x2>=layer.width) x2=layer.width-1; if(y2>=layer.height) y2=layer.height-1;
			if(x1<this.brushRegion[0]) this.brushRegion[0] = x1;
			if(y1<this.brushRegion[1]) this.brushRegion[1] = y1;
			if(x2>this.brushRegion[2]) this.brushRegion[2] = x2;
			if(y2>this.brushRegion[3]) this.brushRegion[3] = y2;
		}
		
	}
}