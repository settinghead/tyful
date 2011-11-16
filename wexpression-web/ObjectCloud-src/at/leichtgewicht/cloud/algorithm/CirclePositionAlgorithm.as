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
	public class CirclePositionAlgorithm extends AbstractStraightPositionAlogrithm
	{
		private var _container: ShapeOverlapTester;
		private var _tries: int;
		private var _currentRadius: Number;
		private var _currentRatioFactor: Number;
		private var _prng: PM_PRNG;
		private var _currentChild: DisplayObject;
		private var _currentChildPos: Point;
		private var _currentChildStartX: Number;
		private var _currentChildStartY: Number;
		private var _currentBounds: Rectangle;
		private var _currentAngle: Number;
		private var _sizeWeight: Number = 0.8;
		private var _radiusStep: Number = 15.0;
		private var _minTries: int = 1;
		private var _triesPerRadius: int = 6;
		private var _reuseFormerPosition: Boolean = false;
		private var _relativeAngle: Boolean = false;
		private var _currentRadiusFactor: Number;
		private const _twoMathPI: Number = 2 * Math.PI;

		public function CirclePositionAlgorithm(territory: SpriteAsset)
		{
			super(territory);
			_container = new ShapeOverlapTester(_territory);
			_currentChildPos = new Point();
		}
		
		override protected function clear(): void
		{
			super.clear();
			_container.clear();
			_prng = new PM_PRNG();
			_currentChild = null;
			_currentRadius = 0;
			_currentAngle = 0;
			_tries = 0;
		}
		
		override protected function tryNextPosition(): Boolean
		{
			if( --_tries )
			{
				_currentRadius += _radiusStep + _currentRatioFactor * _prng.nextDouble();
				_tries = _minTries + _currentRadius / _triesPerRadius + 1;
			}
			
			const angle: Number = _prng.nextDoubleRange( 0.0, _twoMathPI );
			
			_currentChild.x = ( _currentChildStartX + Math.cos( angle ) * _currentRadius * _currentRadiusFactor );
			_currentChild.y = ( _currentChildStartY + Math.sin( angle ) * _currentRadius / _currentRadiusFactor );
			_currentBounds.x = _currentChildPos.x + _currentChild.x;
			_currentBounds.y = _currentChildPos.y + _currentChild.y;
			
			return _container.test( _currentBounds );
		}
		
		override protected function set currentShape( current: DisplayObject ): void
		{
			_currentChildStartX = 0.0;
			_currentChildStartY = 0.0;
				
			if( null != _currentChild && _reuseFormerPosition )
			{
				_currentChildStartX = _currentChild.x;
				_currentChildStartY = _currentChild.y;
			}
			
			_currentChild = current;
			_currentChild.alpha = 0.5;
			
			_container.addChild( _currentChild );
			
			var currentSizeFactor: Number = _currentChild.height / _currentChild.width;
			_currentRadiusFactor = ( 1.0 - _sizeWeight ) + _sizeWeight * currentSizeFactor;
			_currentRatioFactor = Math.sqrt( currentSizeFactor );
			
			_currentBounds = _currentChild.getBounds( _container );
			_currentChildPos.x = _currentBounds.x;
			_currentChildPos.y = _currentBounds.y;
			
			_currentBounds.x = 0.0;
			_currentBounds.y = 0.0;
			
			_currentChild.x = _currentChildStartX;
			_currentChild.y = _currentChildStartY;
			
			if( _relativeAngle )
			{
				_currentAngle += Math.PI / 4;
				if( _currentAngle >= _twoMathPI )
				{
					_currentAngle -= _twoMathPI;
				}
			}
			else
			{
				_currentAngle = _twoMathPI * _prng.nextDouble();
			}
			
			_currentRadius = 5.0;
			_tries = 1;
		}
		
		public function set sizeWeight(sizeWeight: Number): void
		{
			_sizeWeight = sizeWeight;
		}
		
		public function set radiusStep(radiusStep: Number): void
		{
			_radiusStep = radiusStep;
		}
		
		public function set minTries(minTries: Number): void
		{
			_minTries = minTries;
		}
		
		public function set triesPerRadius(triesPerRadius: Number): void
		{
			_triesPerRadius = triesPerRadius;
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
		
		public function get container(): ShapeOverlapTester
		{
			return _container;
		}
	}
}
