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
package at.leichtgewicht.cloud.algorithm 
{
	import com.lorentz.SVG.display.SVGDocument;
	
	import de.polygonal.math.PM_PRNG;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.SpriteAsset;

	
	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class SwitchAngleAlgorithm extends AbstractStraightPositionAlogrithm implements IPositionAlgorithm
	{
		private var _currentChildStartY: Number;
		private var _currentChildStartX: Number;
		private var _currentChild: DisplayObject;
		private var _container: ShapeOverlapTester;
		private var _currentFactor: Number;
		private var _currentBounds: Rectangle;
		private var _xDirection: Number;
		private var _yDirection: Number;
		private var _currentAngle: Number;
		private var _prng: PM_PRNG;
		private var _relativeAngle: Boolean = false;
		private var _reuseFormerPosition: Boolean = false;
		private var _currentChildPos: Point;
		
		public function SwitchAngleAlgorithm(territory:SpriteAsset)
		{
			super(territory);
		}

		override protected function clear(): void
		{
			super.clear();
			_container = new ShapeOverlapTester(_territory);
			_prng = new PM_PRNG( );
			_currentChildPos = new Point();
		}
		
		override protected function tryNextPosition(): Boolean
		{
			var x: Number = ( _currentChild.x + _xDirection );
			var y: Number = ( _currentChild.y + _yDirection );
			
			_currentChild.x = x;
			_currentChild.y = y;
			_currentBounds.x = _currentChildPos.x + x;
			_currentBounds.y = _currentChildPos.y + y;
			
			return _container.test( _currentBounds );
		}
		
		override protected function set currentShape( current: DisplayObject ): void
		{
			_currentChildStartX = 0;
			_currentChildStartY = 0;
				
			if( null != _currentChild && _reuseFormerPosition )
			{
				_currentChildStartX = _currentChild.x;
				_currentChildStartY = _currentChild.y;
			}
			
			_currentChild = current;
			_currentChild.alpha = 0.5;
			
			_container.addChild( _currentChild );
			
			_currentFactor = Math.sqrt( _currentChild.height / _currentChild.width );
			
			_currentBounds = _currentChild.getBounds( _container );
			_currentChildPos.x = _currentBounds.x;
			_currentChildPos.y = _currentBounds.y;
			
			_currentChild.x = _currentChildStartX;
			_currentChild.y = _currentChildStartY;

			if( _relativeAngle )
			{
				_currentAngle += Math.PI / 4;
				var max: Number = Math.PI * 2;
				if( _currentAngle >= max )
				{
					_currentAngle -= max;
				}
			}
			else
			{
				_currentAngle = 2 * Math.PI * _prng.nextDouble();
			}

			_xDirection = Math.sin( _currentAngle );
			_yDirection = Math.cos( _currentAngle );
		}
		
		public function get reuseFormerPosition(): Boolean
		{
			return _reuseFormerPosition;
		}
		
		public function set reuseFormerPosition(reuseFormerPosition: Boolean): void
		{
			_reuseFormerPosition = reuseFormerPosition;
		}
		
		public function get relativeAngle(): Boolean
		{
			return _relativeAngle;
		}
		
		public function set relativeAngle(relativeAngle: Boolean): void
		{
			_relativeAngle = relativeAngle;
		}
	}
}
