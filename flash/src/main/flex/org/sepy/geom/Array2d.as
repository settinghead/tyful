package org.sepy.geom
{
	public class Array2d
	{
		protected var data:Array;
		protected var _w:uint;
		protected var _h:uint;
		protected var dirty:Boolean;
		
		public function Array2d(w:uint, h:uint)
		{
			data = new Array(w * h);	
			
			_w = w;
			_h = h;
			
			dirty = true;
		}
		
		public function get width():uint
		{
			return _w;
		}
		
		public function get height():uint
		{
			return _h;
		}
		
		public function get length():uint
		{
			return _w * _h;
		}
		
		public function get flatData():Array
		{
			return data;
		}
		
		public function fill(value:Number):void
		{
			var i:int;
			
			for(i = 0; i < data.length; ++i)
				data[i] = value;
			
			dirty = true;
		}
		
		public function setAt(x:uint, y:uint, value:Number):void
		{
			checkBounds(x, y);
			
			data[(y * _w) + x] = value;
			
			dirty = true;
		}
		
		public function getAt(x:uint, y:uint):Number
		{
			checkBounds(x, y);
			
			return data[(y * _w) + x];
		}
		
		public function sumValues():Number
		{
			var sum:Number;
			
			sum = 0;
			
			for(var i:uint = 0; i < data.length; ++i)
				sum += data[i];
			
			return sum;
		}
		
		public function clone():Array2d
		{
			var cloned:Array2d;
			
			cloned = new Array2d(_w, _h);
			cloned.setFlatData(data);
			
			return cloned;
		}
		
		protected virtual function setFlatData(new_data:Array, copy:Boolean=false):void
		{
			if(new_data.length != data.length)
				throw new ArgumentError("data assigned trought setFlatData MUST be the same length of the array");
			
			if(copy)
				new_data = new_data.slice();
				
			data = new_data;
			dirty = true;
		}
		
		private function checkBounds(x:uint, y:uint):void
		{
			if((x < 0 || x > _w) || (y < 0 || y > _h))
				throw new ArgumentError("Out of bound Array2d indexes");
		}
	}
}