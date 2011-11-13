/**
 * 
 */
package wordcram;

import java.awt.Shape;
import java.awt.geom.Rectangle2D;

/**
 * @author settinghead
 * 
 */
public class ShapeImageShape implements ImageShape {

	/*
	 * (non-Javadoc)
	 * 
	 * @see wordcram.ImageShape#contains(float, float, float, float)
	 */

	private Shape shape;

	public ShapeImageShape(Shape shape) {
		this.shape = shape;
	}

	public boolean contains(float x, float y, float width, float height) {
		return this.shape.contains(x, y, width, height);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see wordcram.ImageShape#intersects(float, float, float, float)
	 */
	public boolean intersects(float x, float y, float width, float height) {
		return this.shape.intersects(x, y, width, height);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see wordcram.ImageShape#getBounds2D()
	 */
	public Rectangle2D getBounds2D() {
		return this.shape.getBounds2D();
	}

}
