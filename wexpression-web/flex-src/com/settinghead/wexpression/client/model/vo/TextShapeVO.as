//
// (BSD License) 100% Open Source see http://en.wikipedia.org/wiki/BSD_licenses
//
// Copyright (c) 2009, Martin Heidegger
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of the Martin Heidegger nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
package com.settinghead.wexpression.client.model.vo
{
	
	import com.demonsters.debugger.MonsterDebugger;
	import com.settinghead.wexpression.client.NotImplementedError;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.controls.Label;
	
	import org.as3commons.lang.Assert;
	
	import spark.components.Label;
	import spark.primitives.Rect;

	
	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class TextShapeVO implements IImageShape
	{
		[Embed(source="Vera.ttf", fontFamily="vera", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const Vera: Class;
		public static const font:Font = new Vera();
		
		private const HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );


		private static const HELPER_MATRIX: Matrix = new Matrix();
		private var _bmp:Bitmap;
		private var _textField:TextField;
		private var _size: Number;
		private var _centerX:Number, _centerY:Number, _rotation:Number = 0;
		
		public function TextShapeVO(embeddedFont: Boolean, text: String, safetyBorder: Number, size: Number, rotation: Number = 0, fontName: String = "Vera")
		{
			this._size = size;

			_textField = createTextField( fontName, text, size );
			_textField.rotation = rotation;
			
			var bounds: Rectangle = _textField.getBounds( _textField );
			HELPER_MATRIX.tx = -bounds.x + safetyBorder;
			HELPER_MATRIX.ty = -bounds.y + safetyBorder;
			
			_bmp = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0 ) );
			_bmp.bitmapData.draw( _textField );

			_bmp.x = 0;
			_bmp.y = 0;

		}
		
		private function createTextField( fontName: String, text: String, size: Number ): TextField
		{

			
			var textField: TextField = new TextField();
//			textField.setTextFormat( new TextFormat( font.fontName, size ) );
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("div{font-size: "+_size+"; font-family: "+font.fontName+"; leading: 0; text-align: center; }");
			textField.styleSheet = style;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = false;
			textField.selectable = false;
			textField.embedFonts = true;
			textField.cacheAsBitmap = true;
//			textField.text  = text;
			textField.htmlText = "<div>"+text+"</div>";
			if(text.length>10){ //TODO: this is a temporary fix
				var w:Number = textField.width;
				textField.wordWrap = true;
				textField.width = w/(text.length/10)*1.1 ;
			}
			return textField;
		}

		public function contains(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
			if(!intersects(x,y,width,height,transformed)) {
				var rX:Number = x+ width*Math.random();
				var rY:Number = y+ height*Math.random();
				if(transformed)
					return _textField.hitTestPoint(rY, rY, true);
				else
					return _bmp.hitTestPoint(rX, rY, true);
			}
				else return false;
		}
		
		public function containsPoint(x:Number, y:Number,transformed:Boolean):Boolean{
			if(transformed)
				return _textField.hitTestPoint(x,y,true);
			else{
				return _bmp.hitTestPoint(x,y,true);
			}
		}
		
		public function intersects(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
//
//			if(width<1) width = 1;
//			if(height<1) height = 1;
			if(transformed)
				throw new NotImplementedError();
			else{
				var r:Boolean = _bmp.bitmapData.hitTest(new Point(0,0),255, new Rectangle(x,y,width,height),null,255);
				return r;
			}
		}
		
//		public function getBounds2D():Rectangle {
//			return _textField.getBounds(shape.parent);
////		}
//		public function getWidth():int{
//			return _textFi.width;
//		}
//		public function getHeight():int{
//			return shape.height;
//		}
		
		public function setCenterLocation(centerX:Number,centerY:Number):void{
			this._centerX = centerX;
			this._centerY = centerY;
		}
	
		


		
		private var matrix:Matrix = new Matrix();
		
		public function get width():Number{
			return _textField.width;
		}
		public function get height():Number{
			return _textField.height;
		}
		public function get rotation():Number{
			return _rotation;
		}
		public function get centerX():Number{
			return _centerX;
		}
		public function get centerY():Number{
			return _centerY;
		}
		
		public function get textField():TextField{
			return _textField;
		}
		
		public function get objectBounds():Rectangle{
			return _textField.getBounds(_textField.parent);
		}
		
		public function rotate(rotation:Number):void{
			
			this._rotation = rotation;
		}
	}
}
