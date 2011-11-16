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

import java.awt.Font;
import java.awt.Shape;
import java.awt.font.FontRenderContext;
import java.awt.font.GlyphVector;
import java.awt.geom.AffineTransform;
import java.awt.geom.Rectangle2D;

import processing.core.PFont;


internal class WordShaper {
	private var frc:FontRenderContext= new FontRenderContext(null, true, true);
	
	function getShapeFor(word:String, font:PFont, fontSize:Number, angle:Number, minShapeSize:int):Shape {

		var shape:Shape= makeShape(word, font, fontSize);
		
		if (isTooSmall(shape, minShapeSize)) {
			return null;		
		}
		
		return moveToOrigin(rotate(shape, angle));
	}

	private function makeShape(word:String, pFont:PFont, fontSize:Number):Shape {
		var font:Font= pFont.getFont().deriveFont(fontSize);
		
		var chars:Array= word.toCharArray();
		
		// TODO hmm: this doesn't render newlines.  Hrm.  If you're word text is "foo\nbar", you get "foobar".
		var gv:GlyphVector= font.layoutGlyphVector(frc, chars, 0, chars.length,
				Font.LAYOUT_LEFT_TO_RIGHT);

		return gv.getOutline();
	}
	
	private function isTooSmall(shape:Shape, minShapeSize:int):Boolean {
		var r:Rectangle2D= shape.getBounds2D();
		
		// Most words will be wider than tall, so this basically boils down to height.
		// For the odd word like "I", we check width, too.
		return r.getHeight() < minShapeSize || r.getWidth() < minShapeSize;
	}
	
	private function rotate(shape:Shape, rotation:Number):Shape {
		if (rotation == 0) {
			return shape;
		}

		return AffineTransform.getRotateInstance(rotation).createTransformedShape(shape);
	}

	private function moveToOrigin(shape:Shape):Shape {
		var rect:Rectangle2D= shape.getBounds2D();
		
		if (rect.getX() == 0&& rect.getY() == 0) {
			return shape;
		}
		
		return AffineTransform.getTranslateInstance(-rect.getX(), -rect.getY()).createTransformedShape(shape);
	}
}
}