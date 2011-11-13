package wordcram;

import java.awt.geom.Rectangle2D;

public interface ImageShape {

	boolean contains(float x, float y, float width, float height);

	boolean intersects(float x, float y, float width, float height);

	Rectangle2D getBounds2D();

}
