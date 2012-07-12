package com.settinghead.tyful.client.angler
{
	

	public class MostlyHorizAngler extends PickFromAngler
	{
		public function MostlyHorizAngler()
		{
			super([0, 0, 0
				,Math.PI/2
				,Math.PI/2*3
			]);
//			super(Vector.<Number>([0.3,-0.3]));
		}
	}
}