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
	import flash.display.Graphics;

	
	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class Star 
	{
		public static function drawStar( graphics: Graphics, innerRadius: Number, outerRadius: Number, amountCorners: int, angleOffset: Number = 0 ): void
		{
			var angleStep: Number = Math.PI / amountCorners;
			var angle: Number = angleOffset;
			with( graphics )
			{
				for( var i: int = 0; i<amountCorners; ++i, angle += angleStep )
				{
					if( i == 0 )
					{
						moveTo(
							Math.cos( angle ) * innerRadius,
							Math.sin( angle ) * innerRadius
						);
					}
					else
					{
						lineTo(
							Math.cos( angle ) * innerRadius,
							Math.sin( angle ) * innerRadius
						);
					}
					angle += angleStep;
					lineTo(
						Math.cos( angle ) * outerRadius,
						Math.sin( angle ) * outerRadius
					);
				}
			}
		}
	}
}
