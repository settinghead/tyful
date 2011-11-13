package wordcram;

import java.awt.image.BufferedImage;

import processing.core.PVector;
import wordcram.density.DensityPatchIndex;
import wordcram.density.DensityPatchIndex.LeveledPatchMap.PatchQueue.Patch;

public class ShapeConfinedPlacer extends WordPlacer {

	private TemplateImage img;
	private DensityPatchIndex index;

	public ShapeConfinedPlacer(TemplateImage img, DensityPatchIndex index) {
		this.setImg(img);
		this.setIndex(index);
	}

	public PlaceInfo place(Word word, int wordIndex, int wordsCount,
			int wordImageWidth, int wordImageHeight, int fieldWidth,
			int fieldHeight) {
		Patch patch = (Patch) index.findPatchFor(wordImageWidth,
				wordImageHeight);
		if (patch == null)
			return null;
		return new PlaceInfo(patch.getX() + patch.getWidth() / 2, patch.getY()
				+ patch.getHeight() / 2, patch);
	}

	private void setImg(TemplateImage img) {
		this.img = img;
	}

	public TemplateImage getImg() {
		return img;
	}

	public void setIndex(DensityPatchIndex index) {
		this.index = index;
	}

	public DensityPatchIndex getIndex() {
		return index;
	}

	@Override
	public void fail(Object returnedObj) {
		index.unmark((Patch) returnedObj);
	}

	@Override
	public void success(Object returnedObj) {
		// index.add((Patch) returnedObj);
	}

}
