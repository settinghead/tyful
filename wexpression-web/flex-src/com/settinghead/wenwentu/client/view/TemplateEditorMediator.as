package com.settinghead.wenwentu.client.view
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.model.TemplateProxy;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.view.components.TemplateEditor;
	import com.settinghead.wenwentu.client.view.components.TuRenderer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	
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
	
	}
}