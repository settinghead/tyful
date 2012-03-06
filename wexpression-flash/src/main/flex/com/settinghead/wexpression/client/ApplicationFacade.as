package com.settinghead.wexpression.client
{
	import com.settinghead.wexpression.client.controller.main.StartupCommand;
	import com.settinghead.wexpression.client.controller.template.GenerateTemplatePreviewCommand;
	import com.settinghead.wexpression.client.controller.template.LoadTemplateCommand;
	import com.settinghead.wexpression.client.controller.template.SaveTemplateCommand;
	import com.settinghead.wexpression.client.controller.template.UploadTemplateCommand;
	import com.settinghead.wexpression.client.controller.tu.GenerateTuCommand;
	
	import flash.display.LoaderInfo;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String                = "startup";
		public static const RENDER_TU:String             = "renderTu";
		public static const TU_GENERATED:String             = "tuGenerated";
		public static const EDIT_TEMPLATE:String             = "editTemplate";
		public static const GENERATE_TU:String			  = "generateTu";
		public static const DISPLAYWORD_CREATED:String    = "displaywordCreated";
		public static const TEMPLATE_EDIT_MOUSE_DOWN:String = "templateEditMouseDown";
		public static const WORD_LIST_LOADED:String        = "wordListLoaded";
		public static const TEMPLATE_LOADED:String			= "templateLoaded";
		public static const LOAD_TEMPLATE:String			= "loadTemplate";
		public static const TEMPLATE_SAVED:String			= "templateSaved";
		public static const TEMPLATE_UPLOADED:String			= "templateUploaded";
		public static const SAVE_TEMPLATE:String			= "saveTemplate";
		public static const UPLOAD_TEMPLATE:String			= "uploadTemplate";
		public static const GENERATE_TEMPLATE_PREVIEW:String = "generateTemplatePreview";
		public static const TEMPLATE_PREVIEW_GENERATED:String= "templatePreviewGenerated";
		public static const TU_GENERATION_LAST_CALL:String	= "tuGenerationLastCall";
		
		
		/**
		 * Start the application
		 */
		public function startup( app:WexpressionClient ):void
		{
			sendNotification( STARTUP, app );    
		}
		
		/**
		 * Register Commands with the Controller 
		 */
		override protected function initializeController( ) : void 
		{
			super.initializeController();            
			registerCommand( STARTUP, StartupCommand );	
			registerCommand (LOAD_TEMPLATE, LoadTemplateCommand);
			registerCommand (SAVE_TEMPLATE, SaveTemplateCommand);
			registerCommand (UPLOAD_TEMPLATE, UploadTemplateCommand);
			registerCommand (GENERATE_TEMPLATE_PREVIEW, GenerateTemplatePreviewCommand);
			registerCommand (GENERATE_TU, GenerateTuCommand);
		}
		
		/**
		 * Singleton Factory Method
		 */
		public static function getInstance() : ApplicationFacade {
			if ( instance == null ) instance = new ApplicationFacade( );
			return ApplicationFacade( instance ) ;
		}
	}
}