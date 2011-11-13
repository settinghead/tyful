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
	import flash.display.DisplayObject;
	
	/**
	 * Definition of basic objects to be arranged by the algorithms.
	 * 
	 * <p>For objects to be arranged by the algorithms of this frameworks they
	 * have to implement this interface in which they provide both their object
	 * as well as the shape which is used to find out if it overlaps or not.</p>
	 * 
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public interface IShapeSet
	{
		/**
		 * Object which will be displayed after the process for arranging the 
		 * objects has been finished at the found positions.
		 * 
		 * @return Object to be arranged.
		 */
		function get object(): DisplayObject;
		
		/**
		 * Getter for the shape of the object available with <code>.object</object.>
		 * 
		 * <p>The shape doesn't have to be of the type <code>flash.display.Shape</code>
		 * but it has to be entirely in grayscale. The shape is one of the most crutial
		 * aspects for the performance. If you implement your own shape take care to not
		 * use filters or things alike that reduce the performance of <code>BitmapData.draw</code>.
		 * </p>
		 * 
		 * @return Black shape of the object.
		 */
		function get shape(): DisplayObject;
	}
}
