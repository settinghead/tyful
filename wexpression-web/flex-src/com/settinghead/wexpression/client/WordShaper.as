package com.settinghead.wexpression.client
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	internal class WordShaper {
		
		public static function makeShape(text:String, fontSize:Number, fontName: String = "Arial", rotation:Number=0):TextShape {
			
			var result:TextShape = new TextShape(true,text,0,fontSize,rotation,fontName);
			return result;
		}
		
		private static function isTooSmall(shape:TextShape, minShapeSize:int):Boolean {
			var r:Rectangle = shape.shape.getBounds(shape.shape.parent);
			
			// Most words will be wider than tall, so this basically boils down to
			// height.
			// For the odd word like "I", we check width, too.
			return r.height < minShapeSize || r.width < minShapeSize;
		}
		
		public static function rotate(shape:TextShape, rotation:Number):TextShape {
			if (rotation == 0) {
				return shape;
			}
			
			var centerX:Number=shape.shape.x+shape.shape.width/2;
			var centerY:Number = shape.shape.y+shape.shape.height/2;
			
//			var point:Point=new Point(shape.shape.x+shape.shape.width/2, shape.shape.y+shape.shape.height/2);
			var m:Matrix=shape.shape.transform.matrix;
			m.tx -= centerX;
			m.ty -= centerY;
			m.rotate(-rotation); // was a missing "=" here
			m.tx += centerX;
			m.ty += centerY;
			shape.shape.transform.matrix=m;
			
			return shape;
		}
	
		
		public static function moveToOrigin(shape:TextShape):TextShape {
			var rect:Rectangle= shape.shape.getBounds(shape.shape.parent);
			
			if (rect.x == 0&& rect.y == 0) {
				return shape;
			}
			
			 shape.shape.x-=rect.x;
			 shape.shape.y-=rect.y;
			 return shape;
		}
	}
}