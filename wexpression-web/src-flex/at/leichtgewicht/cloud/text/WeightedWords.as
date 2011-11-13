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

	
	/**
	 * @author Martin Heidegger
	 * @version 1.0
	 */
	public class WeightedWords
	{
		private var _wordWeights: Array;
		private var _wordWeightsList: Array;
		private var _max: int = -1;
		private var _min: int = -1;
		private var _totalWordCount: Number;
		
		public function WeightedWords( text: String )
		{
			_wordWeights = new Array();
			_wordWeightsList = new Array();
			_totalWordCount = 0;
			addText( text );
		}
		
		public function addWords( words: Array ): void
		{
			for each( var word: String in words )
			{
				var wordWeight: WeightedWord = _wordWeights[ word ];
				if( null == wordWeight )
				{
					wordWeight = _wordWeights[ word ] = new WeightedWord( word, this );
					_wordWeightsList.push( wordWeight );
				}
				wordWeight.increment();
				_totalWordCount ++;
			}
			
			updateMaxMin();
		}
		
		private function updateMaxMin() : void
		{
			_min = -1;
			_max = -1;
			for each( var wordWeight: WeightedWord in _wordWeights )
			{
				if( wordWeight.amount > _max )
				{
					_max = wordWeight.amount;
				}
				if( wordWeight.amount < _min || _min == -1 )
				{
					_min = wordWeight.amount;
				}
			}
		}

		public function getWordWeightsSorted(): Array
		{
			return _wordWeightsList.sortOn( "amount", Array.DESCENDING | Array.NUMERIC );
		}

		public function addText( text: String ): void
		{
			addWords( text.split(" ") );
		}
		
		public function get totalWordCount() : Number {
			return _totalWordCount;
		}
		
		public function get max() : int {
			return _max;
		}
		
		public function get min() : int {
			return _min;
		}
		
		public function getWordWeightsShuffled(): Array
		{
			return null;
		}
		
		public function toString(): String
		{
			return "";
		}
	}
}
