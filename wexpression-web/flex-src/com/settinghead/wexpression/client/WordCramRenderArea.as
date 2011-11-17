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
		public function WordCramRenderArea()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void {
				renderStuff();
			});
			
		}
		
		public function renderStuff():void{
			var testSet: TextShape = new TextShape(true,"FREEDOMIZE",0, Number(100),0);

			var tree:BBPolarRootTree = BBPolarTreeBuilder.makeTree(testSet,0);
			this.graphics.beginFill(0x000000);
//			this.addChild(testSet.shape);
			this.graphics.lineStyle(0.5);
			tree.draw(this.graphics);
//			this.graphics.drawRect(20,20,300,300);
//			this.graphics.moveTo(10,10);
//			this.graphics.lineTo(200,200);
			this.graphics.endFill();
			MonsterDebugger.trace(this, this.graphics);
//			MonsterDebugger.trace(this,tree);
			
		}
	}
}