package com.settinghead.wexpression.client.angler
{
	import com.settinghead.wexpression.client.EngineWord;
	
	import de.polygonal.math.PM_PRNG;
	
	public class PickFromAngler implements WordAngler
	{
		
		private var angles:Vector.<Number>;
		private static var prng:PM_PRNG = new PM_PRNG();
		public function PickFromAngler(angles:Vector.<Number>)
		{
			this.angles = angles;
		}
		
		public function angleFor(eWord:EngineWord):Number
		{
			return angles[prng.nextIntRange(0,angles.length-1)];
		}
	}
}