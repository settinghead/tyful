package com.settinghead.wenwentu.client
{
	import com.settinghead.wenwentu.client.controller.StartupCommand;
	
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
		public static const TEMPLATE_SELECTED:String	  = "templateSelected";
		public static const TEMPLATE_EDIT_MOUSE_DOWN:String = "templateEditMouseDown";
		
		/**
		 * Start the application
		 */
		public function startup( app:WenwentuClient ):void
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
			registerCommand( GENERATE_TU, StartupCommand );
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