package com.settinghead.wexpression.client.model.vo {
	import com.settinghead.wexpression.client.PlaceInfo;
	import com.settinghead.wexpression.client.WordShaper;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.density.Patch;
	import com.settinghead.wexpression.client.model.vo.template.Layer;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	import com.settinghead.wexpression.client.placer.WordPlacer;
	
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.Alert;

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
	private var _word:WordVO;
	private var rank:int;

	private var _shape:TextShapeVO;
	public var bbTree:BBPolarRootTreeVO;
	private var presetAngle:Number = NaN;
	private var renderedAngle:Number;
	
	private var desiredLocationIndex:int;

	private var _desiredLocations:Vector.<PlaceInfo>;
	private var currentLocation:PlaceInfo;
	private var targetPlaceInfo:Vector.<PlaceInfo>;
	private var renderedPlace:Point;
	private var skippedBecause:int = -1;
	
	
	public function EngineWordVO(word:WordVO, rank:int, wordCount:int) {
		this._word = word;
		this.rank = rank;
	}

	public function setShape(shape:TextShapeVO, swelling:int):void {
		this._shape = shape;

		this.bbTree = BBPolarTreeBuilder.makeTree(shape, swelling);
	}

	public function get shape():TextShapeVO {
		return _shape;
	}

	public function overlaps(other:EngineWordVO):Boolean {
		return bbTree.overlaps(other.bbTree);
	}

	public function retrieveDesiredLocations(placer:WordPlacer, count:int,
			wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
			fieldHeight:int):void {
		_desiredLocations = getTargetPlace(placer, rank, count,
				wordImageWidth, wordImageHeight, fieldWidth, fieldHeight);
	}
	
	public function hasNextDesiredLocation():Boolean{
		return desiredLocationIndex < _desiredLocations.length; 
	}
	
	public function nextDesiredLocation():PlaceInfo{
		return _desiredLocations[desiredLocationIndex++];
	}

	public function nudgeTo(loc:Point, patch:Patch):void {
		currentLocation = new PlaceInfo(loc, patch);
		bbTree.setLocation(int(currentLocation.getpVector().x),
				int(currentLocation.getpVector().y));
	}

	public function finalizeLocation():void {

		var x:Number= currentLocation.getpVector().x ;
		var y:Number= currentLocation.getpVector().y ;
		shape.setCenterLocation(x,y);

		_shape =
		// WordShaper.moveToOrigin(
		WordShaper.rotate(shape, getTree().getRotation()
				);

		 bbTree.setLocation(currentLocation.getpVector().x, currentLocation.getpVector().y);
		setRenderedPlace(currentLocation.getpVector());
		currentLocation.patch.eWords.push(this);
	}
	
	public function get desiredLocations():Vector.<PlaceInfo>{
		return this._desiredLocations;
	}
	
	public function get offsetDistance():Number{
		var distSum:Number = 0;
		for(var i:int=0;i<desiredLocationIndex;i++){
			distSum += this.currentLocation.distanceFrom(this._desiredLocations[i]);
		}
		return distSum;
	}

	public function getCurrentLocation():PlaceInfo {
		if (currentLocation != null)
			return new PlaceInfo(currentLocation.getpVector().clone(),
					currentLocation.patch);
		else
			return null;
	}

	public function trespassed(layer:Layer):Boolean {
		if(layer==null) return false;
		var x:Number= (this.currentLocation.getpVector().x - bbTree.getWidth(true) / 2);
		var y:Number= (this.currentLocation.getpVector().y - bbTree.getHeight(true) / 2);
		// float right = (float) (this.currentLocation.getpVector().x + bounds
		// .getWidth());
		// float bottom = (float) (this.currentLocation.getpVector().y + bounds
		// .getHeight());
		return !layer.contains(x, y, bbTree.getWidth(true), bbTree.getHeight(true),false);
	}

	public function getTree():BBPolarRootTreeVO {
		return this.bbTree;
	}

	public function getAngle(angler:WordAngler):Number {
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

	
	public function get word():WordVO{
		return this._word;
	}
	
	
	public function getTargetPlace(placer:WordPlacer, rank:int, count:int,
							wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
							fieldHeight:int):Vector.<PlaceInfo> {

		targetPlaceInfo =  placer.place(this.word, rank, count, wordImageWidth,
			wordImageHeight, fieldWidth, fieldHeight);
		return targetPlaceInfo;
	}
	
	public function setRenderedPlace(place:Point):void {
		renderedPlace = place.clone();
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
	
	public function wasSkippedBecause(reason:int):void {
		skippedBecause = reason;
	}
	
	
	
	public function rendition(c:uint):DisplayWordVO{
		
		var s:DisplayWordVO = new DisplayWordVO(this);
			var tt:TextField = new TextField();
			tt.autoSize = TextFieldAutoSize.LEFT;
			tt.embedFonts = true;
			tt.cacheAsBitmap = true;
			tt.textColor = c;
			
			tt.styleSheet = this.shape.textField.styleSheet;
			
			tt.antiAliasType = AntiAliasType.ADVANCED;
			tt.htmlText = this.shape.textField.htmlText;
			if(word.word.length>10){ //TODO: this is a temporary fix
				var ww:Number = tt.width;
				tt.wordWrap = true;
				tt.width = ww/(word.word.length/10)*1.1 ;
			}
			
			s.filters = [ 
//												new GlowFilter( 0x000000, 1, 0, 0, 255 ),  
				new DropShadowFilter(0.5,45,0,1.0,0.5,0.5) 
			];
			
			s.addChild(tt);
			
			var w:Number = s.width;
			var h:Number = s.height;
			s.x = this.shape.centerX-w/2;
			s.y = this.shape.centerY-h/2;
			
			if(this.shape.rotation!=0){
				var centerX:Number=s.x+s.width/2;
				var centerY:Number = s.y+s.height/2;
				
				//			var point:Point=new Point(shape.shape.x+shape.shape.width/2, shape.shape.y+shape.shape.height/2);
				var m:Matrix=s.transform.matrix;
				m.tx -= centerX;
				m.ty -= centerY;
				m.rotate(-this.shape.rotation); // was a missing "=" here
				m.tx += centerX;
				m.ty += centerY;
				s.transform.matrix = m;
			}
			
			//			var r = Math.sqrt(Math.pow(s.width/2,2)+Math.pow(s.height/2,2));
			
			return s;
		}
	}
}