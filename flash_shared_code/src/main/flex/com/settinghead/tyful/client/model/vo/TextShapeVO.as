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
package com.settinghead.tyful.client.model.vo
{
	
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
	public class TextShapeVO
	{
//		[Embed(source="Vera.ttf", fontFamily="vera", mimeType='application/x-font',
//        embedAsCFF='false', advancedAntiAliasing="true")]
//		public static const Vera: Class;
//		
//		[Embed(source="pokoljaro-kRB.ttf", fontFamily="pokoljaro", mimeType='application/x-font',
//        embedAsCFF='false', advancedAntiAliasing="true")]
//		public static const Pokoljaro: Class;
//		[Embed(source="coolvetica rg.ttf", fontFamily="coolvetica rg", mimeType='application/x-font',
//        embedAsCFF='false', advancedAntiAliasing="true")]
//		public static const CoolveticaRg: Class;
//
//		[Embed(source="coolvetica rg.ttf", fontFamily="coolvetica rg", mimeType='application/x-font',
//        embedAsCFF='false', advancedAntiAliasing="true")]
//		public static const CoolveticaRg: Class;
		[Embed(source="../../fonter/konstellation/panefresco-500.ttf", fontFamily="panefresco500", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const Panefresco500: Class;
		[Embed(source="../../fonter/konstellation/permanentmarker.ttf", fontFamily="permanentmarker", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const PermanentMarker: Class;
		[Embed(source="../../fonter/konstellation/romeral.ttf", fontFamily="romeral", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const Romeral: Class;

		[Embed(source="../../fonter/konstellation/bpreplay-kRB.ttf", fontFamily="bpreplay-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const BpreplayKRB: Class;
		[Embed(source="../../fonter/konstellation/fifthleg-kRB.ttf", fontFamily="fifthleg-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const FifthlegKRB: Class;
		[Embed(source="../../fonter/konstellation/pecita-kRB.ttf", fontFamily="pecita-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const PecitaKRB: Class;
		[Embed(source="../../fonter/konstellation/sniglet-kRB.ttf", fontFamily="sniglet-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const snigletKRB: Class;
		
//		[Embed(source="../../fonter/konstellation/communist.ttf", fontFamily="communist", mimeType='application/x-font',
//        embedAsCFF='false', advancedAntiAliasing="true")]
//		public static const Communist: Class;
//		[Embed(source="../../fonter/konstellation/judson.ttf", fontFamily="judson", mimeType='application/x-font',
//        embedAsCFF='false', advancedAntiAliasing="true")]
//		public static const Judson: Class;
//		[Embed(source="../../fonter/konstellation/komika-axis.ttf", fontFamily="komika-axis", mimeType='application/x-font',
//        embedAsCFF='false', advancedAntiAliasing="true")]
//		public static const KomikaAxis: Class;
//		
		
		
		private const HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );


		private static const HELPER_MATRIX: Matrix = new Matrix();
		private var _bmp:Bitmap;
		private var _textField:TextField;
		private var _size: Number;
		private var _centerX:Number, _centerY:Number, _rotation:Number = 0;
		
		public function TextShapeVO(embeddedFont: Boolean, text: String, safetyBorder: Number, size: Number, rotation: Number = 0, fontName: String = "pokoljaro")
		{
			this._size = size;

			_textField = createTextField( fontName, text, size );
			_textField.rotation = rotation;
			
			var bounds: Rectangle = _textField.getBounds( _textField );
			HELPER_MATRIX.tx = -bounds.x + safetyBorder;
			HELPER_MATRIX.ty = -bounds.y + safetyBorder;
			
			_bmp = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0 ) );
			var s:Sprite = new Sprite();
			s.width = _textField.width;
			s.height = textField.height;

//			if(size < 20){
//				
//				s.graphics.beginFill(0xbcbcbc,0.5);
//				s.graphics.drawRect(0,0,s.width,s.height);
//				s.graphics.endFill();
//			}
				
			s.addChild(_textField);
			_bmp.bitmapData.draw( s );

			_bmp.x = 0;
			_bmp.y = 0;

		}
		
		private function createTextField( fontName: String, text: String, size: Number ): TextField
		{

			
			var textField: TextField = new TextField();
//			textField.setTextFormat( new TextFormat( font.fontName, size ) );
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("div{font-size: "+_size+"; font-family: "+fontName+"; leading: 0; text-align: center;}");
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
			textField.filters = [new DropShadowFilter(0.5,45,0,1.0,0.5,0.5)];
			if(text.length>11){ //TODO: this is a temporary fix
				var w:Number = textField.width;
				textField.wordWrap = true;
				textField.width = w/(text.length/11)*1.1 ;
			}
			return textField;
		}

		
		private var origin:Point = new Point(0,0);
		private var testRect:Rectangle = new Rectangle(0,0,1,1);
		
		
		public function setCenterLocation(centerX:Number,centerY:Number):void{
			this._centerX = centerX;
			this._centerY = centerY;
		}
	
		public function getWidth():Number{
			return _textField.width;
		}
		public function getHeight():Number{
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
		
		public function get bitmapData():BitmapData{
			return _bmp.bitmapData;
		}
		
		public function rotate(rotation:Number):void{
			
			this._rotation = rotation;
		}
	}
}
