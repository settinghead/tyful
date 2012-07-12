package com.settinghead.tyful.client.angler
{
	import com.settinghead.tyful.client.model.vo.EngineWordVO;
	
	public class RandomAngler implements WordAngler
	{
		private var ranges:Array;
		
		public function RandomAngler(ranges:Array=null)
		{
			if(ranges==null){
				this.ranges = [[0, Math.PI]];
			}
			else{
				this.ranges = ranges;
			}
		}
		
		public function angleFor(eWord:EngineWordVO):Number
		{
			var r:Number =Math.random(); 
			var index:int = int(Math.floor(ranges.length*r));
			var unitLength:Number = 1.0/ranges.length;
			var percentile:Number = (r-unitLength*index)/unitLength;
			
			return (ranges[index][1]-ranges[index][0])*percentile+ranges[index][0];
			
		}
	}
}