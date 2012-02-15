package com.settinghead.wexpression.client.model.vo.template.angler
{
	import com.settinghead.wexpression.client.model.vo.BBPolarTreeVO;

	public class MostlyHorizAngler extends PickFromAngler
	{
		public function MostlyHorizAngler()
		{
			super(Vector.<Number>([0, 0, 0, 0, 0
			//	, BBPolarTreeVO.HALF_PI,-BBPolarTreeVO.HALF_PI
			]));
//			super(Vector.<Number>([0.3,-0.3]));
		}
	}
}