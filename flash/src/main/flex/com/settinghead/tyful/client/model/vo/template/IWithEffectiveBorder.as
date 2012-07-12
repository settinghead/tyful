package com.settinghead.tyful.client.model.vo.template
{
	import flash.geom.Rectangle;

	public interface IWithEffectiveBorder
	{
		function generateEffectiveBorder():void;			
		function get effectiveBorder():Rectangle;

	}
}