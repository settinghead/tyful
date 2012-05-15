package com.settinghead.groffle.client.model.zip
{
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	
	import flash.utils.ByteArray;

	public interface IZipInput
	{
		function parse(b:ByteArray):TemplateVO;
	}
}