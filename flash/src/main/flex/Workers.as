/*******************************************************************************************************************************************
 * This is an automatically generated class. Please do not modify it since your changes may be lost in the following circumstances:
 *     - Members will be added to this class whenever an embedded worker is added.
 *     - Members in this class will be renamed when a worker is renamed or moved to a different package.
 *     - Members in this class will be removed when a worker is deleted.
 *******************************************************************************************************************************************/

package 
{
	
	import flash.utils.ByteArray;
	
	public class Workers
	{
		
		[Embed(source="../../../workerswfs/com/settinghead/tyful/client/algo/PolarWorker.swf", mimeType="application/octet-stream")]
		private static var com_settinghead_tyful_client_algo_PolarWorker_ByteClass:Class;
		public static function get com_settinghead_tyful_client_algo_PolarWorker():ByteArray
		{
			return new com_settinghead_tyful_client_algo_PolarWorker_ByteClass();
		}
		
	}
}
