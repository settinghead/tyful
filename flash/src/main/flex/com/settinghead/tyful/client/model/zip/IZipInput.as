package com.settinghead.tyful.client.model.zip
{
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	
	import flash.utils.ByteArray;

	public interface IZipInput
	{
		function parse(b:ByteArray):TemplateVO;
	}
}