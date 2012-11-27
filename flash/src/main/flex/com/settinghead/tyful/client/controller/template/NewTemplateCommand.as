package com.settinghead.tyful.client.controller.template
{
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.TemplateProxy;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	
	import flash.net.FileReference;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NewTemplateCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) : void    {
			//Nothing to do
		}
	}
}