package polartree
{
	import cmodule.polartree.CLibInit;
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class AlchemyPolarTree
	{
		
		static var loader:CLibInit = new CLibInit;
		static var lib:Object = loader.init();			
		
		var ptr:*;
		
		public function AlchemyPolarTree(textShape:TextShapeVO)
		{
			var b:ByteArray = textShape.bitmapData.getPixels(
				new Rectangle(0,0,textShape.bitmapData.width,textShape.bitmapData.height));

			ptr =  lib.buildTree(b,textShape.bitmapData.width as uint, textShape.bitmapData.height as uint));
		}
		
		public function overlaps(otherTree:AlchemyPolarTree):Boolean{
			//TODO
		}
	}
}