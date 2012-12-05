package com.settinghead.tyful.client.model
{
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.IShape;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;

	public class TextShapeGenerator implements IShapeGenerator
	{
		[Embed(source="../fonter/konstellation/panefresco-500.ttf", fontFamily="panefresco500", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const Panefresco500: Class;
		[Embed(source="../fonter/konstellation/permanentmarker.ttf", fontFamily="permanentmarker", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const PermanentMarker: Class;
		[Embed(source="../fonter/konstellation/romeral.ttf", fontFamily="romeral", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const Romeral: Class;
		
		[Embed(source="../fonter/konstellation/bpreplay-kRB.ttf", fontFamily="bpreplay-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const BpreplayKRB: Class;
		[Embed(source="../fonter/konstellation/fifthleg-kRB.ttf", fontFamily="fifthleg-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const FifthlegKRB: Class;
		[Embed(source="../fonter/konstellation/pecita-kRB.ttf", fontFamily="pecita-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const PecitaKRB: Class;
		[Embed(source="../fonter/konstellation/sniglet-kRB.ttf", fontFamily="sniglet-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
		public static const snigletKRB: Class;
		
		public static const NAME:String = "RenderProxy";
		public static const SRNAME:String = "RenderSRProxy";
		public static var current:RenderProxy;
		private var fonts:Array = ["romeral","permanentmarker","fifthleg-kRB"];
		
		public var wordList:WordListVO;
		private var current:int = 0;
		public function TextShapeGenerator(wordList:WordListVO)
		{
			this.wordList = wordList;
		}
		
		public function nextShape(sid:int, shrinkage:Number):IShape{
			var word:WordVO = this.wordList.at(current++);
			var fontSize:Number = 100*shrinkage+10;
			var index:int = Math.floor((Math.random()*fonts.length));
			var fontName:String = fonts[index];
			var dw:DisplayWordVO = new DisplayWordVO(sid, word, fontName, fontSize );
			return dw;
		}
	}
}