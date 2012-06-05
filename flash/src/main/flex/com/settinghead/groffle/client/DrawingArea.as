package com.settinghead.groffle.client
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.codec.PNGEncoder;
	
	public class DrawingArea extends UIComponent
	{
		private var isDrawing:Boolean = false;
		private var x1:int;
		private var y1:int;
		private var x2:int;
		private var y2:int;
		
		
		public var drawColor:uint = 0x000000;
		
		public function DrawingArea()
		{
			super();
			
			
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void {
				erase();
			});
			
			addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				x1 = mouseX;
				y1 = mouseY;
				isDrawing = true;
			});
			
			addEventListener(MouseEvent.MOUSE_MOVE, function(event:MouseEvent):void {
				if (!event.buttonDown)
				{
					isDrawing = false;
				}
				
				x2 = mouseX;
				y2 = mouseY;
				if (isDrawing)
				{
					graphics.lineStyle(2, drawColor);
					graphics.moveTo(x1, y1);
					graphics.lineTo(x2, y2);
					x1 = x2;
					y1 = y2;
				}
			});
			
			addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void {
				isDrawing = false;
			});
		}
		
		public function erase():void
		{
			graphics.clear();
			
			graphics.beginFill(0xffffff, 0.00001);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		public function save():void
		{
			var bd:BitmapData = new BitmapData(width, height);
			bd.draw(this);
			
			var ba:ByteArray = (new PNGEncoder()).encode(bd);
			(new FileReference()).save(ba, "doodle.png");
		}
		
	}
}