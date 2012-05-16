package com.settinghead.wexpression.client.model.vo.template.placer
{
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.math.MathUtils;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	import com.settinghead.wexpression.client.model.vo.template.WordPlacer;
	
	import flash.geom.Point;
	
	public class CenterClumpPlacer extends WordPlacer
	{
		public function CenterClumpPlacer()
		{
			super();
		}
		
		public override function place(word:WordVO, wordIndex:int, wordsCount:int,
									   wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
									   fieldHeight:int): Vector.<PlaceInfo>  {
			var r:Vector.<PlaceInfo> = new Vector.<PlaceInfo>(PlaceInfo(new Point(getOneUnder(fieldWidth - wordImageWidth),
				getOneUnder(fieldHeight - wordImageHeight))));
			return r;
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
		
		public override function fail(returnedObj:Object):void {
		}
		public override function success(returnedObj:Object):void
		{
		}
	}
}