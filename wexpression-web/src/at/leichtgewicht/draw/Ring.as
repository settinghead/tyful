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

package at.leichtgewicht.draw 
{
	import at.leichtgewicht.draw.BezierCurve;
	import flash.geom.Point;	
	import flash.display.Graphics;

	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class Ring 
	{
		private static const ZERO_OFFSET: Point = new Point( 0, 0 );
		
		public static function draw( graphics: Graphics, innerRadius: Number, outerRadius: Number, startAngle: Number = 0, size: Number = 2 * Math.PI, offset: Point = null, accuracy: int = 10 ): void
		{
			if( null == offset )
			{
				offset = ZERO_OFFSET;
			}
			var startX: Number = offset.x + Math.cos( startAngle ) * innerRadius;
			var startY: Number = offset.y + Math.sin( startAngle ) * innerRadius;
			var endX: Number = offset.x + Math.cos( startAngle + size ) * outerRadius;
			var endY: Number = offset.y + Math.sin( startAngle + size ) * outerRadius;
			
			graphics.moveTo( startX, startY );
			BezierCurve.draw( graphics, innerRadius, size, startAngle, accuracy, offset );
			graphics.lineTo( endX, endY );
			BezierCurve.draw( graphics, outerRadius, size, startAngle, accuracy, offset, false );
			graphics.lineTo( startX, startY );
		}
	}
}