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
	import at.leichtgewicht.cloud.IShapeSet;
	import at.leichtgewicht.cloud.RenderProgressEvent;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import com.lorentz.SVG.display.SVGDocument;
	import mx.core.SpriteAsset;

	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class AbstractStraightPositionAlogrithm extends EventDispatcher implements IPositionAlgorithm
	{
		private var _percentage: Number;
		private var _shapeSets: Array;
		private var _currentSetNo: Number = 0;
		private var _timer: Timer;
		private var _currentShapeSet: IShapeSet;
		protected var _territory:SpriteAsset;
		
		public function AbstractStraightPositionAlogrithm(territory: SpriteAsset)
		{
			super();
			_territory = territory;
			_timer = new Timer( Number.MIN_VALUE );
			_timer.addEventListener( TimerEvent.TIMER, nextTry );
		}
		
		public function drawShapeSets( shapeSets: Array ): void
		{
			_percentage = 0;
			_currentSetNo = 0;
			_shapeSets = shapeSets;
			_currentShapeSet = shapeSets[ 0 ];
			
			clear();
			
			_timer.stop();
			_timer.reset();
			_timer.start( );
			
			nextTry( );
		}
		
		public function get percentage(): Number
		{
			return _percentage;
		}
		
		protected function clear(): void
		{
		}
		
		protected function tryNextPosition(): Boolean
		{
			throw new Error( "not implemented" );
		}
		
		protected function set currentShape( current: DisplayObject ): void
		{
			throw new Error( "not implemented" );
		}
		
		private function finish(): void
		{
			_timer.stop();
		}
		
		private function nextChild(): Boolean
		{
			var formerShapeSet: IShapeSet = _currentShapeSet;
			var finished: Boolean = false;
			
			++ _currentSetNo;
			_percentage = _currentSetNo / _shapeSets.length;
			
			if( _currentSetNo >= _shapeSets.length )
			{
				finish();
				finished = true;
			}
			else
			{
				_currentShapeSet = IShapeSet( _shapeSets[ _currentSetNo ] );
				currentShape = _currentShapeSet.shape;
			}
			
			if( formerShapeSet )
			{
				formerShapeSet.object.x = formerShapeSet.shape.x;
				formerShapeSet.object.y = formerShapeSet.shape.y;
				dispatchEvent( new RenderProgressEvent( RenderProgressEvent.UPDATE, _percentage, formerShapeSet ) );
			}
			
			return finished;
		}
		
		private function nextTry( event: TimerEvent = null ): void
		{
			const executionStartTime: int = getTimer();
			if( _currentSetNo == 0 )
			{
				currentShape = _currentShapeSet.shape;
				nextChild();
			}
			while( true )
			{
				if( !tryNextPosition() )
				{
					if( nextChild() )
					{
						return;
					}
				}
				if( getTimer() - executionStartTime > 8000000000 )
				{
					return;
				}
			}
		}
	}
}

