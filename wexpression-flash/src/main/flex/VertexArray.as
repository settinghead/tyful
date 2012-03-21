package
{
	public class VertexArray extends Array
	{
		public function VertexArray(size:int)
		{
			super(size);
		}
		
		public function findNextIndexInArray(index:int, direction:Boolean):int{
			//TODO		
		}
		
		public function getXFor(index:int):int{
			//TODO
		}
		
		public function getUpperBoundFor(index:int):int{
			//TODO
		}
		
		public function getLowerBoundFor(index:int):int{
			//TODO
		}
		
		public function insertAt(index:int, lowerBound:int):void{
			super[index] = lowerBound;
		}
		
		public function removeAt(index:int):void{
			//TODO
		}
	}
}