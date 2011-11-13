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
package at.leichtgewicht.cloud.ui 
{
	import flash.geom.Point;
	import at.leichtgewicht.draw.Ring;
	import flash.display.Shape;

	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class ProgressRing extends Shape
	{
		private var _innerRadius: Number = 4;
		private var _outerRadius: Number = 7;
		private var _color: uint = 0x000000;
		private var _showBackground: Boolean = true;
		private var _backgroundColor: uint = 0x0000000;
		private var _backgroundAlpha: Number = 0.2;
		private var _percentage: Number;
		private var _offset: Point;

		public function ProgressRing()
		{
			_offset = new Point();
		}
		
		private function redraw(): void
		{
			graphics.clear();
			if( _showBackground )
			{
				graphics.beginFill( _backgroundColor, _backgroundAlpha );
				Ring.draw( graphics, _innerRadius, _outerRadius, -Math.PI / 2, 2 * Math.PI, _offset );
				graphics.endFill();
			}
			graphics.beginFill( _color );
			Ring.draw( graphics, _innerRadius, _outerRadius, -Math.PI / 2, percentage * 2 * Math.PI, _offset );
			graphics.endFill();
		}
		
		public function set percentage( percentage: Number ): void
		{
			_percentage = percentage;
			redraw( );
		}
		
		public function get percentage(): Number
		{
			return _percentage;
		}

		public function get outerRadius(): Number
		{
			return _outerRadius;
		}
		
		public function set outerRadius(outerRadius: Number): void
		{
			_outerRadius = outerRadius;
			_offset.x = -_outerRadius;
			_offset.y = -_outerRadius;
			redraw();
		}
		
		public function get innerRadius(): Number
		{
			return _innerRadius;
		}
		
		public function set innerRadius(innerRadius: Number): void
		{
			_innerRadius = innerRadius;
			redraw();
		}
		
		public function get color(): uint
		{
			return _color;
		}
		
		public function set color(color: uint): void
		{
			_color = color;
			redraw( );
		}
		
		public function get showBackground(): Boolean
		{
			return _showBackground;
		}
		
		public function set showBackground(showBackground: Boolean): void
		{
			_showBackground = showBackground;
		}
		
		public function get backgroundColor(): uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(backgroundColor: uint): void
		{
			_backgroundColor = backgroundColor;
		}
	}
}
