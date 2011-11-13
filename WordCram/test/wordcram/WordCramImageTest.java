package wordcram;

import static org.junit.Assert.*;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import org.junit.Test;

import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PGraphics;
import processing.core.PGraphics2D;
import processing.core.PGraphicsJava2D;
import processing.core.PImage;

public class WordCramImageTest {

	PApplet applet = new PApplet();

	@Test
	public void testSaveToFile() {
		PGraphics pg = applet.createGraphics(400, 400, PApplet.JAVA2D);
		WordCram img = new WordCram(applet)
				// .withCustomCanvas(pg)
				.fromTextString(
						"the quick brown fox jumps over the lazy dog. fox i say.")
				// .fromWords(alphabet())
				// .upperCase()
				// .excludeNumbers()
				.withFonts(randomFont())
				// .withColorer(Colorers.twoHuesRandomSats(this))
				// .withColorer(Colorers.complement(this, random(255), 200,
				// 220))
				.withAngler(Anglers.mostlyHoriz())
				.withPlacer(Placers.horizLine())
				// .withPlacer(Placers.centerClump())
				.withSizer(Sizers.byWeight(5, 70)).withWordPadding(6)
				.withCustomCanvas(pg)

		// .minShapeSize(0)
		// .withMaxAttemptsForPlacement(10)
		// .maxNumberOfWordsToDraw(500)

		// .withNudger(new PlottingWordNudger(this, new SpiralWordNudger()))
		// .withNudger(new RandomWordNudger())

		;
		img.drawAll();
		pg.save("test.png");
	}

	private PFont randomFont() {
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
