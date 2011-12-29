package com.settinghead.wexpression.client.controller
{
	import com.settinghead.wexpression.client.WexpressionClient;
	import com.settinghead.wexpression.client.view.ApplicationMediator;
	import com.settinghead.wexpression.client.view.ShopMediator;
	import com.settinghead.wexpression.client.view.TemplateEditorMediator;
	import com.settinghead.wexpression.client.view.TemplateListMediator;
	import com.settinghead.wexpression.client.view.TuMediator;
	import com.settinghead.wexpression.client.view.components.template.TemplateEditor;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
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
			var app:WexpressionClient = WexpressionClient( note.getBody() );
			facade.registerMediator( new TemplateListMediator( app.applicationComponent.templateList ) );
			facade.registerMediator( new TemplateEditorMediator( app.applicationComponent.templateEditor ) );
			facade.registerMediator(new TuMediator(app.applicationComponent.tuRenderer));
			facade.registerMediator(new ShopMediator(app.applicationComponent.shopItemList));
			facade.registerMediator(new ApplicationMediator(app.applicationComponent));	
		}
	}
}