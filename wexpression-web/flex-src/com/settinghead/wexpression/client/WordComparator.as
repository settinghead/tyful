package com.settinghead.wexpression.client
{
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.utils.NumericComparator;
	import org.as3commons.collections.utils.UncomparableType;
	
	public class WordComparator implements IComparator
	{
		public var _numComparator: NumericComparator; 
		public function WordComparator(order : String = NumericComparator.ORDER_ASC)
		{
			_numComparator = new NumericComparator(order);
		}
		
		public function compare(item1:*, item2:*):int
		{
			if (!(item1 is Word)) throw new UncomparableType(String, item1);
			if (!(item2 is Word)) throw new UncomparableType(String, item2);
			
			var p1:Word = item1;
			var p2:Word = item2;
			
			var r:int= -_numComparator.compare(p1.getWeight(), p2.getWeight());
			return r;
			
		}
	}
}