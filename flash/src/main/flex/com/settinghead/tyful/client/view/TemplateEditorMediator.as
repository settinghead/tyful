package com.settinghead.tyful.client.view
{
	import com.notifications.Notification;
	import com.settinghead.tyful.client.ApplicationFacade;
	import com.settinghead.tyful.client.model.TemplateProxy;
	import com.settinghead.tyful.client.model.TuProxy;
	import com.settinghead.tyful.client.view.components.template.CreateTemplateEvent;
	import com.settinghead.tyful.client.view.components.template.TemplateEditor;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
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
		private var templateProxy:TemplateProxy;
		
		
		public function TemplateEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			templateEditor.addEventListener(TemplateEditor.RENDER_TU, renderTu);
			templateEditor.addEventListener(TemplateEditor.SAVE_TEMPLATE, saveTemplate);
			templateEditor.addEventListener(TemplateEditor.OPEN_TEMPLATE, openTemplate);
			templateEditor.addEventListener(TemplateEditor.UPLOAD_TEMPLATE, uploadTemplate);
			templateEditor.addEventListener(TemplateEditor.CREATE_TEMPLATE, createTemplate);
			templateProxy = facade.retrieveProxy(TemplateProxy.NAME) as TemplateProxy;
		}
		
		
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.EDIT_TEMPLATE,
				ApplicationFacade.TEMPLATE_LOADED,
				ApplicationFacade.TEMPLATE_CREATED,				
				ApplicationFacade.TEMPLATE_UPLOADED,
				ApplicationFacade.UPLOAD_TEMPLATE,
				ApplicationFacade.NEW_TEMPLATE
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ApplicationFacade.TEMPLATE_LOADED:
				case ApplicationFacade.TEMPLATE_CREATED:
					templateEditor.template = templateProxy.template;
					break;
				case ApplicationFacade.TEMPLATE_UPLOADED:
					ExternalInterface.call("setTemplateUuid", notification.getBody().toString());
					Notification.show("Template saved to Tyful.");

					break;
				case ApplicationFacade.UPLOAD_TEMPLATE:
					break;
				case ApplicationFacade.NEW_TEMPLATE:
					templateEditor.newTemplate();
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
			
			facade.sendNotification(ApplicationFacade.RENDER_TU);

		}
		
		private function saveTemplate( event:Event = null ):void
		{
				facade.sendNotification(ApplicationFacade.SAVE_TEMPLATE, templateEditor.template);
		}
		
		private function createTemplate(event:CreateTemplateEvent):void{

			templateProxy.newTemplate(event.width, event.height);
			setTimeout(function():void{
				Notification.show("Start by drawing something. ", "Tip",null, 10000);
			}, 2000);
		}
		
		private var ref:FileReference;
		private function openTemplate(event:Event = null):void{
			ref = new FileReference();
			var imageFileTypes:FileFilter = new FileFilter("Template file (*.zip)", "*.zip");
			ref.browse([imageFileTypes]);
			ref.addEventListener(Event.SELECT,openTemplateFileSelectedHandler);
		}
		
		private function openTemplateFileSelectedHandler(e:Event):void{ // file loaded
			ref.addEventListener(Event.COMPLETE,openTemplateCompleteHandler);
			ref.load();
		}
		
		private function openTemplateCompleteHandler(e:Event):void{ // file loaded
			var ba:ByteArray=ref.data;
			facade.sendNotification(ApplicationFacade.LOAD_TEMPLATE, ba);
		}
		
		private function uploadTemplate( event:Event = null ):void
		{

			facade.sendNotification(ApplicationFacade.UPLOAD_TEMPLATE, templateEditor.template);
		}
	
	}
}