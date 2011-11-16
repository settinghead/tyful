package wordcram {
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

import java.awt.*;
import java.awt.geom.GeneralPath;
import java.awt.geom.Rectangle2D;
import java.util.ArrayList;

import processing.core.*;

public class WordCramEngine {

	private var destination:PGraphics;
	
	private var fonter:WordFonter;
	private var sizer:WordSizer;
	private var colorer:WordColorer;
	private var angler:WordAngler;
	private var placer:WordPlacer;
	private var nudger:WordNudger;
	
	private var words:Array; // just a safe copy
	private var eWords:Array;
	private var eWordIndex:int= -1;
	
	private var renderOptions:RenderOptions;
	
	WordCramEngine(var destination:PGraphics, var words:Array, var fonter:WordFonter, var sizer:WordSizer, var colorer:WordColorer, var angler:WordAngler, var placer:WordPlacer, var nudger:WordNudger, var shaper:WordShaper, var bbTreeBuilder:BBTreeBuilder, var renderOptions:RenderOptions) {
		
		if (destination.getClass() == (PGraphics2D.class)) {
			throw new Error("WordCram can't work with P2D buffers, sorry - try using JAVA2D.");
		}
		
		this.destination = destination;
		
		this.fonter = fonter;
		this.sizer = sizer;
		this.colorer = colorer;
		this.angler = angler;
		this.placer = placer;
		this.nudger = nudger;
		
		this.renderOptions = renderOptions;
		this.words = words;
		this.eWords = wordsIntoEngineWords(words, shaper, bbTreeBuilder);
	}
	
	private EngineWord[] wordsIntoEngineWords(var words:Array, var wordShaper:WordShaper, var bbTreeBuilder:BBTreeBuilder) {
		ArrayList<EngineWord> engineWords = new ArrayList<EngineWord>();
		
		var maxNumberOfWords:int= renderOptions.maxNumberOfWordsToDraw >= 0?
								renderOptions.maxNumberOfWordsToDraw :
								words.length;
		for (var i:int= 0; i < maxNumberOfWords; i++) {
			
			var word:Word= words[i];
			var eWord:EngineWord= new EngineWord(word, i, words.length, bbTreeBuilder);
			
			var wordFont:PFont= word.getFont(fonter);
			var wordSize:Number= word.getSize(sizer, i, words.length);
			var wordAngle:Number= word.getAngle(angler);
			
			var shape:Shape= wordShaper.getShapeFor(eWord.word.word, wordFont, wordSize, wordAngle, renderOptions.minShapeSize);
			if (shape == null) {
				skipWord(word, WordCram.SHAPE_WAS_TOO_SMALL);
			}
			else {
				eWord.setShape(shape, renderOptions.wordPadding);
				engineWords.add(eWord);  // DON'T add eWords with no shape.
			}
		}
		
		for (var i:int= maxNumberOfWords; i < words.length; i++) {
			skipWord(words[i], WordCram.WAS_OVER_MAX_NUMBER_OF_WORDS);
		}
		
		return engineWords.toArray(new EngineWord[0]);
	}
	
	private function skipWord(word:Word, reason:int):void {
		// TODO delete these properties when starting a sketch, in case it's a re-run w/ the same words.
		// NOTE: keep these as properties, because they (will be) deleted when the WordCramEngine re-runs.
		word.wasSkippedBecause(reason);
	}
	
	function hasMore():Boolean {
		return eWordIndex < eWords.length-1;
	}
	
	function drawAll():void {
		while(hasMore()) {
			drawNext();
		}
	}
	
	function drawNext():void {
		if (!hasMore()) return;
		
		var eWord:EngineWord= eWords[++eWordIndex];

		var wasPlaced:Boolean= placeWord(eWord);
		if (wasPlaced) { // TODO unit test (somehow)
			drawWordImage(eWord);
		}
	}	
	
	private function placeWord(eWord:EngineWord):Boolean {
		var word:Word= eWord.word;
		var rect:Rectangle2D= eWord.getShape().getBounds2D(); // TODO can we move these into EngineWord.setDesiredLocation? Does that make sense?		
		var wordImageWidth:int= int(rect.getWidth());
		var wordImageHeight:int= int(rect.getHeight());
		
		eWord.setDesiredLocation(placer, eWords.length, wordImageWidth, wordImageHeight, destination.width, destination.height);
		
		// Set maximum number of placement trials
		var maxAttemptsToPlace:int= renderOptions.maxAttemptsToPlaceWord > 0?
									renderOptions.maxAttemptsToPlaceWord :
									calculateMaxAttemptsFromWordWeight(word);
		
		var lastCollidedWith:EngineWord= null;
		for (var attempt:int= 0; attempt < maxAttemptsToPlace; attempt++) {
			
			eWord.nudge(nudger.nudgeFor(word, attempt));
			
			var loc:PVector= eWord.getCurrentLocation();
			if (loc.x < 0|| loc.y < 0|| loc.x + wordImageWidth >= destination.width || loc.y + wordImageHeight >= destination.height) {
				continue;
			}
			
			if (lastCollidedWith != null && eWord.overlaps(lastCollidedWith)) {
				continue;
			}
			
			var foundOverlap:Boolean= false;
			for (var i:int= 0; !foundOverlap && i < eWordIndex; i++) {
				var otherWord:EngineWord= eWords[i];
				if (eWord.overlaps(otherWord)) {
					foundOverlap = true;
					lastCollidedWith = otherWord;
				}
			}
			
			if (!foundOverlap) {
				eWord.finalizeLocation();
				return true;
			}
		}
		
		skipWord(eWord.word, WordCram.NO_SPACE);
		return false;
	}

	private function calculateMaxAttemptsFromWordWeight(word:Word):int {
		return int(((1.0 - word.weight) * 600) )+ 100;
	}
	
	private function drawWordImage(word:EngineWord):void {
		var path2d:GeneralPath= new GeneralPath(word.getShape());
		
//		Graphics2D g2 = (Graphics2D)destination.image.getGraphics();
		var g2:Graphics2D= (PGraphicsJava2D(destination)).g2;
			
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
		g2.setPaint(new Color(word.word.getColor(colorer), true));
		g2.fill(path2d);
	}
	
	function getWordAt(x:Number, y:Number):Word {
		for (var i:int= 0; i < eWords.length; i++) {
			if (eWords[i].wasPlaced()) {
				var shape:Shape= eWords[i].getShape();
				if (shape.contains(x, y)) {
					return eWords[i].word;
				}
			}
		}
		return null;
	}

	Word[] getSkippedWords() {
		ArrayList<Word> skippedWords = new ArrayList<Word>();
		for (var i:int= 0; i < words.length; i++) {
			if (words[i].wasSkipped()) {
				skippedWords.add(words[i]);
			}
		}
		return skippedWords.toArray(new Word[0]);
	}
	
	function getProgress():Number {
		return float(this.eWordIndex )/ this.eWords.length;
	}
}
}