package com.settinghead.wenwentu.client.density
{
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.utils.NumericComparator;
	import org.as3commons.collections.utils.UncomparableType;
	
	public class PatchComparator implements IComparator
	{
		
		public var _numComparator: NumericComparator; 
		public function PatchComparator(order : String = NumericComparator.ORDER_ASC)
		{
			_numComparator = new NumericComparator(order);
		}
		
		public function compare(item1:*, item2:*):int
		{
			if (!(item1 is Patch)) throw new UncomparableType(String, item1);
			if (!(item2 is Patch)) throw new UncomparableType(String, item2);
			
			var p1:Patch = item1;
			var p2:Patch = item2;
			
			var r:int= -_numComparator.compare(p1.getAverageAlpha(),
				p2.getAverageAlpha());
			if (r == 0)
				return p1.getRank() - p2.getRank();
			else
				return r;
		}
	}
}