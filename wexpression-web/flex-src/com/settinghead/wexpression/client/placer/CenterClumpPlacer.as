package com.settinghead.wexpression.client.placer
{
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.Word;
	import com.settinghead.wexpression.client.math.MathUtils;
	
	import flash.geom.Point;
	
	public class CenterClumpPlacer implements WordPlacer
	{
		public function CenterClumpPlacer()
		{
		}
		
		public function place(word:Word, wordIndex:int, wordsCount:int,
							  wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
							  fieldHeight:int):PlaceInfo {
			return new PlaceInfo(new Point(getOneUnder(fieldWidth - wordImageWidth),
				getOneUnder(fieldHeight - wordImageHeight)));
		}
		
		private function getOneUnder(upperLimit:Number):int {
			var stdev:Number= 0.4;

			return Math.round(MathUtils.map((nextGaussian()
			)* stdev, -2, 2, 0, upperLimit));
		}
		
		private var haveNextNextGaussian:Boolean = false;
		private var nextNextGaussian:Number;
		
		private function nextGaussian():Number {
			if (haveNextNextGaussian) {
				haveNextNextGaussian = false;
				return nextNextGaussian;
			} else {
				var v1:Number, v2:Number, s:Number;
				do { 
					v1 = 2 * Math.random() - 1;   // between -1.0 and 1.0
					v2 = 2 * Math.random() - 1;   // between -1.0 and 1.0
					s = v1 * v1 + v2 * v2;
				} while (s >= 1 || s == 0);
				var multiplier:Number = Math.sqrt(-2 * Math.log(s)/s);
				nextNextGaussian = v2 * multiplier;
				haveNextNextGaussian = true;
				return v1 * multiplier;
			}
		}
		
		public function fail(returnedObj:Object):void {
		}
		public function success(returnedObj:Object):void
		{
		}
	}
}