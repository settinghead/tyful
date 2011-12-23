package com.settinghead.wenwentu.client.controller
{
	import com.settinghead.wenwentu.client.WenwentuClient;
	import com.settinghead.wenwentu.client.view.ApplicationMediator;
	import com.settinghead.wenwentu.client.view.TemplateEditorMediator;
	import com.settinghead.wenwentu.client.view.TemplateListMediator;
	import com.settinghead.wenwentu.client.view.TuMediator;
	import com.settinghead.wenwentu.client.view.components.template.TemplateEditor;
	
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
			var app:WenwentuClient = WenwentuClient( note.getBody() );
			facade.registerMediator( new TemplateListMediator( app.applicationComponent.templateList ) );
			facade.registerMediator( new TemplateEditorMediator( app.applicationComponent.templateEditor ) );
			facade.registerMediator(new TuMediator(app.applicationComponent.tuRenderer));
			facade.registerMediator(new ApplicationMediator(app.applicationComponent));	
		}
	}
}