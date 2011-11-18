package com.settinghead.wexpression.client.angler
{
	import com.settinghead.wexpression.client.BBPolarTree;

	public class MostlyHorizAngler extends PickFromAngler
	{
		public function MostlyHorizAngler()
		{
//			super(Vector.<Number>([0, 0, 0, 0, 0, BBPolarTree.HALF_PI,-BBPolarTree.HALF_PI]));
			super(Vector.<Number>([BBPolarTree.HALF_PI-BBPolarTree.HALF_PI]));
		}
	}
}