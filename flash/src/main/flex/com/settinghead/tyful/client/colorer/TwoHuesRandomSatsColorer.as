package com.settinghead.tyful.client.colorer
{
	import com.settinghead.tyful.client.model.vo.EngineWordVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	import com.settinghead.tyful.client.model.vo.template.Layer;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	
	import de.polygonal.utils.PM_PRNG;
		
	import org.peaceoutside.utils.ColorMath;
	
	public class TwoHuesRandomSatsColorer implements WordColorer
	{
		private var hues:Array;
		private var prng:PM_PRNG = new PM_PRNG();
		public function TwoHuesRandomSatsColorer()
		{
			hues= new Array(Math.random()*256, Math.random()*256 );

		}
		
		public function colorFor(eWord:EngineWordVO):uint
		{
			var hue:Number= hues[prng.nextIntRange(0,hues.length-1)];
//			var sat:Number= Math.random()*256;
			var sat:Number= prng.nextIntRange(200, 256);
			var val:Number= prng.nextIntRange(50, 200);
			
			
			return ColorMath.HSLtoRGB(hue/256, sat/256, val/256);
		}
	}
}