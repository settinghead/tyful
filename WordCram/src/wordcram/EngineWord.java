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

import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.AffineTransform;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;

import processing.core.PVector;
import wordcram.WordPlacer.PlaceInfo;
import wordcram.density.DensityPatchIndex;

class EngineWord {
	Word word;
	int rank;

	private Shape shape;
	private BBPolarTreeBuilder bbTreeBuilder;
	private BBPolarTree bbTree;
	private Float presetAngle;
	Float renderedAngle;

	private PlaceInfo desiredLocation;
	private PlaceInfo currentLocation;

	EngineWord(Word word, int rank, int wordCount,
			BBPolarTreeBuilder bbTreeBuilder) {
		this.word = word;
		this.rank = rank;
		this.bbTreeBuilder = bbTreeBuilder;
	}

	void setShape(Shape shape, int swelling) {
		this.shape = shape;

		this.bbTree = BBPolarTreeBuilder.makeTree(new ShapeImageShape(shape),
				swelling);
	}

	Shape getShape() {
		return shape;
	}

	boolean overlaps(EngineWord other) {
		return bbTree.overlaps(other.bbTree);
	}

	PlaceInfo setDesiredLocation(WordPlacer placer, int count,
			int wordImageWidth, int wordImageHeight, int fieldWidth,
			int fieldHeight) {
		desiredLocation = word.getTargetPlace(placer, rank, count,
				wordImageWidth, wordImageHeight, fieldWidth, fieldHeight);
		currentLocation = desiredLocation != null ? desiredLocation.get()
				: null;
		return currentLocation;
	}

	void nudge(PVector nudge) {
		currentLocation = new PlaceInfo(PVector.add(
				desiredLocation.getpVector(), nudge),
				currentLocation.getReturnedObj());
		bbTree.setLocation((int) currentLocation.getpVector().x,
				(int) currentLocation.getpVector().y);
	}

	void finalizeLocation() {
		Rectangle bounds = shape.getBounds();

		double x = currentLocation.getpVector().x - bounds.getWidth() / 2;
		double y = currentLocation.getpVector().y - bounds.getHeight() / 2;
		shape =
		// WordShaper.moveToOrigin(
		WordShaper.rotate(shape, -getTree().getRotation(),
				(float) bounds.getWidth() / 2, (float) bounds.getHeight() / 2
		// )
				);
		AffineTransform transform = AffineTransform.getTranslateInstance(
		// = AffineTransform.getRotateInstance(
		// bbTree.getRotation(),
		// currentLocation.getpVector().x - bounds.getWidth() / 2,
		// currentLocation.getpVector().y - bounds.getHeight() / 2);
				x, y);
		shape = transform.createTransformedShape(shape);

		// bbTree.setLocation((int) currentLocation.getpVector().x,
		// (int) currentLocation.getpVector().y);
		word.setRenderedPlace(currentLocation.getpVector());
	}

	PlaceInfo getCurrentLocation() {
		if (currentLocation != null)
			return new PlaceInfo(currentLocation.getpVector().get(),
					currentLocation.getReturnedObj());
		else
			return null;
	}

	boolean wasPlaced() {
		return word.wasPlaced();
	}

	public boolean trespassed(TemplateImage img) {
		Rectangle2D bounds = shape.getBounds2D();
		float x = (float) (this.currentLocation.getpVector().x - bounds
				.getWidth() / 2);
		float y = (float) (this.currentLocation.getpVector().y - bounds
				.getHeight() / 2);
		// float right = (float) (this.currentLocation.getpVector().x + bounds
		// .getWidth());
		// float bottom = (float) (this.currentLocation.getpVector().y + bounds
		// .getHeight());
		return !img.contains(x, y, (float) bounds.getWidth(),
				(float) bounds.getHeight());
	}

	public BBPolarTree getTree() {
		return this.bbTree;
	}

	Float getAngle(WordAngler angler) {
		renderedAngle = presetAngle != null ? presetAngle : angler
				.angleFor(this);
		return renderedAngle;
	}

	/**
	 * Set the angle this Word should be rendered at - WordCram won't even call
	 * the WordAngler.
	 * 
	 * @return the Word, for more configuration
	 */
	public Word setAngle(float angle) {
		this.presetAngle = angle;
		return this.word;
	}

	/**
	 * Get the angle the Word was rendered at: either the value passed to
	 * setAngle(), or the value returned from the WordAngler.
	 * 
	 * @return the rendered angle
	 */
	public float getRenderedAngle() {
		return renderedAngle;
	}
	// private boolean trespassed_old(TemplateImage img) {
	// if (shape != null && currentLocation != null) {
	// Rectangle2D bounds = shape.getBounds2D();
	// if (currentLocation.getpVector().x < 0
	// || currentLocation.getpVector().y < 0
	// || currentLocation.getpVector().x + bounds.getWidth() > img
	// .getWidth()
	// || currentLocation.getpVector().y + bounds.getHeight() > img
	// .getHeight())
	// return true;
	//
	// // sampling approach
	// int numSamples = (int) (bounds.getWidth() * bounds.getHeight() /
	// SAMPLE_DISTANCE);
	// // TODO: devise better lower bound
	// if (numSamples < 4)
	// numSamples = 4;
	// int missed = 0;
	// int thresholdMissedCount = (int) (numSamples *
	// MISS_PERCENTAGE_THRESHOLD);
	// int i = 0;
	// int total = 0;
	// int numSamplesTimesThree = numSamples * 3;
	// while (i < numSamples) {
	// int relativeX = (int) (Math.random() * bounds.getWidth());
	// int relativeY = (int) (Math.random() * bounds.getHeight());
	// int x = (int) (relativeX + currentLocation.getpVector().x);
	// int y = (int) (relativeY + currentLocation.getpVector().y);
	// if (shape.contains(relativeX, relativeY)) {
	// i++;
	// if (img.getBrightness(x, y) < 0.01f
	// && ++missed >= thresholdMissedCount)
	// return true;
	// }
	//
	// }
	// }
	// return false;
	// }
}
