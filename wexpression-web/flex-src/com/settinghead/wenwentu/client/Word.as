package com.settinghead.wenwentu.client {
	import com.settinghead.wenwentu.client.colorer.WordColorer;
	import com.settinghead.wenwentu.client.sizers.WordSizer;
	
	import flash.geom.Point;
	
	import org.as3commons.collections.Map;
	import com.settinghead.wenwentu.client.fonter.WordFonter;
	import com.settinghead.wenwentu.client.placer.WordPlacer;

/*
 Copyright 2010 Daniel Bernier

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


/**
 * A weighted word, for rendering in the word cloud image.
 * <p>
 * Each Word object has a {@link #word} String, and its associated
 * {@link #weight}, and it's constructed with these two things.
 * 
 * 
 * <h3>Hand-crafting Your Words</h3>
 * 
 * If you're creating your own <code>Word[]</code> to pass to the WordCram
 * (rather than using something like {@link WordCram#fromWebPage(String)}), you
 * can specify how a Word should be rendered: set a Word's font, size, etc:
 * 
 * <pre>
 * Word w = new Word(&quot;texty&quot;, 20);
 * w.setFont(createFont(&quot;myFontName&quot;, 1));
 * w.setAngle(radians(45));
 * </pre>
 * 
 * Any values set on a Word will override the corresponding component (
 * {@link WordColorer}, {@link WordAngler}, etc) - it won't even be called for
 * that word.
 * 
 * <h3>Word Properties</h3>
 * A word can also have properties. If you're creating custom components, you
 * might want to send other information along with the word, for the components
 * to use:
 * 
 * <pre>
 * Word strawberry = new Word(&quot;strawberry&quot;, 10);
 * strawberry.setProperty(&quot;isFruit&quot;, true);
 * 
 * Word pea = new Word(&quot;pea&quot;, 10);
 * pea.setProperty(&quot;isFruit&quot;, false);
 * 
 * new WordCram(this).fromWords(new Word[] { strawberry, pea }).withColorer(
 * 		new WordColorer() {
 * 			public int colorFor(Word w) {
 * 				if (w.getProperty(&quot;isFruit&quot;) == true) {
 * 					return color(255, 0, 0);
 * 				} else {
 * 					return color(0, 200, 0);
 * 				}
 * 			}
 * 		});
 * </pre>
 * 
 * @author Dan Bernier
 */
public class Word {

	public var word:String;
	public var weight:Number;

	private var presetSize:Number;
	private var presetFont:String;
	private var presetColor:int;
	private var presetTargetPlace:PlaceInfo;

	// These are null until they're rendered, and can be wiped out for a
	// re-render.
	private var renderedSize:Number = NaN;
	private var renderedFont:String;
	private var renderedColor:int = -1;
	private var targetPlaceInfo:PlaceInfo;
	private var renderedPlace:Point;
	private var skippedBecause:int = -1;

	private var properties:Map = new Map();

	public function Word(word:String, weight:Number) {
		this.word = word;
		if (this.word == ("nyan"))
			this.word = "Xiyang Chen";
		this.weight = weight;
	}

	/**
	 * Set the size this Word should be rendered at - WordCram won't even call
	 * the WordSizer.
	 * 
	 * @return the Word, for more configuration
	 */
	public function setSize(size:Number):Word {
		this.presetSize = size;
		return this;
	}

	/**
	 * Set the font this Word should be rendered in - WordCram won't call the
	 * WordFonter.
	 * 
	 * @return the Word, for more configuration
	 */
	public function setFont(font:String):Word { // TODO provide a string overload? Will
										// need the PApplet...
		this.presetFont = font;
		return this;
	}

	/**
	 * Set the color this Word should be rendered in - WordCram won't call the
	 * WordColorer.
	 * 
	 * @return the Word, for more configuration
	 */
	public function setColor(color:int):Word {
		this.presetColor = color;
		return this;
	}

	/**
	 * Set the place this Word should be rendered at - WordCram won't call the
	 * WordPlacer.
	 * 
	 * @return the Word, for more configuration
	 */
	public function setPlace(place:PlaceInfo):Word {
		this.presetTargetPlace = new PlaceInfo(place.getpVector().clone(),
				place.getReturnedObj());
		return this;
	}


	/*
	 * These methods are called by EngineWord: they return (for instance) either
	 * the color the user set via setColor(), or the value returned by the
	 * WordColorer. They're package-local, so they can't be called by the
	 * sketch.
	 */

	function getSize(sizer:WordSizer, rank:int, wordCount:int):Number {
		renderedSize = !isNaN(presetSize) ? presetSize : sizer.sizeFor(this,
				rank, wordCount);
		return renderedSize;
	}

	function getFont(fonter:WordFonter):String {
		renderedFont = presetFont != null ? presetFont : fonter.fontFor(this);
		return renderedFont;
	}

	function getColor(colorer:WordColorer):int {
		renderedColor = presetColor>=0 ? presetColor : colorer
				.colorFor(this);
		return renderedColor;
	}

	function getTargetPlace(placer:WordPlacer, rank:int, count:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int):PlaceInfo {
		targetPlaceInfo = presetTargetPlace != null ? presetTargetPlace
				: placer.place(this, rank, count, wordImageWidth,
						wordImageHeight, fieldWidth, fieldHeight);
		return targetPlaceInfo;
	}

	function setRenderedPlace(place:Point):void {
		renderedPlace = place.clone();
	}

	/**
	 * Get the size the Word was rendered at: either the value passed to
	 * setSize(), or the value returned from the WordSizer.
	 * 
	 * @return the rendered size
	 */
	public function getRenderedSize():Number {
		return renderedSize;
	}

	/**
	 * Get the font the Word was rendered in: either the value passed to
	 * setFont(), or the value returned from the WordFonter.
	 * 
	 * @return the rendered font
	 */
	public function getRenderedFont():String {
		return renderedFont;
	}

	/**
	 * Get the color the Word was rendered in: either the value passed to
	 * setColor(), or the value returned from the WordColorer.
	 * 
	 * @return the rendered color
	 */
	public function getRenderedColor():int {
		return renderedColor;
	}

	/**
	 * Get the place the Word was supposed to be rendered at: either the value
	 * passed to setPlace(), or the value returned from the WordPlacer.
	 */
	public function getCurrentTargetPlace():PlaceInfo {
		return targetPlaceInfo;
	}

	/**
	 * Get the final place the Word was rendered at, or null if it couldn't be
	 * placed. It returns the original target location (which is either the
	 * value passed to setPlace(), or the value returned from the WordPlacer),
	 * plus the nudge vector returned by the WordNudger.
	 * 
	 * @return If word was placed, it's the (x,y) coordinates of the word's
	 *         final location; else it's null.
	 */
	public function getRenderedPlace():Point {
		return renderedPlace;
	}

	/**
	 * Indicates whether the Word was placed successfully. It's the same as
	 * calling word.getRenderedPlace() != null. If this returns false, it's
	 * either because a) WordCram didn't get to this Word yet, or b) it was
	 * skipped for some reason (see {@link #wasSkipped()} and
	 * {@link #wasSkippedBecause()}).
	 * 
	 * @return true only if the word was placed.
	 */
	public function wasPlaced():Boolean {
		return renderedPlace != null;
	}

	/**
	 * Indicates whether the Word was skipped.
	 * 
	 * @see Word#wasSkippedBecause()
	 * @return true if the word was skipped
	 */
	public function wasSkipped():Boolean {
		return this.getWasSkippedBecause()>=0;
	}

	/**
	 * Tells you why this Word was skipped.
	 * 
	 * If the word was skipped, then this will return an Integer, which will be
	 * one of {@link WordCram#WAS_OVER_MAX_NUMBER_OF_WORDS},
	 * {@link WordCram#SHAPE_WAS_TOO_SMALL}, or {@link WordCram#NO_SPACE}.
	 * 
	 * If the word was successfully placed, or WordCram hasn't gotten to this
	 * word yet, this will return null.
	 * 
	 * @return the code for the reason the word was skipped, or null if it
	 *         wasn't skipped.
	 */
	public function getWasSkippedBecause():int {
		return skippedBecause;
	}

	function wasSkippedBecause(reason:int):void {
		skippedBecause = reason;
	}

	/**
	 * Get a property value from this Word, for a WordColorer, a WordPlacer,
	 * etc.
	 * 
	 * @param propertyName
	 * @return the value of the property, or <code>null</code>, if it's not
	 *         there.
	 */
	public function getProperty(propertyName:String):Object {
		return properties.itemFor(propertyName);
	}

	/**
	 * Set a property on this Word, to be used by a WordColorer, a WordPlacer,
	 * etc, down the line.
	 * 
	 * @param propertyName
	 * @param propertyValue
	 * @return the Word, for more configuration
	 */
	public function setProperty(propertyName:String, propertyValue:Object):Word {
		properties.add(propertyName, propertyValue);
		return this;
	}

	
	public function getWeight():Number{
		return this.weight;
	}
}
}