package wordcram {
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

import java.util.HashMap;

import processing.core.PFont;
import processing.core.PVector;

/**
 * A weighted word, for rendering in the word cloud image.
 * <p>
 * Each Word object has a {@link #word} String, and its associated {@link #weight}, and it's constructed
 * with these two things.
 * 
 * 
 * <h3>Hand-crafting Your Words</h3>
 * 
 * If you're creating your own <code>Word[]</code> to pass
 * to the WordCram (rather than using something like {@link WordCram#fromWebPage(String)}),
 * you can specify how a Word should be rendered: set a Word's font, size, etc:
 * 
 * <pre>
 * Word w = new Word("texty", 20);
 * w.setFont(createFont("myFontName", 1));
 * w.setAngle(radians(45));
 * </pre>
 * 
 * Any values set on a Word will override the corresponding component ({@link WordColorer}, 
 * {@link WordAngler}, etc) - it won't even be called for that word.
 * 
 * <h3>Word Properties</h3>
 * A word can also have properties. If you're creating custom components,
 * you might want to send other information along with the word, for the components to use:
 * 
 * <pre>
 * Word strawberry = new Word("strawberry", 10);
 * strawberry.setProperty("isFruit", true);
 * 
 * Word pea = new Word("pea", 10);
 * pea.setProperty("isFruit", false);
 * 
 * new WordCram(this)
 *   .fromWords(new Word[] { strawberry, pea })
 *   .withColorer(new WordColorer() {
 *      public int colorFor(Word w) {
 *        if (w.getProperty("isFruit") == true) {
 *          return color(255, 0, 0);
 *        }
 *        else {
 *          return color(0, 200, 0);
 *        }
 *      }
 *    });
 * </pre>
 * 
 * @author Dan Bernier
 */
public class Word implements Comparable<Word> {
	
	public var word:String;
	public var weight:Number;

	private var presetSize:Float;
	private var presetAngle:Float;
	private var presetFont:PFont;
	private var presetColor:int;
	private var presetTargetPlace:PVector;
	
	// These are null until they're rendered, and can be wiped out for a re-render.
	private var renderedSize:Float;
	private var renderedAngle:Float;
	private var renderedFont:PFont;
	private var renderedColor:int;
	private var targetPlace:PVector;
	private var renderedPlace:PVector;
	private var skippedBecause:int;
	
	private HashMap<String,Object> properties = new HashMap<String,Object>();
	
	public function Word(word:String, weight:Number) {
		this.word = word;
		this.weight = weight;
	}
	
	/**
	 * Set the size this Word should be rendered at - WordCram won't even call the WordSizer.
	 * @return the Word, for more configuration
	 */
	public function setSize(size:Number):Word {
		this.presetSize = size;
		return this;
	}
	
	/**
	 * Set the angle this Word should be rendered at - WordCram won't even call the WordAngler.
	 * @return the Word, for more configuration
	 */
	public function setAngle(angle:Number):Word {
		this.presetAngle = angle;
		return this;
	}
	
	/**
	 * Set the font this Word should be rendered in - WordCram won't call the WordFonter.
	 * @return the Word, for more configuration
	 */
	public function setFont(font:PFont):Word {  // TODO provide a string overload? Will need the PApplet...
		this.presetFont = font;
		return this;
	}
	
	/**
	 * Set the color this Word should be rendered in - WordCram won't call the WordColorer.
	 * @return the Word, for more configuration
	 */
	public function setColor(color:int):Word {
		this.presetColor = color;
		return this;
	}
	
	/**
	 * Set the place this Word should be rendered at - WordCram won't call the WordPlacer.
	 * @return the Word, for more configuration
	 */
	public function setPlace(place:PVector):Word {
		this.presetTargetPlace = place.get();
		return this;
	}
	
	/**
	 * Set the place this Word should be rendered at - WordCram won't call the WordPlacer.
	 * @return the Word, for more configuration
	 */
	public function setPlace(x:Number, y:Number):Word {
		this.presetTargetPlace = new PVector(x, y);
		return this;
	}

	/*
	 * These methods are called by EngineWord: they return (for instance)
	 * either the color the user set via setColor(), or the value returned
	 * by the WordColorer. They're package-local, so they can't be called by the sketch.
	 */
	
	function getSize(sizer:WordSizer, rank:int, wordCount:int):Float {
		renderedSize = presetSize != null ? presetSize : sizer.sizeFor(this, rank, wordCount);
		return renderedSize;
	}
	
	function getAngle(angler:WordAngler):Float {
		renderedAngle = presetAngle != null ? presetAngle : angler.angleFor(this);
		return renderedAngle;
	}
	
	function getFont(fonter:WordFonter):PFont {
		renderedFont = presetFont != null ? presetFont : fonter.fontFor(this);
		return renderedFont;
	}
	
	function getColor(colorer:WordColorer):int {
		renderedColor = presetColor != null ? presetColor : colorer.colorFor(this);
		return renderedColor;
	}
	
	function getTargetPlace(placer:WordPlacer, rank:int, count:int, wordImageWidth:int, wordImageHeight:int, fieldWidth:int, fieldHeight:int):PVector {
		targetPlace = presetTargetPlace != null ? presetTargetPlace : placer.place(this, rank, count, wordImageWidth, wordImageHeight, fieldWidth, fieldHeight);
		return targetPlace;
	}
	
	function setRenderedPlace(place:PVector):void {
		renderedPlace = place.get();
	}

	/**
	 * Get the size the Word was rendered at: either the value passed to setSize(), or the value returned from the WordSizer. 
	 * @return the rendered size
	 */
	public function getRenderedSize():Number {
		return renderedSize;
	}

	/**
	 * Get the angle the Word was rendered at: either the value passed to setAngle(), or the value returned from the WordAngler. 
	 * @return the rendered angle
	 */
	public function getRenderedAngle():Number {
		return renderedAngle;
	}

	/**
	 * Get the font the Word was rendered in: either the value passed to setFont(), or the value returned from the WordFonter. 
	 * @return the rendered font
	 */
	public function getRenderedFont():PFont {
		return renderedFont;
	}

	/**
	 * Get the color the Word was rendered in: either the value passed to setColor(), or the value returned from the WordColorer. 
	 * @return the rendered color
	 */
	public function getRenderedColor():int {
		return renderedColor;
	}

	/**
	 * Get the place the Word was supposed to be rendered at: either the value passed to setPlace(), 
	 * or the value returned from the WordPlacer.
	 */
	public function getTargetPlace():PVector {
		return targetPlace;
	}

	/**
	 * Get the final place the Word was rendered at, or null if it couldn't be placed.
	 * It returns the original target location (which is either the value passed to setPlace(), 
	 * or the value returned from the WordPlacer), plus the nudge vector returned by the WordNudger.
	 * @return If word was placed, it's the (x,y) coordinates of the word's final location; else it's null.
	 */
	public function getRenderedPlace():PVector {
		return renderedPlace;
	}
	
	/**
	 * Indicates whether the Word was placed successfully. It's the same as calling word.getRenderedPlace() != null.
	 * If this returns false, it's either because a) WordCram didn't get to this Word yet,
	 * or b) it was skipped for some reason (see {@link #wasSkipped()} and {@link #wasSkippedBecause()}).
	 * @return true only if the word was placed.
	 */
	public function wasPlaced():Boolean {
		return renderedPlace != null;
	}
	
	/**
	 * Indicates whether the Word was skipped.
	 * @see Word#wasSkippedBecause()
	 * @return true if the word was skipped
	 */
	public function wasSkipped():Boolean {
		return wasSkippedBecause() != null;
	}
	
	/**
	 * Tells you why this Word was skipped.
	 * 
	 * If the word was skipped, 
	 * then this will return an Integer, which will be one of 
	 * {@link WordCram#WAS_OVER_MAX_NUMBER_OF_WORDS}, {@link WordCram#SHAPE_WAS_TOO_SMALL}, 
	 * or {@link WordCram#NO_SPACE}.
	 * 
	 * If the word was successfully placed, or WordCram hasn't
	 * gotten to this word yet, this will return null.
	 * 
	 * @return the code for the reason the word was skipped, or null if it wasn't skipped.  
	 */
	public function wasSkippedBecause():int {
		return skippedBecause;
	}
	
	function wasSkippedBecause(reason:int):void {
		skippedBecause = reason;
	}

	/**
	 * Get a property value from this Word, for a WordColorer, a WordPlacer, etc.
	 * @param propertyName
	 * @return the value of the property, or <code>null</code>, if it's not there.
	 */
	public function getProperty(propertyName:String):Object {
		return properties.get(propertyName);
	}
	
	/**
	 * Set a property on this Word, to be used by a WordColorer, a WordPlacer, etc, down the line.
	 * @param propertyName
	 * @param propertyValue
	 * @return the Word, for more configuration
	 */
	public function setProperty(propertyName:String, propertyValue:Object):Word {
		properties.put(propertyName, propertyValue);
		return this;
	}
	
	/**
	 * Displays the word, and its weight (in parentheses).
	 * <code>new Word("hello", 1.3).toString()</code> will return "hello (0.3)".
	 */
	
override public function toString():String {
		var status:String= "";
		if (wasPlaced()) {
			status = renderedPlace.x + "," + renderedPlace.y;
		}
		else if (wasSkipped()) {
			switch (wasSkippedBecause()) {
			case WordCram.WAS_OVER_MAX_NUMBER_OF_WORDS:
				status = "was over the maximum number of words";
				break;
			case WordCram.SHAPE_WAS_TOO_SMALL:
				status = "shape was too small";
				break;
			case WordCram.NO_SPACE:
				status = "couldn't find a spot";
				break;
			}
		}
		if (status.length() != 0) {
			status = " [" + status + "]";
		}
		return word + " (" + weight + ")" + status;
	}
	
	/**
	 * Compares Words based on weight only. Words with equal weight are arbitrarily sorted.
	 */
	public function compareTo(w:Word):int {
		if (w.weight < weight) {
			return -1;
		}
		else if (w.weight > weight) {
			return 1;
		}
		else return 0;
	}
}
}