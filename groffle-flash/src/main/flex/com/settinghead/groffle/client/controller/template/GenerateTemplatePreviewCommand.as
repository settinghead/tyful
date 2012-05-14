package com.settinghead.groffle.client.controller.template
{
	import com.settinghead.groffle.client.ApplicationFacade;
	import com.settinghead.groffle.client.model.TemplateProxy;
	import com.settinghead.groffle.client.model.TuProxy;
	import com.settinghead.groffle.client.model.WordListProxy;
	import com.settinghead.groffle.client.model.vo.TuVO;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	import com.settinghead.groffle.client.model.vo.wordlist.WordListVO;
	
	import flash.net.Responder;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	
	import net.codestore.flex.Mask;
	
	import org.as3commons.collections.utils.NullComparator;
	import org.as3commons.lang.Assert;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GenerateTemplatePreviewCommand extends SimpleCommand
	{
		
		private var tuProxy:TuProxy ;
		private var templateProxy:TemplateProxy ;
		
		private var responder:IResponder;

		public function GenerateTemplatePreviewCommand(){
			super();
		}
		
		override public function execute( note:INotification ) : void  
		{
					//this.responder = note.getBody() as IResponder;
					var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
					var templateProxy:TemplateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
					
					var template:TemplateVO = templateProxy.template;
					Assert.notNull(template);
					tuProxy.setData(template);
					var wordListProxy:WordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;
					//tuProxy.previewGenerationResponder = this;
					var tu:TuVO = new TuVO(template,wordListProxy.sampleWordList());
					tuProxy.tu = tu;
					tuProxy.generateTemplatePreview = true;
					Mask.show("I am creating a sample artwork for your template so that others can see what your template looks like. Just a moment.");
					sendNotification(ApplicationFacade.RENDER_TU);
	
		}
		
//		public function result(data:Object):void
//		{
//			tuProxy.previewGenerationResponder = null;
//			responder.result(data);
//		}
//		
//		public function fault(info:Object):void
//		{
//			CursorManager.removeBusyCursor();
//			responder.fault(info);
//		}
	}
}