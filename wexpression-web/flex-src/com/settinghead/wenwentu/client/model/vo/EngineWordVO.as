package com.settinghead.wenwentu.client.model.vo {
	import com.settinghead.wenwentu.client.PlaceInfo;
	import com.settinghead.wenwentu.client.WordShaper;
	import com.settinghead.wenwentu.client.angler.WordAngler;
	import com.settinghead.wenwentu.client.placer.WordPlacer;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

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



public class EngineWordVO {
	var _word:WordVO;
	var rank:int;

	private var shape:TextShapeVO;
	public var bbTree:BBPolarRootTreeVO;
	private var presetAngle:Number = NaN;
	var renderedAngle:Number;

	private var desiredLocation:PlaceInfo;
	private var currentLocation:PlaceInfo;

	public function EngineWordVO(word:WordVO, rank:int, wordCount:int) {
		this._word = word;
		this.rank = rank;
	}

	public function setShape(shape:TextShapeVO, swelling:int):void {
		this.shape = shape;

		this.bbTree = BBPolarTreeBuilder.makeTree(shape, swelling);
	}

	public function getShape():TextShapeVO {
		return shape;
	}

	public function overlaps(other:EngineWordVO):Boolean {
		return bbTree.overlaps(other.bbTree);
	}

	public function setDesiredLocation(placer:WordPlacer, count:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int):PlaceInfo {
		desiredLocation = word.getTargetPlace(placer, rank, count,
				wordImageWidth, wordImageHeight, fieldWidth, fieldHeight);
		currentLocation = desiredLocation != null ? desiredLocation.get()
				: null;
		return currentLocation;
	}

	public function nudge(nudge:Point):void {
		currentLocation = new PlaceInfo(
				desiredLocation.getpVector().add(nudge),
				currentLocation.getReturnedObj());
		bbTree.setLocation(int(currentLocation.getpVector().x),
				int(currentLocation.getpVector().y));
	}

	public function finalizeLocation():void {

		var x:Number= currentLocation.getpVector().x ;
		var y:Number= currentLocation.getpVector().y ;
		shape.setCenterLocation(x,y);

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

	public function trespassed(img:TemplateVO):Boolean {
		if(img==null) return false;
		var x:Number= (this.currentLocation.getpVector().x - bbTree.getWidth(true) / 2);
		var y:Number= (this.currentLocation.getpVector().y - bbTree.getHeight(true) / 2);
		// float right = (float) (this.currentLocation.getpVector().x + bounds
		// .getWidth());
		// float bottom = (float) (this.currentLocation.getpVector().y + bounds
		// .getHeight());
		return !img.contains(x, y, bbTree.getWidth(true), bbTree.getHeight(true),false);
	}

	public function getTree():BBPolarRootTreeVO {
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
	public function setAngle(angle:Number):WordVO {
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

	public function wasSkipped():Boolean {
		return word.wasSkipped();
	}
	
	public function get word():WordVO{
		return this._word;
	}
}
}