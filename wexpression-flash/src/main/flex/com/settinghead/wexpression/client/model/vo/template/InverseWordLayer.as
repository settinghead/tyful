package com.settinghead.wexpression.client.model.vo.template
{
	import com.settinghead.wexpression.client.model.vo.IImageShape;
	
	public class InverseWordLayer implements IImageShape
	{
		private var _l:WordLayer;
		
		public function InverseWordLayer(wordLayer:WordLayer)
		{
			this._l = wordLayer;
		}
		
		public function contains(x:Number, y:Number, width:Number, height:Number, rotation:Number, transformed:Boolean):Boolean
		{
			return !_l.contains(x,y,width,height,rotation,transformed);
		}
		
		public function containsPoint(x:Number, y:Number, transformed:Boolean):Boolean
		{
			return !_l.containsPoint(x,y,transformed);
		}
		
		public function intersects(x:Number, y:Number, width:Number, height:Number, transformed:Boolean):Boolean
		{
			return !_l.intersects(x,y,width,height,transformed);
		}
		
		public function get width():Number
		{
			return _l.width;
		}
		
		public function get height():Number
		{
			return _l.height;
		}
	}
}