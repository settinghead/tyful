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
	import at.leichtgewicht.cloud.tool.SizeFitter;
	import at.leichtgewicht.cloud.RenderProgressEvent;
	import at.leichtgewicht.cloud.ObjectCloud;

	import flash.display.Sprite;

	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class ProgressDisplay extends Sprite 
	{
		private var _progressRing: ProgressRing;
		private var _sizeFitter: SizeFitter;

		public function ProgressDisplay( cloud: ObjectCloud )
		{
			addChild( _progressRing = new ProgressRing() );
			_progressRing.visible = false;
			cloud.addEventListener( RenderProgressEvent.UPDATE, onNextPosition );
			addChild( _sizeFitter = new SizeFitter( cloud ) );
		}

		private function onNextPosition( event: RenderProgressEvent ): void
		{
			if( _progressRing.visible = ( event.percentage != 1 ) )
			{
				_progressRing.percentage = event.percentage;
			}
		}
	}
}
