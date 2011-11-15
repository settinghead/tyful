/**
 * 
 */
package example;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;

import processing.core.PApplet;
import processing.core.PFont;

import wordcram.Anglers;
import wordcram.Colorers;
import wordcram.ShapeConfinedAngler;
import wordcram.ShapeConfinedPlacer;
import wordcram.ShapeConfinedWordNudger;
import wordcram.Sizers;
import wordcram.TemplateImage;
import wordcram.WordAngler;
import wordcram.WordCramImage;
import wordcram.density.DensityPatchIndex;

/**
 * @author settinghead
 * 
 */
public class ContinuousGeneration {
	public static void main(String[] args) throws IOException {

		String fileName;
		if (args.length == 0)
			fileName = "out.png";
		else
			fileName = args[0];

		TemplateImage img = new TemplateImage(
				ImageIO.read(new File("wheel.png")));
		// BufferedImage img = ImageIO.read(new File("half.jpg"));
		while (true) {
			WordCramImage wordCram = new WordCramImage(img.getWidth(),
					img.getHeight());

			WordAngler angler = new ShapeConfinedAngler(img, Anglers.horiz());

			wordCram
			// .withCustomCanvas(pg)
			.fromTextString(
					FileUtils.readFileToString(new File("franklin.txt")))
					// .fromWords(alphabet())
					// .upperCase()
					// .excludeNumbers()
					// .withColorer(Colorers.complement(this, new
					// Random().nextInt(255), 200, 220))
					.withAngler(angler)
					// .withPlacer(Placers.horizLine())
					.withPlacer(
					// new PlottingWordPlacer(wordCram.getApplet(),
							new ShapeConfinedPlacer(img, new DensityPatchIndex(
									img)))
					// )
					.withSizer(Sizers.byWeight(5, 150))
					.withWordPadding(2)

					// .minShapeSize(0)
					// .withMaxAttemptsForPlacement(10)
					// .maxNumberOfWordsToDraw(500)

					.withNudger(new ShapeConfinedWordNudger())
					.withConfinementImage(img)

			;
			// wordCram.withNudger(new PlottingWordNudger(wordCram.getApplet(),
			// new SpiralWordNudger()));

			wordCram.withColorer(Colorers.twoHuesRandomSats(wordCram
					.getApplet()));
			wordCram.withFonts(randomFont(wordCram.getApplet()));

			wordCram.drawAll();
			//String path = "out/" + UUID.randomUUID().toString() + ".png";
			//wordCram.saveToFile(path);

			// wordCram.saveToFile(fileName);
		}
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
