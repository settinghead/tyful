package com.settinghead.wexpression.client.controller.template
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.WordListProxy;
	import com.settinghead.wexpression.client.model.business.TemplateDelegate;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.model.vo.WordListVO;
	import com.settinghead.wexpression.client.model.vo.template.Template;
	
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

		public function GenerateTemplatePreviewCommand(){
			super();
			this.tuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
		}
		
		override public function execute( note:INotification ) : void    {
			var template:Template = note.getBody() as Template;
			Assert.notNull(template);
			tuProxy.setData(template);
			var wordListProxy:WordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;
			tuProxy.previewGenerationResponder = this;
			var tu:TuVO = new TuVO(template,wordListProxy.sampleWordList());
			sendNotification(ApplicationFacade.GENERATE_TU, tu);
		}
		
		public function result(data:Object):void
		{
			tuProxy.previewGenerationResponder = null;
			sendNotification(ApplicationFacade.TEMPLATE_PREVIEW_GENERATED, data);
		}
		
		public function fault(info:Object):void
		{
			CursorManager.removeBusyCursor();
			Alert.show("Error: "+ info.toString());
		}
	}
}