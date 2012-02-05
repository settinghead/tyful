package com.settinghead.wexpression.client
{
	import com.settinghead.wexpression.client.controller.main.StartupCommand;
	import com.settinghead.wexpression.client.controller.template.LoadTemplateCommand;
	import com.settinghead.wexpression.client.controller.template.SaveTemplateCommand;
	
	import flash.display.LoaderInfo;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String                = "startup";
		public static const TU_INITIALIZED:String             = "tuInitialized";
		public static const TU_GENERATED:String             = "tuGenerated";
		public static const EDIT_TEMPLATE:String             = "editTemplate";
		public static const GENERATE_TU:String			  = "generateTu";
		public static const DISPLAYWORD_CREATED:String    = "displaywordCreated";
		public static const TEMPLATE_EDIT_MOUSE_DOWN:String = "templateEditMouseDown";
		public static const WORD_LIST_LOADED:String        = "wordListLoaded";
		public static const TEMPLATE_LOADED:String			= "templateLoaded";
		public static const LOAD_TEMPLATE:String			= "loadTemplate";
		public static const TEMPLATE_SAVED:String			= "templateSaved";
		public static const SAVE_TEMPLATE:String			= "saveTemplate";
		
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