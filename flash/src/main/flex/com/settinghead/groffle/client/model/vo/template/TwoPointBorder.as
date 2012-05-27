package com.settinghead.groffle.client.model.vo.template
{
	public class TwoPointBorder
	{
		public var x1:int=int.MAX_VALUE;
		public var y1:int=int.MAX_VALUE;
		public var x2:int=int.MIN_VALUE;
		public var y2:int=int.MIN_VALUE;
		public function TwoPointBorder()
		{
		
		}
		
		public function get width():int{
			return this.x2-this.x1;
		}
		
		public function get height():int{
			return this.y2-this.y1;
		}
	}
}