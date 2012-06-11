package {
	import cmodule.polartree.CLibInit;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import polartree.BBPolarRootTreeVO;
	import polartree.BBPolarTreeBuilder;
	import polartree.TextShapeVO;

	public class EchoTest extends Sprite
	{
	
		public function EchoTest()
		{

//			var bmpd:BitmapData  = new BitmapData(800,600,true,0xfe000000);
			
			var t1:TextShapeVO = new TextShapeVO(true,"Hi",0,120,0,"arial");
			var t2:TextShapeVO = new TextShapeVO(true,"Hello",0,20,0,"arial");
			
			
			
		}
	}
}
