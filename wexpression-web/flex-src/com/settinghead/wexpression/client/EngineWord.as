package com.settinghead.wexpression.client {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.placer.WordPlacer;

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



public class EngineWord {
	var word:Word;
	var rank:int;

	private var shape:TextShape;
	public var bbTree:BBPolarRootTree;
	private var presetAngle:Number = NaN;
	var renderedAngle:Number;

	private var desiredLocation:PlaceInfo;
	private var currentLocation:PlaceInfo;

	public function EngineWord(word:Word, rank:int, wordCount:int) {
		this.word = word;
		this.rank = rank;
	}

	function setShape(shape:TextShape, swelling:int):void {
		this.shape = shape;

		this.bbTree = BBPolarTreeBuilder.makeTree(shape, swelling);
	}

	function getShape():TextShape {
		return shape;
	}

	function overlaps(other:EngineWord):Boolean {
		return bbTree.overlaps(other.bbTree);
	}

	function setDesiredLocation(placer:WordPlacer, count:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int):PlaceInfo {
		desiredLocation = word.getTargetPlace(placer, rank, count,
				wordImageWidth, wordImageHeight, fieldWidth, fieldHeight);
		currentLocation = desiredLocation != null ? desiredLocation.get()
				: null;
		return currentLocation;
	}

	function nudge(nudge:Point):void {
		currentLocation = new PlaceInfo(
				desiredLocation.getpVector().add(nudge),
				currentLocation.getReturnedObj());
		bbTree.setLocation(int(currentLocation.getpVector().x),
				int(currentLocation.getpVector().y));
	}

	function finalizeLocation():void {
		var bounds:Rectangle= this.shape.getBounds2D();

		var x:Number= currentLocation.getpVector().x - bounds.width / 2;
		var y:Number= currentLocation.getpVector().y - bounds.height / 2;
		shape.translate(x,y);

		shape =
		// WordShaper.moveToOrigin(
		WordShaper.rotate(shape, getTree().getRotation()
				);

		 bbTree.setLocation(currentLocation.getpVector().x, currentLocation.getpVector().y);
		word.setRenderedPlace(currentLocation.getpVector());
	}

	public function getCurrentLocation():PlaceInfo {
		if (currentLocation != null)
			return new PlaceInfo(currentLocation.getpVector().clone(),
					currentLocation.getReturnedObj());
		else
			return null;
	}

	public function wasPlaced():Boolean {
		return word.wasPlaced();
	}

	public function trespassed(img:TemplateImage):Boolean {
		if(img==null) return false;
		var bounds:Rectangle= shape.getBounds2D();
		var x:Number= (this.currentLocation.getpVector().x - bounds.width / 2);
		var y:Number= (this.currentLocation.getpVector().y - bounds.width / 2);
		// float right = (float) (this.currentLocation.getpVector().x + bounds
		// .getWidth());
		// float bottom = (float) (this.currentLocation.getpVector().y + bounds
		// .getHeight());
		return !img.contains(x, y, bounds.width, bounds.height,false);
	}

	public function getTree():BBPolarRootTree {
		return this.bbTree;
	}

	function getAngle(angler:WordAngler):Number {
		renderedAngle = !isNaN(presetAngle)  ? presetAngle : angler
				.angleFor(this);
		return renderedAngle;
	}

	/**
	 * Set the angle this Word should be rendered at - WordCram won't even call
	 * the WordAngler.
	 * 
	 * @return the Word, for more configuration
	 */
	public function setAngle(angle:Number):Word {
		this.presetAngle = angle;
		return this.word;
	}

	/**
	 * Get the angle the Word was rendered at: either the value passed to
	 * setAngle(), or the value returned from the WordAngler.
	 * 
	 * @return the rendered angle
	 */
	public function getRenderedAngle():Number {
		return renderedAngle;
	}

	function wasSkipped():Boolean {
		return word.wasSkipped();
	}
}
}