package com.settinghead.wexpression.client
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import fl.motion.Color;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.codec.PNGEncoder;
	
	public class WordCramRenderArea extends UIComponent
	{
		[Embed(source="Vera.ttf", fontFamily="vera")]
		public static const fontClass: Class;
		
		public function WordCramRenderArea()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void {
				
				renderStuff();
			});
			
		}
		
		public function renderStuff():void{
			var testSet: TextSet = new TextSet(true,"Foxy!",0, 100,0,"vera");
			this.addChild(testSet.shape);

			graphics.beginFill(0x000000, 0.5);
			this.graphics.drawRect(0,0,200,200);
			this.graphics.endFill();
			
			MonsterDebugger.trace(this, testSet.shape);
			
		}
	}
}