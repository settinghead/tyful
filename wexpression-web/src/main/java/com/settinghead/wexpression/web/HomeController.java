/*
 * Copyright 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.settinghead.wexpression.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Scanner;
import java.util.Set;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.inject.Inject;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.facebook.api.Comment;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.Post;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.settinghead.wexpression.data.FacebookPosts;

import processing.core.PApplet;
import processing.core.PFont;
import wordcram.Anglers;
import wordcram.Colorers;
import wordcram.Placers;
import wordcram.PlottingWordNudger;
import wordcram.ShapeConfinedAngler;
import wordcram.ShapeConfinedPlacer;
import wordcram.ShapeConfinedWordNudger;
import wordcram.Sizers;
import wordcram.SpiralWordNudger;
import wordcram.TemplateImage;
import wordcram.Word;
import wordcram.WordAngler;
import wordcram.WordCramImage;
import wordcram.density.DensityPatchIndex;

/**
 * Simple little @Controller that invokes Facebook and renders the result. The
 * injected {@link Facebook} reference is configured with the required
 * authorization credentials for the current user behind the scenes.
 * 
 * @author Keith Donald
 */
@Controller
public class HomeController {

	private final Facebook facebook;
	static String extraStopWords = "";
	private FacebookPosts fbPosts;
	private ConnectionRepository connectionRepository;
	private WordCramImage wordCram;

	@Inject
	public void setFbPosts(FacebookPosts fbPosts) {
		this.fbPosts = fbPosts;
	}

	@Autowired
	public void setWordCram(WordCramImage wordCram) {
		this.wordCram = wordCram;
	}

	static {
		try {
			// TODO: change
			extraStopWords = new Scanner(
					new File(
							"/Users/settinghead/wexpression/wexpression-web/"
									+ "src/main/java/com/settinghead/wexpression/web/stopwords.txt"))
					.useDelimiter("\\Z").next().replace("\r\n", " ")
					.replace('\n', ' ').replace('\r', ' ');
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@Inject
	public HomeController(Facebook facebook, FacebookPosts fbPosts,
			ConnectionRepository connectionRepository, WordCramImage wordCram)
			throws IOException {
		this.facebook = facebook;
		this.setFbPosts(fbPosts);

		// if (wordCram == null)
		// wordCram = new WordCramImage(img.getWidth(), img.getHeight());
		this.setWordCram(wordCram);

		this.connectionRepository = connectionRepository;
	}

	public String avoidNull(String s) {
		return s == null ? "" : s;
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model, HttpServletResponse response)
			throws IOException {
		String userId = facebook.userOperations().getUserProfile().getId();
		System.out.println("Current user ID: " + userId);
		List<Post> posts = fbPosts.getPosts(userId, 200, facebook);
		// System.out.println(posts.get(0).getMessage());
		// List<Reference> friends = facebook.friendOperations().getFriends();
		model.addAttribute("posts", posts);
		StringBuilder sb = new StringBuilder();
		for (Post post : posts) {
			if (post.getFrom().getId().equals(userId)) {

				// System.out.println(post.getType() + ": msg: "
				// + post.getMessage() + "; name: " + post.getName()
				// + "; desc: " + post.getDescription() + "; caption: "
				// + post.getCaption());

				switch (post.getType()) {
				case VIDEO:
					sb.append(avoidNull(post.getName())).append(". ")
							.append(avoidNull(post.getMessage())).append(". ");
					break;
				default:
					sb.append(avoidNull(post.getDescription())).append(". ")
							.append(avoidNull(post.getMessage())).append(". ")
					// .append(avoidNull(post.getCaption())).append(". ")
					// .append(avoidNull(post.getName())).append(". ")
					;
					break;

				}
			}

			if (post.getComments() != null)
				for (Comment comment : post.getComments()) {
					if (comment.getFrom().getId().equals(userId))
						sb.append(comment.getMessage()).append(". ");
				}
		}

		wordCram.reset();
		TemplateImage img = new TemplateImage(ImageIO.read(new File(
				"/Users/settinghead/wexpression/WordCram/wheel.jpg")));
		// wordCram.withConfinementImage(img);
		wordCram

		// .withCustomCanvas(pg)
		.fromTextString(sb.toString())
		// .fromWords(alphabet())
		// .upperCase()
		// .excludeNumbers()
		// .withColorer(Colorers.complement(this, new
		// Random().nextInt(255), 200, 220))
				.withStopWords(extraStopWords).withAngler(Anglers.heaped())
		// .withPlacer(Placers.horizLine())
		// .withPlacer(Placers.centerClump())
		// .withSizer(Sizers.byWeight(5, 70)).withWordPadding(2)

		// .minShapeSize(0)
		// .withMaxAttemptsForPlacement(10)
		// .maxNumberOfWordsToDraw(500)

		// .withNudger(new RandomWordNudger())

		;
		wordCram.addWord(new Word(facebook.userOperations().getUserProfile()
				.getFirstName(), 200));
		WordAngler angler = new ShapeConfinedAngler(img, Anglers.horiz());
		wordCram
		// .withCustomCanvas(pg)
		// .fromWords(alphabet())
		// .upperCase()
		// .excludeNumbers()
		// .withColorer(Colorers.complement(this, new
		// Random().nextInt(255), 200, 220))
		.withAngler(angler)
				// .withPlacer(Placers.horizLine())
				.withPlacer(
				// new PlottingWordPlacer(wordCram.getApplet(),
						new ShapeConfinedPlacer(img, new DensityPatchIndex(img)))
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

		wordCram.withColorer(Colorers.twoHuesRandomSats(wordCram.getApplet()));
		wordCram.withFonts(randomFont(wordCram.getApplet()));

		wordCram.drawAll();
		String path = UUID.randomUUID().toString() + ".png";
		wordCram.saveToFile(path);
		model.addAttribute("imgPath", path);

		response.setContentType("image/png");

		File file = new File(path);
		FileInputStream fileIn = new FileInputStream(file);
		ServletOutputStream out = response.getOutputStream();

		byte[] outputByte = new byte[4096];
		// copy binary contect to output stream
		while (fileIn.read(outputByte, 0, 4096) != -1) {
			out.write(outputByte, 0, 4096);
		}
		fileIn.close();
		out.flush();
		out.close();

		file.delete();

		return "home";
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