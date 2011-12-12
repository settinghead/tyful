package com.settinghead.wenwentu.client.model
{
	import com.settinghead.wenwentu.client.ApplicationFacade;
	import com.settinghead.wenwentu.client.PlaceInfo;
	import com.settinghead.wenwentu.client.RenderOptions;
	import com.settinghead.wenwentu.client.placer.ShapeConfinedPlacer;
	import com.settinghead.wenwentu.client.WordShaper;
	import com.settinghead.wenwentu.client.angler.MostlyHorizAngler;
	import com.settinghead.wenwentu.client.angler.ShapeConfinedAngler;
	import com.settinghead.wenwentu.client.angler.WordAngler;
	import com.settinghead.wenwentu.client.colorer.WordColorer;
	import com.settinghead.wenwentu.client.fonter.WordFonter;
	import com.settinghead.wenwentu.client.model.vo.DisplayWordVO;
	import com.settinghead.wenwentu.client.model.vo.EngineWordVO;
	import com.settinghead.wenwentu.client.model.vo.TemplateVO;
	import com.settinghead.wenwentu.client.model.vo.TextShapeVO;
	import com.settinghead.wenwentu.client.model.vo.TuVO;
	import com.settinghead.wenwentu.client.model.vo.WordListVO;
	import com.settinghead.wenwentu.client.model.vo.WordVO;
	import com.settinghead.wenwentu.client.nudger.WordNudger;
	import com.settinghead.wenwentu.client.placer.WordPlacer;
	import com.settinghead.wenwentu.client.sizers.WordSizer;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IIterator;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class TuProxy extends Proxy
	{
		public static const NAME:String = "TuProxy";
		
		public function TuProxy()
		{
			super(NAME, new ArrayCollection());

		}
		
		// add an item to the data    
		public function addItem( item:Object ):void
		{
			tus.addItem( item );
		}
		
		// return data property cast to proper type
		public function get tus():ArrayCollection
		{
			return data as ArrayCollection;
		}
		var indexOffset:int=0;

		public function renderNextDisplayWord(tu:TuVO):void{
			//TODO
			var eWord:EngineWordVO = null;
			var word:WordVO = null;
			
			word = tu.getNextWordAndIncrement();
			if(word==null) return;
			eWord = tu.generateEngineWord(word, indexOffset);
		
			if(eWord!=null){
				tu.placeWord(eWord);
//				while (eWord.wasSkipped()){
//					indexOffset+=tu.words.size/100;
//					if(indexOffset+tu.currentWordIndex>tu.words.size) break;
//					eWord = tu.generateEngineWord(word,indexOffset);
//					tu.placeWord(eWord);
//				}
				if (eWord.wasSkipped()){
					indexOffset+=tu.words.size/15;
					if(indexOffset+tu.currentWordIndex>tu.words.size) indexOffset = tu.words.size -1;
				}				
				
				tu.pushEngineWord(eWord);
				var dw:DisplayWordVO = null;
				if(!eWord.wasSkipped()){
					dw = eWord.rendition(tu.template.colorer.colorFor(word));
					tu.dWords.addItem(dw);
				}
				sendNotification(ApplicationFacade.DISPLAYWORD_CREATED, dw);

			}
		}
	}
}