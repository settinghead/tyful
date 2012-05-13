package com.settinghead.wexpression.client.model.zip
{
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import flash.utils.ByteArray;

	public interface IZipInput
	{
		function parse(b:ByteArray):TemplateVO;
	}
}