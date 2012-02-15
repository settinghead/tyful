package com.settinghead.wexpression.client.model.vo.template.colorer
{
	import com.lorentz.SVG.utils.MathUtils;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	import com.settinghead.wexpression.client.model.vo.template.WordColorer;
	
	import de.polygonal.utils.PM_PRNG;
	
	import mx.utils.ColorUtil;
	
	import org.peaceoutside.utils.ColorMath;
	
	public class TwoHuesRandomSatsColorer extends WordColorer
	{
		private var hues:Array;
		private var prng:PM_PRNG = new PM_PRNG();
		public function TwoHuesRandomSatsColorer()
		{
			hues= new Array(Math.random()*256, Math.random()*256 );

		}
		
		public override function colorFor(word:WordVO):uint
		{
			var hue:Number= hues[prng.nextIntRange(0,hues.length-1)];
//			var sat:Number= Math.random()*256;
			var sat:Number= prng.nextIntRange(150, 256);
			var val:Number= prng.nextIntRange(50, 256);
			
			
			return ColorMath.HSLToRGB(hue/256, sat/256, val/256);
		}
	}
}