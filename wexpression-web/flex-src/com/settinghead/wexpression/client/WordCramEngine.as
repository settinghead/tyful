package com.settinghead.wexpression.client {
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.colorer.WordColorer;
	import com.settinghead.wexpression.client.fonter.WordFonter;
	import com.settinghead.wexpression.client.model.vo.TemplateVO;
	import com.settinghead.wexpression.client.nudger.WordNudger;
	import com.settinghead.wexpression.client.placer.WordPlacer;
	import com.settinghead.wexpression.client.sizers.WordSizer;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.IIterator;
	import com.settinghead.wexpression.client.model.vo.TextShapeVO;
	import com.settinghead.wexpression.client.model.vo.EngineWordVO;
	import com.settinghead.wexpression.client.model.vo.WordVO;

/*
 Copyright 2010 Daniel Bernier

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


public class WordCramEngine {

	private static const MAX_ANGLER_ATTEMPTS:int= 5;

	private var destination:Sprite;
	private var img:TemplateVO;
	private var fonter:WordFonter;
	private var sizer:WordSizer;
	private var colorer:WordColorer;
	private var angler:WordAngler;
	private var placer:WordPlacer;
	private var nudger:WordNudger;

	private var words:SortedList; // just a safe copy
	private var eWords:Vector.<EngineWordVO>;
	private var eWordIndex:int= -1;

	private var renderOptions:RenderOptions;

	private var failedLastVar:Boolean;
	
	public static const  WordCram_SHAPE_WAS_TOO_SMALL:int = 0; 
	public static const  WordCram_WAS_OVER_MAX_NUMBER_OF_WORDS:int = 1;
	public static const  WordCram_NO_SPACE: int = 2;
//	 Applet applet = new Applet();
//	 Frame frame = new Frame("Roseindia.net");


	public function WordCramEngine( destination:Sprite,  words:SortedList,
									fonter:WordFonter, sizer:WordSizer,
			colorer:WordColorer, angler:WordAngler, placer:WordPlacer,
			nudger:WordNudger, renderOptions:RenderOptions, img:TemplateVO = null) {

		this.destination = destination;
		this.img = img;
		this.fonter = fonter;
		this.sizer = sizer;
		this.colorer = colorer;
		this.angler = angler;
		this.placer = placer;
		this.nudger = nudger;

		this.renderOptions = renderOptions;
		this.words = words;
		this.eWords = wordsIntoEngineWords(words);
		//
//		 frame.setSize(1400, 1400);
//		 frame.add(applet);
//		 frame.setVisible(true);
	}

	private function wordsIntoEngineWords(words:SortedList):Vector.<EngineWordVO> {
		var engineWords:Vector.<EngineWordVO> = new Vector.<EngineWordVO>();

		var maxNumberOfWords:int= renderOptions.maxNumberOfWordsToDraw >= 0? renderOptions.maxNumberOfWordsToDraw
				: words.size;
		for (var i:int= 0; i < maxNumberOfWords; i++) {

			var word:WordVO= words.itemAt(i);
			var eWord:EngineWordVO= new EngineWordVO(word, i, words.size);

			var wordFont:String= word.getFont(fonter);
			var wordSize:Number= word.getSize(sizer, i, words.size);
			var wordAngle:Number= eWord.getAngle(angler);

			var shape:TextShapeVO= WordShaper.makeShape(eWord.word.word, wordSize, wordFont, wordAngle);
			if (shape == null) {
				skipWord(word, WordCram_SHAPE_WAS_TOO_SMALL);
			} else {
				eWord.setShape(shape, renderOptions.wordPadding);
				engineWords.push(eWord); // DON'T add eWords with no shape.
			}
		}

		for (var i:int= maxNumberOfWords; i < words.size; i++) {
			skipWord(words.itemAt(i), WordCram_WAS_OVER_MAX_NUMBER_OF_WORDS);
		}

		return engineWords;
	}

	private function skipWord(word:WordVO, reason:int):void {
		// TODO delete these properties when starting a sketch, in case it's a
		// re-run w/ the same words.
		// NOTE: keep these as properties, because they (will be) deleted when
		// the WordCramEngine re-runs.
		word.wasSkippedBecause(reason);
	}

	public function hasMore():Boolean {
		return eWordIndex < eWords.length - 1;
	}

	public function drawAll():void {
		while (hasMore()) {
			drawNext();
		}
	}

	public function get currentEngineWordIndex():int{
		return this.eWordIndex;
	}
	
	public function drawNext():void {
		if (!hasMore())
			return;

		var eWord:EngineWordVO= eWords[++eWordIndex];
		


		var wasPlaced:Boolean= placeWord(eWord);
		if (wasPlaced) { // TODO unit test (somehow)
			drawWordImage(eWord);
		}
	}

	private function placeWord(eWord:EngineWordVO):Boolean {
		this.failedLastVar = false;
		var word:WordVO= eWord.word;
															// these into
															// EngineWord.setDesiredLocation?
															// Does that make
															// sense?
		var wordImageWidth:int= int(eWord.getTree().getWidth(true));
		var wordImageHeight:int= int(eWord.getTree().getHeight(true));

		var info:PlaceInfo= eWord.retrieveDesiredLocations(placer, eWords.length,
				wordImageWidth, wordImageHeight, destination.width,
				destination.height);

		// Set maximum number of placement trials
		var maxAttemptsToPlace:int= renderOptions.maxAttemptsToPlaceWord > 0? renderOptions.maxAttemptsToPlaceWord
				: calculateMaxAttemptsFromWordWeight(word);

		var lastCollidedWith:EngineWordVO= null;
		outer: for (var attempt:int= 0; attempt < maxAttemptsToPlace; attempt++) {

			eWord.nudge(nudger.nudgeFor(word, eWord.getCurrentLocation(),
					attempt));
			var angle:Number= angler.angleFor(eWord);
//			eWord.getTree().draw(destination.graphics);
			
			// // TODO
			eWord.getTree().setRotation(angle);
//
			if (eWord.trespassed(img))
				continue;
			var loc:PlaceInfo= eWord.getCurrentLocation();
			if (loc.getpVector().x < 0|| loc.getpVector().y < 0|| loc.getpVector().x + wordImageWidth >= destination.width
					|| loc.getpVector().y + wordImageHeight >= destination.height) {
				continue;
			}

			if (lastCollidedWith != null && eWord.overlaps(lastCollidedWith)) {
				continue;
			}

			var foundOverlap:Boolean= false;
			
			for (var i:int= 0; !foundOverlap && i < eWordIndex; i++) {
				var otherWord:EngineWordVO= eWords[i];
				if (otherWord.wasSkipped()) continue; //can't overlap with skipped word

				if (eWord.overlaps(otherWord)) {
					foundOverlap = true;

					lastCollidedWith = otherWord;
					continue outer;
				}
			}

			if (!foundOverlap) {
				 //eWord.getTree().draw(applet.getGraphics());
				// eWord.setShape(WordShaper.rotate(eWord.getShape(), eWord
				// .getTree().getRotation(), (float) eWord.getTree()
				// .getRootX(), (float) eWord.getTree().getRootY()), 0);
				placer.success(info.getReturnedObj());
				eWord.finalizeLocation();
				return true;
			}
		}

		skipWord(eWord.word, WordCram_NO_SPACE);
		placer.fail(info.getReturnedObj());
		this.failedLastVar = true;
		trace("failed:", info.getpVector());
		return false;
	}

	public function get failedLast():Boolean{
		return this.failedLast;
	}
	
	private function calculateMaxAttemptsFromWordWeight(word:WordVO):int {
		return int(((1.0 - word.weight) * 600) )+ 100;
	}

	private function drawWordImage(word:EngineWordVO):void {
		destination.addChild(word.getShape().rendition(colorer.colorFor(word.word)));
//		word.bbTree.draw(destination.graphics);
	}

	function getWordAt(x:Number, y:Number):WordVO {
		for (var i:int= 0; i < eWords.length; i++) {
			if (eWords[i].wasPlaced()) {
				var shape:TextShapeVO = eWords[i].getShape();
				if (shape.containsPoint(x, y,true)) {
					return eWords[i].word;
				}
			}
		}
		return null;
	}

	public function getSkippedWords():Vector.<WordVO> {
		var skippedWords:Vector.<WordVO>  = new Vector.<WordVO>();
		 var it:IIterator = words.iterator();
		 while(it.hasNext()){
			 var w:WordVO = it.next();
			 if(w.wasSkipped())
				 skippedWords.push(w);
		 }
		return skippedWords;
	}

	function getProgress():Number {
		return this.eWordIndex / this.eWords.length;
	}

}
}