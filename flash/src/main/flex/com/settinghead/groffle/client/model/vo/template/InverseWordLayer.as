package com.settinghead.groffle.client.model.vo.template
{
	import com.settinghead.groffle.client.model.vo.IImageShape;
	
	[Bindable]
	public class InverseWordLayer implements IImageShape
	{
		private var _l:WordLayer;
		
		public function InverseWordLayer(wordLayer:WordLayer = null)
		{
			this._l = wordLayer;
		}
		
		public function contains(x:Number, y:Number, width:Number, height:Number, rotation:Number, transformed:Boolean):Boolean
		{
			return !_l.contains(x,y,width,height,rotation,transformed);
		}
		
		public function containsPoint(x:Number, y:Number, transformed:Boolean,  refX:Number=-1,refY:Number=-1):Boolean
		{
			return !_l.containsPoint(x,y,transformed,refX,refY);
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
		
		public function get type():String{
			return "InverseWordLayer";
		}
	}
}