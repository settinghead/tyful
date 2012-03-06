package com.settinghead.wexpression.client.controller.template
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.WordListProxy;
	import com.settinghead.wexpression.client.model.business.TemplateDelegate;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.model.vo.WordListVO;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import flash.net.Responder;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import org.as3commons.collections.utils.NullComparator;
	import org.as3commons.lang.Assert;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GenerateTemplatePreviewCommand extends SimpleCommand implements IResponder
	{
		
		private var tuProxy:TuProxy ;
		
		private var responder:IResponder;

		public function GenerateTemplatePreviewCommand(){
			super();
			this.tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
		}
		
		override public function execute( note:INotification ) : void    {
			this.responder = note.getBody() as IResponder;
			var template:TemplateVO = note.getBody() as TemplateVO;
			Assert.notNull(template);
			tuProxy.setData(template);
			var wordListProxy:WordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;
			tuProxy.previewGenerationResponder = this;
			var tu:TuVO = new TuVO(template,wordListProxy.sampleWordList());
			tuProxy.tu = tu;
			sendNotification(ApplicationFacade.GENERATE_TU);
		}
		
		public function result(data:Object):void
		{
			tuProxy.previewGenerationResponder = null;
			responder.result(data);
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeBusyCursor();
			responder.fault(info);
		}
	}
}