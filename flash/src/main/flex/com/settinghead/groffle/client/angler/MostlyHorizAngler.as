package com.settinghead.groffle.client.angler
{
	import com.settinghead.groffle.client.model.algo.tree.BBPolarTreeVO;

	public class MostlyHorizAngler extends PickFromAngler
	{
		public function MostlyHorizAngler()
		{
			super([0, 0, 0, 0
				,Math.PI/2
				,Math.PI/2*3
			]);
//			super(Vector.<Number>([0.3,-0.3]));
		}
	}
}