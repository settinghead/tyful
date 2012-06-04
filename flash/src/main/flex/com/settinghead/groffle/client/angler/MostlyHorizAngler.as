package com.settinghead.groffle.client.angler
{
	import com.settinghead.groffle.client.model.algo.tree.BBPolarTreeVO;

	public class MostlyHorizAngler extends PickFromAngler
	{
		public function MostlyHorizAngler()
		{
			super(Vector.<Number>([0, 0, 0, 0,
				,BBPolarTreeVO.HALF_PI
				,BBPolarTreeVO.HALF_PI+BBPolarTreeVO.PI
			]));
//			super(Vector.<Number>([0.3,-0.3]));
		}
	}
}