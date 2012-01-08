package com.settinghead.wexpression.client.model
{
	import com.settinghead.wexpression.client.ApplicationFacade;
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.RenderOptions;
	import com.settinghead.wexpression.client.WordShaper;
	import com.settinghead.wexpression.client.angler.MostlyHorizAngler;
	import com.settinghead.wexpression.client.angler.ShapeConfinedAngler;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.colorer.WordColorer;
	import com.settinghead.wexpression.client.fonter.WordFonter;
	import com.settinghead.wexpression.client.model.vo.DisplayWordVO;
	import com.settinghead.wexpression.client.model.vo.EngineWordVO;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.model.vo.TextShapeVO;
	import com.settinghead.wexpression.client.model.vo.TuVO;
	import com.settinghead.wexpression.client.model.vo.WordListVO;
	import com.settinghead.wexpression.client.model.vo.WordVO;
	import com.settinghead.wexpression.client.nudger.WordNudger;
	import com.settinghead.wexpression.client.placer.ShapeConfinedPlacer;
	import com.settinghead.wexpression.client.placer.WordPlacer;
	import com.settinghead.wexpression.client.sizers.WordSizer;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IIterator;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	import org.springextensions.actionscript.context.support.mxml.Template;
	
	public class TuProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = "TuProxy";
		public static const SRNAME:String = "TuSRProxy";
		
		private var _template:TemplateVO;
		private var _wordList:WordListVO;
		
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
		
		public function load() :void{
			var tu:TuVO = new TuVO(_template, _wordList);
			facade.sendNotification(ApplicationFacade.TU_INITIALIZED, tu);
		}
		
		public function set template(t:TemplateVO):void{
			this._template = t;
		}
		
		public function set wordList(wl:WordListVO):void{
			this._wordList = wl;
		}

		public function renderNextDisplayWord(tu:TuVO):void{
			//TODO
			var eWord:EngineWordVO = null;
			var word:WordVO = null;
			
			word = tu.getNextWordAndIncrement();
			if(word==null) return;
			eWord = tu.generateEngineWord(word);

			if(eWord!=null){
				tu.placeWord(eWord);
				if (eWord.wasSkipped()){
//				while (eWord.wasSkipped()){
					tu.indexOffset+=tu.words.size/15;
					if(tu.indexOffset+tu.currentWordIndex>tu.words.size)
					{
						tu.indexOffset = tu.words.size -1;
//						break;
					}
//					eWord = tu.generateEngineWord(word);
//					tu.placeWord(eWord);
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