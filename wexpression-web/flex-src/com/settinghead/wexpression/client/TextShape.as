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
package com.settinghead.wexpression.client
{
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import spark.primitives.Rect;

	
	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class TextShape implements ImageShape
	{
		
		private const HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );


		private static const HELPER_MATRIX: Matrix = new Matrix();
		private var _bmp:Bitmap;
		private var _object: Sprite;
		private var _shape: Sprite;
		private var _textField:TextField;
//		private final var _bmp:Bitmap;
		
		public function TextShape(embeddedFont: Boolean, text: String, safetyBorder: Number, size: Number, rotation: Number = 0, fontName: String = "Vera")
		{
			_object = new Sprite();
			//_object.cacheAsBitmap = true;
			_textField = createTextField( fontName, embeddedFont, text, size );
			_textField.rotation = rotation;
			_object.addChild( _textField );
//			_object.filters = [ new GlowFilter( 0x000000, 1, safetyBorder, safetyBorder, 255 ),  
//				new DropShadowFilter() ];
			_object.x = 0;
			_object.y = 0;
			_shape = new Sprite();
			var bounds: Rectangle = _object.getBounds( _object );
			HELPER_MATRIX.tx = -bounds.x + safetyBorder;
			HELPER_MATRIX.ty = -bounds.y + safetyBorder;
			
			_bmp = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0 ) );
			_bmp.bitmapData.draw( _object );
//			_bmp = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0 ) );
//			var a:MovieClip = new MovieClip();
//			a.width = 100;
//			a.height = 100;
//			a.graphics.beginFill(0x000000);
//			a.graphics.drawRect(25,25,25,25);
//			a.graphics.endFill();
//			_bmp.bitmapData.draw(a);
			_bmp.x = 0;
			_bmp.y = 0;
			_shape.addChild( _bmp );
			_object.filters = [];
			MonsterDebugger.trace(this,_bmp);
			MonsterDebugger.trace(this,_shape);
			MonsterDebugger.trace(this,_object);
			MonsterDebugger.trace(this,_textField);

		}
		
		private function createTextField( fontName: String, embeddedFont: Boolean, text: String, size: Number ): TextField
		{
//			var textField: TextField = new TextField();
////			textField.embedFonts = embeddedFont;
//////			textField.backgroundColor = 0xEEEEEE;
////			textField.textColor = 0x000000;
////			textField.opaqueBackground = null;
////
////			textField.antiAliasType = AntiAliasType.ADVANCED;
//			textField.setTextFormat(new TextFormat(fontName, size));
//			textField.autoSize = TextFieldAutoSize.LEFT;
//////			textField.wordWrap = true;
////			textField.background = false;
////			textField.selectable = false;
//////			textField.x = -textField.width/2;
//////			textField.y = -textField.height/2;
////			textField.cacheAsBitmap = true;
//			textField.text = text;
			
			var textField: TextField = new TextField();
//			textField.embedFonts = embeddedFont;
//			textField.textColor = 0x000000;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.text = text;
			textField.setTextFormat( new TextFormat( fontName, size ) );
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = false;
			textField.selectable = false;
//			textField.x = -textField.width/2;
//			textField.y = -textField.height/2;
			textField.cacheAsBitmap = true;
//			MonsterDebugger.trace(this, textField);

			return textField;
		}
		
		public function get shape(): DisplayObject
		{
			return _shape;
		}
		
		public function get object(): DisplayObject
		{
			return _object;
		}
		
		public function contains(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
			if(!intersects(x,y,width,height,transformed)) {
				var rX:Number = x+ width*Math.random();
				var rY:Number = y+ height*Math.random();
				if(transformed)
					return shape.hitTestPoint(rY, rY, true);
				else
					return _bmp.hitTestPoint(rX, rY, true);
			}
				else return false;
		}
		
		public function containsPoint(x:Number, y:Number,transformed:Boolean):Boolean{
			if(transformed)
				return shape.hitTestPoint(x,y,true);
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
//				var test:MovieClip = new MovieClip();
//				test.width = width;
//				test.height = height;
//				test.x=0;
//				test.y=0;
//				test.graphics.beginFill(0x000000);
//				test.graphics.drawRect(0,0,width,height);
//				test.graphics.endFill();
//				var testBmp:BitmapData = new BitmapData(width, height, true, 0);
//				testBmp.fillRect(new Rectangle(0,0,width,height), 0x000000);
//				testBmp.draw(test);
				var r:Boolean = _bmp.bitmapData.hitTest(new Point(0,0),255, new Rectangle(x,y,width,height),null,255);
				return r;
			}
		}
		
		public function getBounds2D():Rectangle {
			return shape.getBounds(shape.parent);
		}
		public function getWidth():int{
			return shape.width;
		}
		public function getHeight():int{
			return shape.height;
		}
		
		public function translate(tx:Number,ty:Number):void{
			trace("Before:","shape",shape.x,shape.y,"object",object.x,object.y);

			_shape.x = tx;
			_shape.y = ty;
			
			
			trace("After:","shape",shape.x,shape.y,"object",object.x,object.y);
//			_bmp.x = tx;
//			_bmp.y = ty;
//			_object.x = tx;
//			_object.y = ty;
//			
//			//TODO: get rid of redundant objects
//			var my_matrix = _shape.transform.matrix;
//			my_matrix.translate(tx, ty);
//			_shape.transform.matrix = my_matrix;
//			
//			 my_matrix = _bmp.transform.matrix;
//			my_matrix.translate(tx, ty);
//			_bmp.transform.matrix = my_matrix;
//			
//			 my_matrix = _object.transform.matrix;
//			my_matrix.translate(tx, ty);
//			_object.transform.matrix = my_matrix;
		}
		
		
		
		public function getShape():DisplayObject{
			return _shape;
		}
	}
}
