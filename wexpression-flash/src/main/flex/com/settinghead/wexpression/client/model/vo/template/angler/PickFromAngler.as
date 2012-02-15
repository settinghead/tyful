package com.settinghead.wexpression.client.model.vo.template.angler
{
	import com.settinghead.wexpression.client.model.vo.EngineWordVO;
	import com.settinghead.wexpression.client.model.vo.template.WordAngler;
	
	import de.polygonal.utils.PM_PRNG;
	
	import mx.collections.ArrayCollection;
	
	public class PickFromAngler extends WordAngler
	{
		
		private var _angles:ArrayCollection;
		private static var prng:PM_PRNG = new PM_PRNG();
		public function get angles():ArrayCollection{
			return _angles;
		}
		
		public function set angles(a:ArrayCollection):void{
			this._angles = a;
		}
		
		public function PickFromAngler(angles:ArrayCollection)
		{
			this._angles = angles;
		}
		
		public override function angleFor(eWord:EngineWordVO):Number
		{
			return angles[prng.nextIntRange(0,angles.length-1)] as Number;
		}
	}
}