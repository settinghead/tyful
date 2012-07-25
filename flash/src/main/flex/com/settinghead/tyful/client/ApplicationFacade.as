package com.settinghead.tyful.client
{
	import com.settinghead.tyful.client.TyfulClient;
	import com.settinghead.tyful.client.controller.main.StartupCommand;
	import com.settinghead.tyful.client.controller.shop.PrepSampleShopCommand;
	import com.settinghead.tyful.client.controller.template.DownloadTemplateCommand;
	import com.settinghead.tyful.client.controller.template.GenerateTemplatePreviewCommand;
	import com.settinghead.tyful.client.controller.template.LoadTemplateCommand;
	import com.settinghead.tyful.client.controller.template.NewTemplateCommand;
	import com.settinghead.tyful.client.controller.template.SaveTemplateCommand;
	import com.settinghead.tyful.client.controller.template.UploadTemplateCommand;
	import com.settinghead.tyful.client.controller.tu.PostToFacebookCommand;
	import com.settinghead.tyful.client.controller.tu.RenderTuCommand;
	
	import flash.display.LoaderInfo;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String                = "startup";
		public static const RENDER_TU:String             = "renderTu";
		public static const TU_IMAGE_GENERATED:String             = "tuImageGenerated";
		public static const EDIT_TEMPLATE:String             = "editTemplate";
		public static const GENERATE_TU_IMAGE:String			  = "generateTuImage";
		public static const DISPLAYWORD_CREATED:String    = "displaywordCreated";
		public static const TEMPLATE_EDIT_MOUSE_DOWN:String = "templateEditMouseDown";
		public static const WORD_LIST_LOADED:String        = "wordListLoaded";
		public static const TEMPLATE_LOADED:String			= "templateLoaded";
		public static const DOWNLOAD_TEMPLATE:String			= "downloadTemplate";
		public static const LOAD_TEMPLATE:String			= "loadTemplate";
		public static const NEW_TEMPLATE:String			= "newTemplate";
		public static const TEMPLATE_SAVED:String			= "templateSaved";
		public static const TEMPLATE_CREATED:String         = "tempalteCreated";
		public static const TEMPLATE_UPLOADED:String			= "templateUploaded";
		public static const SAVE_TEMPLATE:String			= "saveTemplate";
		public static const UPLOAD_TEMPLATE:String			= "uploadTemplate";
		public static const GENERATE_TEMPLATE_PREVIEW:String = "generateTemplatePreview";
		public static const TEMPLATE_PREVIEW_GENERATED:String= "templatePreviewGenerated";
		public static const TU_GENERATION_LAST_CALL:String	= "tuGenerationLastCall";
		public static const SHOW_SHOP:String				= "showShop";
		public static const POST_TO_FACEBOOK:String				= "postToFacebook";
//		public static const PROCESS_SHOP_CLICK:String		= "processShopClick";
		
		public static const MODE_EDIT_TEMPLATE:String	= "editTemplate";
		public static const MODE_SHOW_TEMPLATE:String	= "showTemplate";
		public static const MODE_RENDER_TU:String	= "renderTu";
		public static const MODE_NEW_TEMPLATE:String	= "newTemplate";
		
		
		
		/**
		 * Start the application
		 */
		public function startup( app:TyfulClient ):void
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
			registerCommand (DOWNLOAD_TEMPLATE, DownloadTemplateCommand);
			registerCommand (SAVE_TEMPLATE, SaveTemplateCommand);
			registerCommand (UPLOAD_TEMPLATE, UploadTemplateCommand);
			registerCommand (LOAD_TEMPLATE, LoadTemplateCommand);
			registerCommand (GENERATE_TEMPLATE_PREVIEW, GenerateTemplatePreviewCommand);
			registerCommand (TEMPLATE_PREVIEW_GENERATED, UploadTemplateCommand);
//			registerCommand (GENERATE_TU_IMAGE, GenerateTuCommand);
			registerCommand ( NEW_TEMPLATE, NewTemplateCommand);
			registerCommand ( RENDER_TU, RenderTuCommand);
			registerCommand (POST_TO_FACEBOOK, PostToFacebookCommand);
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