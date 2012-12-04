package com.settinghead.tyful.client.model.vo.wordlist
{
	import com.settinghead.tyful.client.model.vo.TextShapeVO;
	
	import flash.geom.Rectangle;

	
	public class WordShaper {
		
		public static function makeShape(text:String, fontSize:Number, fontName: String = "Arial", rotation:Number=0):TextShapeVO {
			
			var result:TextShapeVO = new TextShapeVO(true,text,0,fontSize,rotation,fontName);
			return result;
		}
		
		private static function isTooSmall(shape:TextShapeVO, minShapeSize:int):Boolean {
			var r:Rectangle = shape.objectBounds;
			
			// Most words will be wider than tall, so this basically boils down to
			// height.
			// For the odd word like "I", we check width, too.
			return r.height < minShapeSize || r.width < minShapeSize;
		}
		
		public static function rotate(shape:TextShapeVO, rotation:Number):TextShapeVO {
			if (rotation == 0) {
				return shape;
			}
			
			shape.rotate(rotation);
			
			return shape;
		}
	
		
//		public static function moveToOrigin(shape:TextShape):TextShape {
//			var rect:Rectangle= shape.shape.getBounds(shape.shape.parent);
//			
//			if (rect.x == 0&& rect.y == 0) {
//				return shape;
//			}
//			
//			 shape.shape.x-=rect.x;
//			 shape.shape.y-=rect.y;
//			 return shape;
//		}
	}
}