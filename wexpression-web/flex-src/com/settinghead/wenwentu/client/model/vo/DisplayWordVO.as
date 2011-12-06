package com.settinghead.wenwentu.client.model.vo
{
	import com.settinghead.wenwentu.client.sizers.WordSizer;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class DisplayWordVO extends Sprite
	{
		private var _tree: BBPolarRootTreeVO;
		private var _word:WordVO;
		
		public function DisplayWordVO(tree:BBPolarRootTreeVO){
			super();
			this._tree = tree;
		}
		
		public function get tree():BBPolarRootTreeVO{
			return this._tree;
		}
	}
}