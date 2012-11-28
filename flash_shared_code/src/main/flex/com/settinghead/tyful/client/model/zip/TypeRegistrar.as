package com.settinghead.tyful.client.model.zip
{
	import com.settinghead.tyful.client.model.vo.template.ImageLayer;
	import com.settinghead.tyful.client.model.vo.template.InverseWordLayer;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.template.WordLayer;

	public class TypeRegistrar
	{
		public static function getObject(type:String, name:String = null, index:int=-1, parent:* = null, grandParent:* = null):*{
			switch(type){
				case "Template":
					return new TemplateVO();
					break;
				case "WordLayer":
					return new WordLayer("Layer "+name, grandParent, -1, -1,index, false);
				case "ImageLayer":
					return new ImageLayer("Layer "+name, grandParent,null,index, false);
					break;
				case "InverseWordLayer":
					return new InverseWordLayer();
					break;
				default:
					throw new  Error("Not implemented.");
			}
		}
	}
}