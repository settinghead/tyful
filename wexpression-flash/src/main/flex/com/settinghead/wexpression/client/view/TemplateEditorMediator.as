package com.settinghead.wexpression.client.view
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.model.TemplateProxy;
	import com.settinghead.wexpression.client.model.TuProxy;
	import com.settinghead.wexpression.client.model.WordListProxy;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.model.vo.WordListVO;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.view.components.TuRenderer;
	import com.settinghead.wexpression.client.view.components.template.TemplateEditor;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TemplateEditorMediator extends Mediator
	{
		
		public static const NAME:String = "TemplateEditorMediator";
		private var _colorPicker	:Sprite;
		private var _pen			:Sprite;
		private var _eraser			:Sprite;
		private var _clear			:Sprite;
		private var _canvas			:Canvas;
		
		public function TemplateEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			templateEditor.addEventListener(TemplateEditor.RENDER_TU, renderTu);
		}
		
		
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.EDIT_TEMPLATE];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ApplicationFacade.EDIT_TEMPLATE:
					templateEditor.template = notification.getBody() as TemplateVO;
					break;
			}
		}
		
		
		override public function getMediatorName():String {
			return TemplateEditorMediator.NAME;
		}
		
		private function get templateEditor ():TemplateEditor
		{
			return viewComponent as TemplateEditor;
		}
		
		private function renderTu( event:Event = null ):void
		{
			var tuProxy:TuProxy = facade.retrieveProxy(TuProxy.NAME) as TuProxy;
			var wordListProxy:WordListProxy = facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;
			tuProxy.template =  templateEditor.template;
			tuProxy.wordList = wordListProxy.currentWordList;

			tuProxy.load();
		}
	
	}
}