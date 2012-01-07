package com.settinghead.wexpression.client.density
{
	import flash.utils.Dictionary;
	
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.Treap;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.lang.Assert;

	public class PatchQueue extends SortedList {
		/**
		 * 
		 */
		
//		private var _queue: Treap = new Treap(new PatchComparator());
		
		private var myLevel:int;
		private var _map: LeveledPatchMap;
		private var _lookupMap:Dictionary = new Dictionary();
		
		public function PatchQueue(myLevel:int, map:LeveledPatchMap) {
			super(new PatchComparator());
			this.myLevel = myLevel;
			this._map = map;
			if (myLevel == 0) {
				tryAdd(new Patch(0, 0, _map.getIndex().getImg().getWidth(), _map.getIndex().getImg().getHeight(), 0, null, this));
			}
		}
		
		public function getBestPatch():Patch {
			var result:Patch= poll();
			return result;
		}
		
		private function poll():Patch {
			return super.removeFirst();
		}
		
		/**
		 * @return the myLevel
		 */
		function getMyLevel():int {
			return myLevel;
		}
		
		
		public function tryAddAll(patches:Vector.<Patch>):void {
			for each (var p:Patch in patches)
				tryAdd(p);
		}
		
		public function tryAdd(p:Patch):void {
			if (p.getAverageAlpha() > DensityPatchIndex.QUEUE_ALPHA_THRESHOLD){
				super.add(p);
				_lookupMap[p.getX().toString()+", " +p.getY().toString()] = p;
				trace(p.getX().toString()+", " +p.getY().toString());
			}
			else 
				trace (p.getAverageAlpha());
		}
		
		public function patchAtCoordinate(x:Number, y:Number){
			var p:Patch = _lookupMap[x.toString()+", "+y.toString()];
			trace("lookup patch: " +x.toString()+", "+y.toString());
			return p;
		}
		
		public function descend(queueLevel:int):PatchQueue {
			var queue:PatchQueue= new PatchQueue(queueLevel, this._map);
			var it:IIterator = super.iterator();
			while(it.hasNext()){
				 var patch:Patch = it.next();
				 var children:Vector.<Patch> = patch.divideIntoNineOrMore(queue);
//				 Assert.isTrue(children.length == DensityPatchIndex.NUMBER_OF_DIVISIONS);
				queue.tryAddAll(children);
			}
			return queue;
		}

		public function getMap(): LeveledPatchMap{
			return this._map;
		}
	}
}