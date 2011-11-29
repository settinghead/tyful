package com.settinghead.wenwentu.client.density
{
	public class LeveledPatchMap {
		
		private var _map : Vector.<PatchQueue> = new Vector.<PatchQueue>();
		private var _index : DensityPatchIndex; 
		
		public function LeveledPatchMap(index:DensityPatchIndex){
			this._index = index;
			//top level map
			var topLevelQueue:PatchQueue= new PatchQueue(0, this);
			this._map.push(topLevelQueue);
		}
		
		
		public function getBestPatchAtLevel(level:int, smearedArea:int):Patch {
			var queue:PatchQueue= getQueue(level);
			return queue.getBestPatch(smearedArea);
		}
		
		private function getQueue(level:int):PatchQueue {
			if (level >= _map.length)
				generateLevelQueue(level);
			return _map[level];
			
		}
		
		private function generateLevelQueue(level:int):void {
			if (level > _map.length)
				generateLevelQueue(level - 1);
			_map.push((_map[_map.length - 1].descend(level)));
			
		}
		
		public function getIndex():DensityPatchIndex{
			return this._index;
		}
	}
}