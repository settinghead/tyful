/**
 * 
 */
package wordcram;

import java.awt.Color;
import java.awt.Rectangle;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.awt.image.Raster;
import java.awt.image.renderable.ParameterBlock;

/**
 * @author settinghead
 * 
 */
public class TemplateImage implements ImageShape {
	public BufferedImage img;
	final float[][][] HSB;
	Raster data;
	BBPolarTree tree;
	private Rectangle2D _bounds = null;
	private static final double SAMPLE_DISTANCE = 25;
	private static final double MISS_PERCENTAGE_THRESHOLD = 0.1;

	// Applet applet = new Applet();
	// Frame frame = new Frame("Roseindia.net");

	public TemplateImage(BufferedImage img) {
		this.img = img;
		// data = this.img.getRaster();
		this.HSB = new float[img.getWidth()][img.getHeight()][3];
		for (int i = 0; i < img.getWidth(); i++)
			for (int j = 0; j < img.getHeight(); j++) {

				int pixel = img.getRGB(i, j);
				int alpha = (pixel >> 24) & 0xff;
				int red = (pixel >> 16) & 0xff;
				int green = (pixel >> 8) & 0xff;
				int blue = (pixel) & 0xff;

				float[] hsb = Color.RGBtoHSB(red, green, blue, null);
				this.HSB[i][j] = hsb;
			}
		// tree = BBPolarTreeBuilder.makeTree(this, 0);
		//
		// frame.setSize(1400, 1400);
		// frame.add(applet);
		// frame.setVisible(true);
		// tree.draw(applet.getGraphics());

	}

	public float getBrightness(int x, int y) {
		if (x < 0 || x >= img.getWidth() || y < 0 || y >= img.getHeight())
			return 0;
		else
			return HSB[x][y][2];
	}

	public float getHue(int x, int y) {
		if (x < 0 || x >= img.getWidth() || y < 0 || y >= img.getHeight())
			return 0;
		else
			return HSB[x][y][0] * BBPolarTree.TWO_PI;
	}

	public int getHeight() {
		return img.getHeight();
	}

	public int getWidth() {
		return img.getWidth();
	}

	public Rectangle2D getBounds2D() {
		if (this._bounds == null) {
			float centerX = img.getWidth() / 2;
			float centerY = img.getHeight() / 2;
			float radius = (float) Math.sqrt(Math.pow(centerX, 2)
					+ Math.pow(centerY, 2));
			int diameter = (int) (radius * 2);

			this._bounds = new Rectangle((int) (centerX - radius),
					(int) (centerY - radius), diameter, diameter);
		}
		return this._bounds;
	}

	public boolean contains(float x, float y, float width, float height) {
		if (tree == null) {
			// // %1
			// int threshold = (int) (width * height / 1000);
			// int darkCount = 0;
			// for (int i = 0; i < width; i++) {
			// for (int j = 0; j < height; j++) {
			// if (getBrightness((int) (x + i), (int) (y + j)) < 0.01
			// && ++darkCount >= threshold)
			// return false;
			// }
			// }
			// return true;

			// sampling approach
			int numSamples = (int) (width * height / SAMPLE_DISTANCE);
			// TODO: devise better lower bound
			if (numSamples < 10)
				numSamples = 10;
			int threshold = 5;
			int darkCount = 0;
			int i = 0;
			while (i < numSamples) {
				int relativeX = (int) (Math.random() * width);
				int relativeY = (int) (Math.random() * height);
				int sampleX = (int) (relativeX + x);
				int sampleY = (int) (relativeY + y);
				if (getBrightness((int) (sampleX), (int) (sampleY)) < 0.01
						&& ++darkCount >= threshold)
					return false;
				i++;
			}

			return true;

		} else {
			return tree.contains((float) x, (float) y, (float) (x + width),
					(float) (y + height));
		}
	}

	public boolean intersects(float x, float y, float width, float height) {
		if (tree == null) {
			int threshold = 10;
			int darkCount = 0;
			int brightCount = 0;
			// for (int i = 0; i < width; i++) {
			// for (int j = 0; j < height; j++) {
			// if (getBrightness((int) (x + i), (int) (y + j)) < 0.01)
			// darkCount++;
			// else
			// brightCount++;
			// if (darkCount >= threshold && brightCount >= threshold)
			// return true;
			// }
			// }
			// return false;

			int numSamples = (int) (width * height / SAMPLE_DISTANCE);
			// TODO: devise better lower bound
			if (numSamples < 4)
				numSamples = 4;

			int i = 0;
			while (i < numSamples) {
				int relativeX = (int) (Math.random() * width);
				int relativeY = (int) (Math.random() * height);
				int sampleX = (int) (relativeX + x);
				int sampleY = (int) (relativeY + y);
				if (getBrightness((int) (sampleX), (int) (sampleY)) < 0.01)
					darkCount++;
				else
					brightCount++;
				if (darkCount >= threshold && brightCount >= threshold)
					return true;
				i++;
			}

			return false;
		} else {
			return tree.overlaps(x, y, x + width, y + height);
		}
	}

}
