package com.settinghead.wenwentu.client.density
{
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IIterator;

	public class PatchQueue {
		/**
		 * 
		 */
		
		private var _queue: SortedList = new SortedList(new PatchComparator());
		
		private var myLevel:int;
		private var _map: LeveledPatchMap;
		
		public function PatchQueue(myLevel:int, map:LeveledPatchMap) {
			this.myLevel = myLevel;
			this._map = map;
			if (myLevel == 0) {
				tryAdd(new Patch(0, 0, _map.getIndex().getImg().getWidth(), _map.getIndex().getImg().getHeight(), 0, null, this));
			}
		}
		
		public function getBestPatch():Patch {
			var result:Patch= poll();
//			if (result != null) {
////				result.mark(smearedArea, true);
////				tryAdd(result);
//			}
			return result;
		}
		
		public function poll():Patch {
			return this._queue.removeFirst();
		}
		
		/**
		 * @return the myLevel
		 */
		function getMyLevel():int {
			return myLevel;
		}
		
		public function remove(patch:Patch):void {
			this._queue.remove(patch);
		}
		
		public function tryAddAll(patches:Vector.<Patch>):void {
			for each (var p:Patch in patches)
				tryAdd(p);
		}
		
		public function tryAdd(p:Patch):void {
			if (p.getAverageAlpha() > DensityPatchIndex.QUEUE_ALPHA_THRESHOLD)
				this._queue.add(p);
		}
		
		
		public function descend(queueLevel:int):PatchQueue {
			var queue:PatchQueue= new PatchQueue(queueLevel, this._map);
			var it:IIterator = this._queue.iterator();
			while(it.hasNext()){
				 var patch:Patch = it.next();
				queue.tryAddAll(patch.divideIntoNineOrMore());
			}
			return queue;
		}

		public function getMap(): LeveledPatchMap{
			return this._map;
		}
	}
}