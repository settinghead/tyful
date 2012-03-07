package com.settinghead.wexpression.client.density
{
	import com.settinghead.wexpression.client.model.vo.template.Layer;

	public class LeveledPatchMap {
		
		private var _map : Vector.<PatchQueue> = new Vector.<PatchQueue>();
		private var _index : DensityPatchIndex; 
		
		public function LeveledPatchMap(index:DensityPatchIndex){
			this._index = index;
			//top level map
//			var topLevelQueue:PatchQueue= new PatchQueue(0, this);
//			this._map.push(topLevelQueue);

		}
		
		
		public function getBestPatchAtLevel(level:int):Patch {
			var queue:PatchQueue= getQueue(level);
			return queue.getBestPatch();
		}
		
		public function getQueue(level:int):PatchQueue {
			if (level >= _map.length)
				generateLevelQueue(level);
			return _map[level];
			
		}
		
		private function generateLevelQueue(level:int):void {
			if(level==0)
			{
				var topLevelQueue:PatchQueue= new PatchQueue(0, this);
				this._map.push(topLevelQueue);
			}
			else 
			{
				if (level > _map.length)
					generateLevelQueue(level - 1);
				_map.push((_map[_map.length - 1].descend(level)));
			}
			
		}
		
		public function getIndex():DensityPatchIndex{
			return this._index;
		}
		
		public function add(patch:Patch):void{
			getQueue(patch.getLevel()).tryAdd(patch);
		}
		
	}
}