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

import processing.core.PVector;
import wordcram.WordPlacer.PlaceInfo;

/**
 * A WordPlacer tells WordCram where to place a word (in x,y coordinates) on the
 * field.
 * <p>
 * A WordPlacer only suggests: the WordCram will try to place the Word where the
 * WordPlacer tells it to, but if the Word overlaps other Words, a WordNudger
 * will suggest different near-by spots for the Word until it fits, or until the
 * WordCram gives up.
 * <p>
 * Some useful implementations are available in {@link Placers}.
 * 
 * @author Dan Bernier
 */
public abstract class WordPlacer {

	/**
	 * Where should this {@link Word} be drawn on the field?
	 * 
	 * @param word
	 *            The Word to place. A typical WordPlacer might use the Word's
	 *            weight.
	 * @param wordIndex
	 *            The index (rank) of the Word to place. Since this isn't a
	 *            property of the Word, it's passed in as well.
	 * @param wordsCount
	 *            The total number of words. Gives a context to wordIndex:
	 *            "Word {wordIndex} of {wordsCount}".
	 * @param wordImageWidth
	 *            The width of the word image.
	 * @param wordImageHeight
	 *            The height of the word image.
	 * @param fieldWidth
	 *            The width of the field.
	 * @param fieldHeight
	 *            The height of the field.
	 * @return the desired location for a Word on the field, as a 2D PVector.
	 */
	public abstract PlaceInfo place(Word word, int wordIndex, int wordsCount,
			int wordImageWidth, int wordImageHeight, int fieldWidth,
			int fieldHeight);

	public abstract void fail(Object returnedObj);

	public void success(Object returnedObj) {

	}

	public static class PlaceInfo {
		private PVector pVector;
		private Object returnedObj;

		public PlaceInfo(PVector pVector, Object returnedObj) {
			this.setpVector(pVector);
			this.setReturnedObj(returnedObj);
		}

		public PlaceInfo(PVector pVector) {
			this(pVector, null);
		}

		public PlaceInfo(float x, float y, Object returnedObj) {
			this(new PVector(x, y), returnedObj);
		}

		public PlaceInfo(float x, float y) {
			this(new PVector(x, y), null);
		}

		private void setpVector(PVector pVector) {
			this.pVector = pVector;
		}

		public PVector getpVector() {
			return pVector;
		}

		private void setReturnedObj(Object returnedObj) {
			this.returnedObj = returnedObj;
		}

		public Object getReturnedObj() {
			return returnedObj;
		}

		public PlaceInfo get() {
			return new PlaceInfo(this.getpVector().get(), this.getReturnedObj());
		}
	}

}
