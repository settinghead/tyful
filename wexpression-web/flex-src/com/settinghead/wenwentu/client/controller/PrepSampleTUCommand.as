package com.settinghead.wenwentu.client.controller
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.model.TuProxy;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.model.vo.TuVO;
	import com.settinghead.wenwentu.client.model.vo.WordListVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepSampleTUCommand extends SimpleCommand
	{
		public function PrepSampleTUCommand()
		{
			super();
		}
		
		override public function execute( note:INotification ) : void    
		{
			facade.registerProxy(new TuProxy());
			var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			var tu:TuVO = new TuVO(new TemplateVO("templates/star.png"), WordListVO.generateWords());
			tuProxy.addItem(tu);
			facade.sendNotification(ApplicationFacade.TU_CREATED, tu);
		}
	}
}