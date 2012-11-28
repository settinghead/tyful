package com.adobe.example.vo
{
	public class CountResult
	{
		public function CountResult(countTarget:uint=0, countTime:Number=0)
		{
			this.countTarget = countTarget;
			this.countDurationSeconds = countTime;
		}
		
		public var countTarget:uint;
		public var countDurationSeconds:Number;
	}
}