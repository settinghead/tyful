package com.settinghead.tyful.client.model
{
	import flash.display.BitmapData;

	public interface ITuImageGenerator
	{
		function canvasImage(resolution:int):BitmapData;
		function get rendering():Boolean;
	}
}