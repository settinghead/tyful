package wordcram;

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

import java.applet.Applet;
import java.awt.*;
import java.awt.geom.GeneralPath;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.UUID;
import java.util.List;

import processing.core.*;
import wordcram.WordPlacer.PlaceInfo;

public class WordCramEngine {

	private static final int MAX_ANGLER_ATTEMPTS = 5;

	private PGraphics destination;

	private WordFonter fonter;
	private WordSizer sizer;
	private WordColorer colorer;
	private WordAngler angler;
	private WordPlacer placer;
	private WordNudger nudger;

	private List<Word> words; // just a safe copy
	private EngineWord[] eWords;
	private int eWordIndex = -1;

	private RenderOptions renderOptions;

	private final TemplateImage img;

//	 Applet applet = new Applet();
//	 Frame frame = new Frame("Roseindia.net");

	WordCramEngine(PGraphics destination, List<Word> words,
			WordFonter fonter, WordSizer sizer, WordColorer colorer,
			WordAngler angler, WordPlacer placer, WordNudger nudger,
			BBPolarTreeBuilder bbTreeBuilder, RenderOptions renderOptions) {
		this(destination, words, null, fonter, sizer, colorer, angler, placer,
				nudger, bbTreeBuilder, renderOptions);
	}

	WordCramEngine(PGraphics destination, List<Word> words,
			TemplateImage img, WordFonter fonter, WordSizer sizer,
			WordColorer colorer, WordAngler angler, WordPlacer placer,
			WordNudger nudger, BBPolarTreeBuilder bbTreeBuilder,
			RenderOptions renderOptions) {

		// if
		// (destination.getClass().equals(processing.core.PGraphicsJava2D.class))
		// {
		// throw new Error(
		// "WordCram can't work with P2D buffers, sorry - try using JAVA2D.");
		// }

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
		this.eWords = wordsIntoEngineWords(words, bbTreeBuilder);
		//
//		 frame.setSize(1400, 1400);
//		 frame.add(applet);
//		 frame.setVisible(true);
	}

	private EngineWord[] wordsIntoEngineWords(List<Word> words,
			BBPolarTreeBuilder bbTreeBuilder) {
		ArrayList<EngineWord> engineWords = new ArrayList<EngineWord>();

		int maxNumberOfWords = renderOptions.maxNumberOfWordsToDraw >= 0 ? renderOptions.maxNumberOfWordsToDraw
				: words.size();
		for (int i = 0; i < maxNumberOfWords; i++) {

			Word word = words.get(i);
			EngineWord eWord = new EngineWord(word, i, words.size(),
					bbTreeBuilder);

			PFont wordFont = word.getFont(fonter);
			float wordSize = word.getSize(sizer, i, words.size());
			float wordAngle = eWord.getAngle(angler);

			Shape shape = WordShaper.getShapeFor(eWord.word.word, wordFont,
					wordSize, wordAngle, 1, 1, renderOptions.minShapeSize);
			if (shape == null) {
				skipWord(word, WordCram.SHAPE_WAS_TOO_SMALL);
			} else {
				eWord.setShape(shape, renderOptions.wordPadding);
				engineWords.add(eWord); // DON'T add eWords with no shape.
			}
		}

		for (int i = maxNumberOfWords; i < words.size(); i++) {
			skipWord(words.get(i), WordCram.WAS_OVER_MAX_NUMBER_OF_WORDS);
		}

		return engineWords.toArray(new EngineWord[0]);
	}

	private void skipWord(Word word, int reason) {
		// TODO delete these properties when starting a sketch, in case it's a
		// re-run w/ the same words.
		// NOTE: keep these as properties, because they (will be) deleted when
		// the WordCramEngine re-runs.
		word.wasSkippedBecause(reason);
	}

	boolean hasMore() {
		return eWordIndex < eWords.length - 1;
	}

	void drawAll() {
		while (hasMore()) {
			drawNext();
		}
	}

	void drawNext() {
		if (!hasMore())
			return;

		EngineWord eWord = eWords[++eWordIndex];

		boolean wasPlaced = placeWord(eWord);
		if (wasPlaced) { // TODO unit test (somehow)
			drawWordImage(eWord);
		}
	}

	private boolean placeWord(EngineWord eWord) {
		Word word = eWord.word;
		Rectangle2D rect = eWord.getShape().getBounds2D(); // TODO can we move
															// these into
															// EngineWord.setDesiredLocation?
															// Does that make
															// sense?
		int wordImageWidth = (int) rect.getWidth();
		int wordImageHeight = (int) rect.getHeight();

		PlaceInfo info = eWord.setDesiredLocation(placer, eWords.length,
				wordImageWidth, wordImageHeight, destination.width,
				destination.height);

		// Set maximum number of placement trials
		int maxAttemptsToPlace = renderOptions.maxAttemptsToPlaceWord > 0 ? renderOptions.maxAttemptsToPlaceWord
				: calculateMaxAttemptsFromWordWeight(word);

		EngineWord lastCollidedWith = null;
		outer: for (int attempt = 0; attempt < maxAttemptsToPlace; attempt++) {

			eWord.nudge(nudger.nudgeFor(word, eWord.getCurrentLocation(),
					attempt));
			float angle = angler.angleFor(eWord);
			// // TODO
			eWord.getTree().setRotation(angle);

			if (eWord.trespassed(img))
				continue;
			PlaceInfo loc = eWord.getCurrentLocation();
			if (loc.getpVector().x < 0
					|| loc.getpVector().y < 0
					|| loc.getpVector().x + wordImageWidth >= destination.width
					|| loc.getpVector().y + wordImageHeight >= destination.height) {
				continue;
			}

			if (lastCollidedWith != null && eWord.overlaps(lastCollidedWith)) {
				Rectangle rectt = eWord.getShape().getBounds();
				continue;
			}

			boolean foundOverlap = false;
			for (int i = 0; !foundOverlap && i < eWordIndex; i++) {
				EngineWord otherWord = eWords[i];
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

		skipWord(eWord.word, WordCram.NO_SPACE);
		placer.fail(info.getReturnedObj());
		return false;
	}

	private int calculateMaxAttemptsFromWordWeight(Word word) {
		return (int) ((1.0 - word.weight) * 600) + 100;
	}

	private void drawWordImage(EngineWord word) {
		GeneralPath path2d = new GeneralPath(word.getShape());

		// Graphics2D g2 = (Graphics2D)destination.image.getGraphics();
		Graphics2D g2 = ((PGraphicsJava2D) destination).g2;

		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
				RenderingHints.VALUE_ANTIALIAS_ON);
		g2.setPaint(new Color(word.word.getColor(colorer), true));
		g2.fill(path2d);
	}

	Word getWordAt(float x, float y) {
		for (int i = 0; i < eWords.length; i++) {
			if (eWords[i].wasPlaced()) {
				Shape shape = eWords[i].getShape();
				if (shape.contains(x, y)) {
					return eWords[i].word;
				}
			}
		}
		return null;
	}

	Word[] getSkippedWords() {
		ArrayList<Word> skippedWords = new ArrayList<Word>();
		for (int i = 0; i < words.size(); i++) {
			if (words.get(i).wasSkipped()) {
				skippedWords.add(words.get(i));
			}
		}
		return skippedWords.toArray(new Word[0]);
	}

	float getProgress() {
		return (float) this.eWordIndex / this.eWords.length;
	}

}
