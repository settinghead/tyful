package com.settinghead.wexpression.client
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	internal class WordShaper {
		
		private static function makeShape(text:String, fontSize:Number, fontName: String = "Arial"):TextSet {
			
			var result:TextSet = new TextSet(true,text,0,fontSize,0,fontName);
			return result;
		}
		
		private static function isTooSmall(shape:TextSet, minShapeSize:int):Boolean {
			var r:Rectangle = shape.shape.getBounds();
			
			// Most words will be wider than tall, so this basically boils down to
			// height.
			// For the odd word like "I", we check width, too.
			return r.height < minShapeSize || r.width < minShapeSize;
		}
		
		public static function rotate(shape:TextSet, rotation:Number, centerX:Number,
									  centerY:Number):TextSet {
			if (rotation == 0) {
				return shape;
			}
			
//			var point:Point=new Point(shape.shape.x+shape.shape.width/2, shape.shape.y+shape.shape.height/2);
			var m:Matrix=shape.shape.transform.matrix;
			m.tx -= centerX;
			m.ty -= centerY;
			m.rotate = rotation; // was a missing "=" here
			m.tx += centerX;
			m.ty += centerY;
			shape.shape.transform.matrix=m;
			
			return shape;
		}
		
		function rotateAroundCenter (ob:*, angleDegrees) {
			
		}
		
		public static function moveToOrigin(shape:TextSet):TextSet {
			var rect:Rectangle= shape.shape.getBounds();
			
			if (rect.x == 0&& rect.y == 0) {
				return shape;
			}
			
			 shape.shape.x-=rect.x;
			 shape.shape.y-=rect.y;
			 return shape;
		}
	}
}