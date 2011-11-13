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
package at.leichtgewicht.cloud.text
{
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	import Boolean;
	import Number;
	import String;
	import at.leichtgewicht.cloud.IShapeSet;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	
	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class TextSet implements IShapeSet
	{
		private static const HELPER_MATRIX: Matrix = new Matrix();
		
		private var _object: Sprite;
		private var _shape: Sprite;
		
		public function TextSet( fontName: String, embeddedFont: Boolean, text: String, safetyBorder: Number, size: Number, rotation: Number )
		{
			_object = new Sprite();
			var tF: TextField = createTextField( fontName, embeddedFont, text, size );
			tF.rotation = rotation;
			_object.addChild( tF );
			_object.filters = [ new GlowFilter( 0x000000, 1, safetyBorder, safetyBorder, 255 ),  
				new DropShadowFilter() ];
			
			_shape = new Sprite();
			var bounds: Rectangle = _object.getBounds( _object );
			HELPER_MATRIX.tx = -bounds.x + safetyBorder;
			HELPER_MATRIX.ty = -bounds.y + safetyBorder;
			
			var bmp: Bitmap = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, false, 0xFFFFFFFF ) );
			bmp.bitmapData.draw( _object, HELPER_MATRIX, null, null, null, true );
			bmp.x = bounds.x;
			bmp.y = bounds.y;
			_shape.addChild( bmp );
			_object.filters = [];
		}
		
		private function createTextField( fontName: String, embeddedFont: Boolean, text: String, size: Number ): TextField
		{
			var textField: TextField = new TextField();
			textField.embedFonts = embeddedFont;
			textField.textColor = 0x000000;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.text = text;
			textField.setTextFormat( new TextFormat( fontName, size ) );
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = false;
			textField.selectable = false;
			textField.x = -textField.width/2;
			textField.y = -textField.height/2;
			textField.cacheAsBitmap = true;
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
	}
}
