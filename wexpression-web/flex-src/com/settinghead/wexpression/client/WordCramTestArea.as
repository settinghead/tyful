package com.settinghead.wenwentu.client
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.codec.PNGEncoder;
	import com.settinghead.wenwentu.client.model.vo.BBPolarRootTreeVO;
	import com.settinghead.wenwentu.client.model.vo.TextShapeVO;
	import com.settinghead.wenwentu.client.model.vo.BBPolarTreeBuilder;
	import com.settinghead.wenwentu.client.model.vo.EngineWordVO;
	import com.settinghead.wenwentu.client.model.vo.WordVO;
	
	public class WordCramTestArea extends UIComponent
	{
		public function WordCramTestArea()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void {
				renderStuff();
			});
			
		}
		
		public function renderStuff():void{
			
			this.graphics.lineStyle(0.5);

			var word:WordVO = new WordVO("FREEDOMIZE",30);
			word.setFont("Vera");
			word.setColor(0x000000);
			word.setSize(100);
			var tShape:TextShapeVO = WordShaper.makeShape(word.word,100,"Vera",0);
			var eWord:EngineWordVO = new EngineWordVO(word,1,200);
			eWord.setShape(tShape,0);
			var tree:BBPolarRootTreeVO=BBPolarTreeBuilder.makeTree(tShape,0);
			var x:int = 500, y:int = 200;
			tShape.translate(x-tShape.shape.width/2,y-tShape.shape.height/2);

			
			WordShaper.rotate(tShape, 0.4);
			tree.setRotation(0.4);
			trace("x",x,"y",y,"width",tShape.shape.width,"height",tShape.shape.height);
			tree.setLocation(x,y);
			trace("tree","x",tree.getX(true)+tree.getRootX(),"y",tree.getY(true)+tree.getRootY(),"width",tree.getWidth(true),"height",tree.getHeight(true));

		

//			this.addChild(eWord.getShape().shape);
			tree.draw(this.graphics);
			
//			var testSet: TextShape = new TextShape(true,"FREEDOMIZE",0, Number(100),0);

//			var tree:BBPolarRootTree = BBPolarTreeBuilder.makeTree(testSet,0);
////			this.graphics.beginFill(0x000000);
////			this.addChild(testSet.shape);
//			this.graphics.lineStyle(0.5);
//			tree.draw(this.graphics);
////			this.graphics.drawRect(20,20,300,300);
////			this.graphics.moveTo(10,10);
////			this.graphics.lineTo(200,200);
////			this.graphics.endFill();
//			MonsterDebugger.trace(this, this.graphics);
////			MonsterDebugger.trace(this,tree);
			
		}
	}
}