package wordcram.fonters;

import java.awt.Font;
import java.awt.FontFormatException;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import processing.core.PApplet;
import processing.core.PFont;
import wordcram.Word;
import wordcram.WordFonter;

public class VeloFonter implements WordFonter {
	static PFont small, large;

	static {
		PApplet applet = new PApplet();
//		try {
//			small = new PFont(Font.createFont(Font.TRUETYPE_FONT,
//					VeloFonter.class.getResourceAsStream("communist.ttf")),
//					true);
//		} catch (Exception e) {
//			small = new PFont(new Font("serif", Font.PLAIN, 24), true);
//			e.printStackTrace();
//		}
		small = randomFont(applet);

		try {
			large = new PFont(Font.createFont(Font.TRUETYPE_FONT,
					VeloFonter.class.getResourceAsStream("komika-axis.ttf")),
					true);
		} catch (Exception e) {
			large = new PFont(new Font("serif", Font.PLAIN, 24), true);
			e.printStackTrace();
		}
	}

	public PFont fontFor(Word word) {
		if (word.weight > 0.9)
			return large;
		else
			return small;
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
