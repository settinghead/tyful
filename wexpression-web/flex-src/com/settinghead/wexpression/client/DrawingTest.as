package com.settinghead.wexpression.client
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import fl.motion.Color;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.codec.PNGEncoder;
	
	public class DrawingTest extends UIComponent
	{
		public function DrawingTest()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void {
				renderStuff();
			});
			
		}
		
		public function renderStuff():void{
			
			var point1:Point = new Point(0, 0);
			var point2:Point = new Point(256, 0);
			var point3:Point = new Point(0, 256);
			var point4:Point = new Point(256, 256);
			
			var verticies:Vector.<Number> = Vector.<Number>([point1.x, point1.y, point2.x, point2.y, point3.x, point3.y, point4.x, point4.y]);
			var indices:Vector.<int> = Vector.<int>([0, 1, 2, 1, 3, 2]);
			
//			var scene:Sprite = new Sprite();
			
			this.graphics.beginFill(0x990000, 1);
			//this.graphics.drawTriangles(verticies, indices);
			
			this.graphics.moveTo(10,10);
			this.graphics.lineTo(200,20);
			this.graphics.lineTo(190,220);
			this.graphics.lineTo(20,180);
			this.graphics.lineTo(10,10);
			
			this.graphics.endFill();
			
//			addChild(scene);
			
		}
	}
}