package com.settinghead.tyful.client.colorer
{
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	
	public class AlwaysUseColorer implements WordColorer
	{
		
		private var color:uint;
		public function AlwaysUseColorer(color:uint)
		{
			this.color = color;
		}
		
		public function colorFor(place:PlaceInfo = null):uint
		{
			return color;
		}
	}
}