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
package at.leichtgewicht.cloud
{
	import at.leichtgewicht.cloud.algorithm.IPositionAlgorithm;
	import flash.display.Sprite;
	
	/**
	 * Objects to 
	 * 
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class ObjectCloud extends Sprite
	{
		// Container that holds all objects. Its a seperate object to ease
		// the process of cleaning the cloud.
		private var _container: Sprite;
		
		// The algorithm taken to positionate the objects
		private var _algorithm: IPositionAlgorithm;
		
		// The objects that should be positionated.
		private var _objects: Array;
		
		/**
		 * Constructs a new instance of the object cloud.
		 * 
		 * @param strategy Initial strategy to be used.
		 * @param objects Initial objects to be passed to the strategy
		 */
		public function ObjectCloud( algorithm: IPositionAlgorithm = null, objects: Array = null )
		{
			this.algorithm = algorithm;
			this.objects = objects;
		}
		
		public function set objects( objects: Array ): void
		{
			_objects = objects;
			clear();
		}
		
		public function get objects(): Array
		{
			return _objects;
		}
		
		public function set algorithm(algorithm: IPositionAlgorithm): void
		{
			if( _algorithm )
			{
				_algorithm.removeEventListener( RenderProgressEvent.UPDATE, onPositionEvent );
			}
			_algorithm = algorithm;
			if( _algorithm )
			{
				_algorithm.addEventListener( RenderProgressEvent.UPDATE, onPositionEvent );
			}
			clear();
		}
		
		public function get algorithm(): IPositionAlgorithm
		{
			return _algorithm;
		}
		
		public function get percentage(): Number
		{
			return _algorithm.percentage;
		}
		
		/**
		 * Clears the current rendering and starts the next one depending to the
		 * current strategy.
		 */
		private function clear(): void
		{
			if( _container )
			{
				removeChild( _container );
			}
			addChild( _container = new Sprite() );
			if( _algorithm && _objects )
			{
				_algorithm.drawShapeSets( _objects );
			}
		}
		
		/**
		 * Adds the object for which a position was found to the container
		 * (in order to have it visible).
		 * 
		 * @param event Event sent by the positioning algorithm.
		 */
		private function onPositionEvent( event: RenderProgressEvent ): void
		{
			if( event.positionatedObject )
			{
				_container.addChild( event.positionatedObject.object );
			}
			dispatchEvent( new RenderProgressEvent( event.type, event.percentage, event.positionatedObject ) );
		}
	}
}