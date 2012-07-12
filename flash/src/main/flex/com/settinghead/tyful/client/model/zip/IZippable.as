package com.settinghead.tyful.client.model.zip
{
	import flash.utils.Dictionary;

	public interface IZippable
	{
		function writeNonJSONPropertiesToZip(output:IZipOutput):void;
		function readNonJSONPropertiesFromZip(input:IZipInput):void;
		function saveProperties(dict:Object):void;
		function get type():String;
		function set type(t:String):void;
	}
}