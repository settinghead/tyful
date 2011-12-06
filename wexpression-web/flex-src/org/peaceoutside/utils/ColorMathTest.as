package org.peaceoutside.utils
{
	import flexunit.framework.Assert;
	
	public class ColorMathTest
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
		public function testRGBtoHSB():void
		{
			trace((ColorMath.RGBtoHSB(0xffff00)  & 0x00FF0000) >> 16);
			trace((ColorMath.RGBtoHSB(0xff0000)  & 0x00FF0000) >> 16);
			trace((ColorMath.RGBtoHSB(0x00ff00)  & 0x00FF0000) >> 16);
			trace((ColorMath.RGBtoHSB(0x0000ff)  & 0x00FF0000) >> 16);

		}
	}
}