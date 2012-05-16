package com.settinghead.wexpression.client.model.vo.template.colorer
{
	import com.settinghead.wexpression.client.model.vo.WordVO;
	import com.settinghead.wexpression.client.model.vo.template.WordColorer;
	
	public class AlwaysUseColorer extends WordColorer
	{
		
		private var _color:uint;
		public function get color():uint{
			return _color;
		}
		
		public function set color(c:uint):void{
			this._color = c;
		}
		
		public function AlwaysUseColorer(color:uint = 0x000000)
		{
			this._color = color;
		}
		
		public override function colorFor(word:WordVO):uint
		{
			return color;
		}
	}
}