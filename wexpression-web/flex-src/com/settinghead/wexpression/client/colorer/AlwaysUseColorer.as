package com.settinghead.wenwentu.client.colorer
{
	import com.settinghead.wenwentu.client.model.vo.WordVO;
	
	public class AlwaysUseColorer implements WordColorer
	{
		
		private var color:uint;
		public function AlwaysUseColorer(color:uint)
		{
			this.color = color;
		}
		
		public function colorFor(word:WordVO):uint
		{
			return color;
		}
	}
}