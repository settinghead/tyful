package com.settinghead.wenwentu.client
{
	import com.settinghead.wenwentu.client.controller.StartupCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String             = "startup";
		public static const POPULATE_TEMPLATES:String    = "populateTemplates";
		public static const TEMPLATE_SELECTED:String    = "templateSelected";

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