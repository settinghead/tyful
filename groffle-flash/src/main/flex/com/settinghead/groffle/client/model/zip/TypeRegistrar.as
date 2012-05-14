package com.settinghead.groffle.client.model.zip
{
	import com.settinghead.groffle.client.NotImplementedError;
	import com.settinghead.groffle.client.model.vo.template.InverseWordLayer;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	import com.settinghead.groffle.client.model.vo.template.WordLayer;

	public class TypeRegistrar
	{
		public static function getObject(type:String, name:String = null, parent:* = null, grandParent:* = null):*{
			switch(type){
				case "Template":
					return new TemplateVO();
					break;
				case "WordLayer":
					return new WordLayer("layer"+name, grandParent, -1, -1, false);
					break;
				case "InverseWordLayer":
					return new InverseWordLayer();
					break;
				default:
					throw new NotImplementedError();
			}
		}
	}
}