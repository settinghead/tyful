package org.sepy.geom
{
	public class Matrix2d extends Array2d
	{
		private var _identity:Array;
		
		public function Matrix2d(w:uint, h:uint)
		{
			super(w, h);
			
			_identity = null;
		}
		
		public function get IDENTITY():Array
		{
			if(_identity == null)
			{
				_identity = new Array(_w * _h);
				for(var y:uint = 0; y < _h; ++y)
					for(var x:uint = 0; x < _w; ++x)
						_identity[(y * _w) + x] = (x == y) ? 1 : 0;
			}
			
			return _identity;
		}
		
		protected override function setFlatData(new_data:Array, copy:Boolean=false):void
		{
			// Fix the matrix to the given bounds
			if(new_data.length < length)
				new_data = new_data.slice(0, new_data.length).concat(IDENTITY.slice(new_data.length, length));
			else if(new_data.length > length)
				new_data = new_data.slice(0, length);
			
			super.setFlatData(new_data, copy);
		}
	}
}