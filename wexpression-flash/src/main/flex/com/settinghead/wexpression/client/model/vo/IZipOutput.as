package com.settinghead.wexpression.client.model.vo
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public interface IZipOutput
	{
		function putStringToFile(fileName:String, data:String):void;
		function putBytesToFile(fileName:String, bytes:ByteArray):void;
		function putBitmapDataToPNGFile(fileName: String, bmpData:BitmapData):void;
		function process(object:Object, dirName:String = null):void;
	}
}