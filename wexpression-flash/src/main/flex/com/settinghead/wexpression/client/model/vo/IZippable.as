package com.settinghead.wexpression.client.model.vo
{
	import flash.utils.Dictionary;

	public interface IZippable
	{
		function writeNonJSONPropertiesToZip(output:IZipOutput):void;
		function readNonJSONPropertiesFromZip(input:IZipInput):void;
		function saveProperties(dict:Object):void;
	}
}