package com.settinghead.tyful.client.angler
{
	import com.settinghead.tyful.client.model.vo.EngineWordVO;
	
	import de.polygonal.utils.PM_PRNG;
	
	public class PickFromAngler implements WordAngler
	{
		
		private var angles:Array;
		private static var prng:PM_PRNG = new PM_PRNG();
		public function PickFromAngler(angles:Array)
		{
			this.angles = angles;
		}
		
		public function angleFor(eWord:EngineWordVO):Number
		{
			return angles[prng.nextIntRange(0,angles.length-1)];
		}
	}
}