package com.settinghead.tyful.client.controller.template
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.RenderProxy;
	import com.settinghead.tyful.client.model.TemplateProxy;
	import com.settinghead.tyful.client.model.WordListProxy;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class UpdateRenderResourcesCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) : void    {
			var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
			var renderProxy:RenderProxy = facade.retrieveProxy(RenderProxy.NAME) as RenderProxy;
			var wordListProxy:WordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;

			if(templateProxy.template!=null) renderProxy.updateTemplate(templateProxy.template);
			if(wordListProxy.wordList!=null) renderProxy.updateWordList(wordListProxy.wordList);
		}
	}
}