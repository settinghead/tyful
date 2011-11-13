package wordcram;

import static org.junit.Assert.*;

import java.applet.Applet;
import java.awt.Frame;
import java.awt.Rectangle;
import java.awt.Shape;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class BBPolarTreeBuilderTest {

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testMakeTree() {

		Shape rect1 = new Rectangle(0, 0, 100, 100);
		Shape rect2 = new Rectangle(200, 200, 100, 100);
		Shape rect3 = new Rectangle(50, 50, 200, 200);
		Shape rect4 = new Rectangle(55, 55, 150, 150);
		Shape rect5 = new Rectangle(103, 30, 100, 100);
		Shape rect6 = new Rectangle(10, 103, 100, 100);
		
		BBPolarTree treeRect1 = BBPolarTreeBuilder.makeTree(
				new ShapeImageShape(rect1), 0);
		BBPolarTree treeRect2 = BBPolarTreeBuilder.makeTree(
				new ShapeImageShape(rect2), 0);
		BBPolarTree treeRect3 = BBPolarTreeBuilder.makeTree(
				new ShapeImageShape(rect3), 0);
		BBPolarTree treeRect4 = BBPolarTreeBuilder.makeTree(
				new ShapeImageShape(rect4), 0);
		BBPolarTree treeRect5 = BBPolarTreeBuilder.makeTree(
				new ShapeImageShape(rect5), 0);
		BBPolarTree treeRect6 = BBPolarTreeBuilder.makeTree(
				new ShapeImageShape(rect6), 0);
//
//		Applet applet = new Applet();
//		Frame frame = new Frame("Roseindia.net");
//		frame.setSize(400, 200);
//		frame.add(applet);
//		frame.setVisible(true);
//		treeRect1.draw(applet.getGraphics());

		assertTrue(treeRect1.overlaps(treeRect3));
		assertTrue(treeRect2.overlaps(treeRect3));
		assertFalse(treeRect1.overlaps(treeRect2));
		assertFalse(treeRect2.overlaps(treeRect1));
		assertTrue(treeRect3.overlaps(treeRect4));
		assertTrue(treeRect4.overlaps(treeRect3));
		assertFalse(treeRect5.overlaps(treeRect1));
		assertFalse(treeRect6.overlaps(treeRect1));

	}

}
