/**
 * 
 */
package wordcram;

/**
 * @author settinghead
 * 
 */
public class ShapeConfinedAngler implements WordAngler {
	final TemplateImage img;
	final private WordAngler otherwise;

	public ShapeConfinedAngler(TemplateImage img, WordAngler otherwise) {
		this.img = img;
		this.otherwise = otherwise;
	}

	public float angleFor(EngineWord eWord) {
		if (eWord.getCurrentLocation() == null)
			return otherwise.angleFor(eWord);
		// float angle = (img.getHue(
		// (int) eWord.getCurrentLocation().getpVector().x, (int) eWord
		// .getCurrentLocation().getpVector().y) + BBPolarTree.PI)
		// % BBPolarTree.TWO_PI;
		float angle = (img.getHue(
				(int) eWord.getCurrentLocation().getpVector().x, (int) eWord
						.getCurrentLocation().getpVector().y));
		if (angle == 0)
			return otherwise.angleFor(eWord);
		else
			return angle;
	}
}
