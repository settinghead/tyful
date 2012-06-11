package com.settinghead.groffle.client.model.algo.tree;	
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

	
/**
 * @author Martin Heidegger
 * @version 1.0
 */
class BitmapShapeVO implements IImageShape
{	
	
	private static inline var HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );
/*	private static inline var  HELPER_MATRIX: Matrix = new Matrix();*/
	private var _bmp:Bitmap;
	private var _textField:TextField;
	private var _size: Float;
	private var _centerX:Float; private var _centerY:Float; private var _rotation:Float;
		
	private var origin:Point;
	private var testRect:Rectangle;
	private var matrix:Matrix;		
	
	public function new(bmp:BitmapData, rotation: Float = 0)
	{
		_rotation = 0;
		origin =  new Point(0,0);
		testRect = new Rectangle(0,0,1,1);
		matrix = new Matrix();
	
		_bmp = new Bitmap( bmp );

		_bmp.x = 0;
		_bmp.y = 0;

	}
		
	private function createTextField( fontName: String, text: String, size: Float ): TextField
	{

			
		var textField: TextField = new TextField();
//			textField.setTextFormat( new TextFormat( font.fontName, size ) );
		var style:StyleSheet = new StyleSheet();
		style.parseCSS("div{font-size: "+_size+"; font-family: "+fontName+"; leading: 0; text-align: center; padding: 0; margin: 0; }");
		textField.styleSheet = style;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.background = false;
		textField.selectable = false;
		textField.embedFonts = true;
		textField.cacheAsBitmap = false;
		textField.x = 0;
		textField.y = 0;
		textField.antiAliasType = AntiAliasType.ADVANCED;
//			textField.text  = text;
		textField.htmlText = "<div>"+text+"</div>";
		textField.filters = [				new DropShadowFilter(0.5,45,0,1.0,0.5,0.5) 
];
		if(text.length>11){ //TODO: this is a temporary fix
			var w:Float = textField.width;
			textField.wordWrap = true;
			textField.width = w/(text.length/11)*1.1 ;
		}
		return textField;
	}

	public function contains(x:Float, y:Float, width:Float, height:Float, rotation:Float, transformed:Bool):Bool {
		if(rotation!=0) throw "NotImplementedError";
		if(!intersects(x,y,width,height,transformed)) {
			var rX:Float = x+ width*Math.random();
			var rY:Float = y+ height*Math.random();
			if(transformed)
				return _textField.hitTestPoint(rY, rY, true);
			else
				return _bmp.hitTestPoint(rX, rY, true);
		}
			else return false;
	}
		
	public function containsPoint(x:Float, y:Float,transformed:Bool,  refX:Float=-1,refY:Float=-1):Bool{
//			if(transformed)
//				return _textField.hitTestPoint(x,y,true);
//			else{
//				return _bmp.hitTestPoint(x,y,true);
//			}
		return _bmp.bitmapData.getPixel32(Std.int(x),Std.int(y)) > 0x00000000;
	}
	
	public function intersects(x:Float, y:Float, width:Float, height:Float,transformed:Bool):Bool {
//
//			if(width<1) width = 1;
//			if(height<1) height = 1;
		if(transformed)
			throw "NotImplementedError";
		else{
//				for(var xx:Float = x; xx<x+width;xx++)
//					for(var yy:Float = y; yy<y+height;yy++){
//						if(_bmp.bitmapData.getPixel(xx,yy)!=0xffffff)
//							return true;
//					}
//				return false;
			testRect.x = x;
			testRect.y = y;
			testRect.width = width;
			testRect.height = height;
			var r:Bool = _bmp.bitmapData.hitTest(origin,1, testRect,null,1);
			return r;
		}
	}
		
	public function setCenterLocation(centerX:Float,centerY:Float):Void{
		this._centerX = centerX;
		this._centerY = centerY;
	}
		
	public function getWidth():Float{
		return _bmp.width;
	}
	public function getHeight():Float{
		return _bmp.height;
	}
	public function getRotation():Float{
		return _rotation;
	}
	public function getCenterX():Float{
		return _centerX;
	}
	public function getCenterY():Float{
		return _centerY;
	}
		
	public function getTxtField():TextField{
		return _textField;
	}
		
	public function getObjectBounds():Rectangle{
		return _textField.getBounds(_textField.parent);
	}
		
	public function rotate(rotation:Float):Void{
			
		this._rotation = rotation;
	}
}
