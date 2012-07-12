package polartree
{
	import cmodule.polartree.CLibInit;
	
	import com.settinghead.tyful.client.model.vo.TextShapeVO;
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;

	public class AlchemyPolarTree
	{
		
		private static var loader:CLibInit = new CLibInit;
		private static var lib:Object = loader.init();			
		public static const TWO_PI:Number = Math.PI *2;
		
		private var ptr:*;
		private var _rotation:Number = 0;
		public function AlchemyPolarTree(textShape:TextShapeVO, swelling:int)
		{
			var b:ByteArray = textShape.bitmapData.getPixels(
				new Rectangle(0,0,textShape.bitmapData.width,textShape.bitmapData.height));
			ptr =  
				lib.buildTree(b,textShape.bitmapData.width as uint, textShape.bitmapData.height as uint);
		}
		
		public function overlaps(otherTree:AlchemyPolarTree):Boolean{
			return  lib.overlaps(this.ptr, otherTree.ptr);

		}
		
		public function setRotation(r:Number):void{
			lib.setRotation(this.ptr, r);
			this._rotation = r;
		}
		
		public function setLocation(x:int, y:int):void{
			lib.setLocation(this.ptr, x, y);
		}
		
		public function getRotation():Number{
			return _rotation;
		}
	}
}