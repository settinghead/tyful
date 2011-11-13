package wordcram;

import java.applet.Applet;
import java.awt.Frame;
import java.awt.Rectangle;
import java.awt.Shape;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

import processing.core.PApplet;
import processing.core.PFont;

public class BBPolarTreeBuilderTestApplet {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Shape rect1 = new Rectangle(0, 0, 200, 200);
		Shape rect2 = new Rectangle(400, 400, 400, 400);
		Shape rect3 = new Rectangle(100, 100, 400, 400);
		Shape rect4 = new Rectangle(110, 110, 300, 300);
		Shape rect5 = new Rectangle(240, 60, 200, 200);

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

		Word word = new Word("Hello", 100);

		PApplet pApplet = new PApplet();
		PFont wordFont = word.getFont(Fonters.alwaysUse(randomFont(pApplet)));
		float wordAngle = 0;

		EngineWord eWord = new EngineWord(word, 1, 100,
				new BBPolarTreeBuilder());
		Shape textShape = WordShaper.getShapeFor(eWord.word.word, wordFont,
				400, wordAngle, 100, 100, 1);
		BBPolarTree treeText = BBPolarTreeBuilder.makeTree(new ShapeImageShape(
				textShape), 0);
		treeText.setRotation((float) (new Random().nextFloat() * Math.PI * 2));

		Applet applet = new Applet();
		Frame frame = new Frame("Roseindia.net");
		frame.setSize(1400, 1400);
		frame.add(applet);
		frame.setVisible(true);
		// treeRect1.draw(applet.getGraphics());
		// treeRect2.draw(applet.getGraphics());
		// treeRect3.draw(applet.getGraphics());
		// treeRect4.draw(applet.getGraphics());
		// treeRect5.draw(applet.getGraphics());
		treeText.draw(applet.getGraphics());
	}

	private static PFont randomFont(PApplet applet) {
		String[] fonts = PFont.list();
		String noGoodFontNames = "Dingbats|Standard Symbols L";
		String blockFontNames = "OpenSymbol|Mallige Bold|Mallige Normal|Lohit Bengali|Lohit Punjabi|Webdings";
		Set<String> noGoodFonts = new HashSet<String>(
				Arrays.asList((noGoodFontNames + "|" + blockFontNames)
						.split("|")));
		String fontName;
		do {
			fontName = fonts[(int) applet.random(fonts.length)];
		} while (fontName == null || noGoodFonts.contains(fontName));
		System.out.println(fontName);
		return applet.createFont(fontName, 1);
		// return createFont("Molengo", 1);
	}

}
