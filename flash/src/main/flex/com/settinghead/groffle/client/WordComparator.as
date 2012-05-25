package com.settinghead.groffle.client
{
	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.utils.NumericComparator;
	import org.as3commons.collections.utils.UncomparableType;
	import com.settinghead.groffle.client.model.vo.wordlist.WordVO;
	
	public class WordComparator implements IComparator
	{
		public var _numComparator: NumericComparator; 
		public function WordComparator(order : String = NumericComparator.ORDER_DESC)
		{
			_numComparator = new NumericComparator(order);
		}
		
		public function compare(item1:*, item2:*):int
		{
			if (!(item1 is WordVO)) throw new UncomparableType(String, item1);
			if (!(item2 is WordVO)) throw new UncomparableType(String, item2);
			
			var p1:WordVO = item1;
			var p2:WordVO = item2;
			
			var r:int= _numComparator.compare(p1.weight, p2.weight);
//			if(r==0)
//				r = _numComparator.compare(p2.word.length, p1.word.length);
			return r;
			
		}
	}
}