package com.settinghead.tyful.client.controller.main
{
	import com.settinghead.tyful.client.TyfulClient;
	import com.settinghead.tyful.client.view.ApplicationMediator;
	import com.settinghead.tyful.client.view.ShopMediator;
	import com.settinghead.tyful.client.view.TemplateEditorMediator;
	import com.settinghead.tyful.client.view.TuMediator;
	import com.settinghead.tyful.client.view.components.template.TemplateEditor;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.loadup.model.LoadupMonitorProxy;
	
	public class PrepViewCommand extends SimpleCommand
	{
		/**
		 * Prepare the View.
		 * 
		 * Get the View Components for the Mediators from the app,
		 * a reference to which was passed on the original startup 
		 * notification.
		 */
		override public function execute( note:INotification ) : void    
		{
			var app:TyfulClient = TyfulClient( note.getBody() );
			facade.registerMediator(new ApplicationMediator(app.applicationComponent));	
			facade.registerMediator( new TemplateEditorMediator( app.applicationComponent.mainArea.templateEditor ) );
			facade.registerMediator(new TuMediator(app.applicationComponent.mainArea.tuRenderer));
			facade.registerMediator(new ShopMediator(app.applicationComponent.shopItemList));
		}
	}
}