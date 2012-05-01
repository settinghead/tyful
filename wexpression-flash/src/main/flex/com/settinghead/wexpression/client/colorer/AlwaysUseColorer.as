package com.settinghead.wexpression.client.colorer
{
	import com.settinghead.wexpression.client.model.vo.EngineWordVO;
	import com.settinghead.wexpression.client.model.vo.wordlist.WordVO;
	
	public class AlwaysUseColorer implements WordColorer
	{
		
		private var color:uint;
		public function AlwaysUseColorer(color:uint)
		{
			this.color = color;
		}
		
		public function colorFor(eWord:EngineWordVO):uint
		{
			return color;
		}
	}
}