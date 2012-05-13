package com.settinghead.wexpression.client.model.vo.template
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import flexunit.framework.Assert;
	
	public class WordLayerTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testContains():void
		{
			var t:TemplateVO = new TemplateVO(null);
			t.width = 1000;
			t.height = 1000;
			var l:WordLayer = new WordLayer("layer0",t);
			var s:Sprite = new Sprite();
			var r:Rectangle = new Rectangle(400,400,200,200);
			s.graphics.beginFill(0xcccccc, 1.0);
			s.graphics.drawRect(400,400,200,200);
			s.graphics.endFill();
			l.img.bitmapData.draw(s);
			Assert.assertTrue(l.contains(41,41,10,10,0,false));
			Assert.assertTrue(l.contains(50,40,10,5,0,false));
			Assert.assertFalse(l.contains(500,400,100,50,Math.PI/2,false));
			
		}
	}
}