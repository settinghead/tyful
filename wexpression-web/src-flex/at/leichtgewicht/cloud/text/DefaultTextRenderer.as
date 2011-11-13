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
	import at.leichtgewicht.cloud.IShapeSet;

	import de.polygonal.math.PM_PRNG;

	
	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class DefaultTextRenderer implements ITextRenderer 
	{
		public static const ROTATION_VERTICAL_ONLY: String = "at.leichtgewicht.cloud.DefaultTextRenderer::ROTATION_VERTICAL_ONLY";
		public static const ROTATION_HORIZONTAL_ONLY: String = "at.leichtgewicht.cloud.DefaultTextRenderer::ROTATION_HORIZONTAL_ONLY";
		public static const ROTATION_HORIZONTAL_VERTICAL: String = "at.leichtgewicht.cloud.DefaultTextRenderer::ROTATION_HORIZONTAL_VERTICAL";
		public static const ROTATION_FREE: String = "at.leichtgewicht.cloud.DefaultTextRenderer::ROTATION_FREE";
		
		private var _rotationMode: String = ROTATION_HORIZONTAL_ONLY;
		private var _minSize: Number = 0;
		private var _maxSize: Number = 20;
		private var _safetyBorder: Number = 3;
		private var _fontName: String;
		private var _prng: PM_PRNG;
		private var _embeddedFont: Boolean;

		public function clear(): void
		{
			_prng = new PM_PRNG();
		}

		public function render( weightedWord: WeightedWord ): IShapeSet
		{
			return renderWord( weightedWord.word, _minSize + ( _maxSize - _minSize ) * weightedWord.percentage );
		}
		
		public function renderWord( word: String, weight: Number ): IShapeSet
		{
			var rotation: Number = 0;
			if( ROTATION_VERTICAL_ONLY == _rotationMode )
			{
				rotation = 90;
			}
			else
			if( ROTATION_HORIZONTAL_VERTICAL == _rotationMode )
			{
				if( _prng.nextDouble() > 0.5 )
				{
					rotation = 90;
				}
			}
			else
			if( ROTATION_FREE == _rotationMode )
			{
				rotation = 90 - 180 * _prng.nextDouble();
			}
			return new TextSet( _fontName, _embeddedFont, word, _safetyBorder, weight, rotation );;
		}
		
		public function get rotationMode(): String
		{
			return _rotationMode;
		}
		
		public function set rotationMode( rotationMode: String ): void
		{
			_rotationMode = rotationMode;
		}
		
		public function get minSize(): Number
		{
			return _minSize;
		}
		
		public function set minSize( minSize: Number ): void
		{
			_minSize = minSize;
		}
		
		public function get maxSize(): Number
		{
			return _maxSize;
		}
		
		public function set maxSize( maxSize: Number ): void
		{
			_maxSize = maxSize;
		}
		
		public function get safetyBorder(): Number
		{
			return _safetyBorder;
		}
		
		public function set safetyBorder( safetyBorder: Number ): void
		{
			_safetyBorder = safetyBorder;
		}
		
		public function get fontName(): String
		{
			return _fontName;
		}
		
		public function set fontName(fontName: String): void
		{
			_fontName = fontName;
		}
		
		public function get embeddedFont(): Boolean
		{
			return _embeddedFont;
		}
		
		public function set embeddedFont( embeddedFont: Boolean ): void
		{
			_embeddedFont = embeddedFont;
		}
	}
}
