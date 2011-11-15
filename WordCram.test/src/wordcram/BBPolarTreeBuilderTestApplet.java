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
import wordcram.BBPolarTree.BBPolarRootTree;

public class BBPolarTreeBuilderTestApplet {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		Word word = new Word("The quick brown polar fox jumps over the lazy polar wolf.", 15);

		PApplet pApplet = new PApplet();
		PFont wordFont = word.getFont(Fonters.alwaysUse(randomFont(pApplet)));
		float wordAngle = 0;

		EngineWord eWord = new EngineWord(word, 1, 100,
				new BBPolarTreeBuilder());
		Shape textShape = WordShaper.getShapeFor(eWord.word.word, wordFont,
				100, wordAngle, 100, 100, 1);
		BBPolarRootTree treeText = BBPolarTreeBuilder.makeTree(
				new ShapeImageShape(textShape), 0);
		// treeText.setRotation((float) (new Random().nextFloat() * Math.PI *
		// 2));
		treeText.setLocation(600, 200);

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
		treeText.getBottom(true);
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
