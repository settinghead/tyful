package com.settinghead.tyful.client.model
{
	import com.settinghead.tyful.client.model.vo.IShape;

	public interface IShapeGenerator
	{
		function nextShape(sid:int, shrinkage:Number):IShape;
	}
}