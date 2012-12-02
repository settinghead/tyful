package com.settinghead.tyful.client.model.vo
{	
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.wordlist.WordVO;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class DisplayWordVO extends Sprite
	{
		private var _textField:TextField;
		private var _word:WordVO = null;
		private var _place:PlaceInfo = null;
		private var _fontSize:Number;
		private var _fontName:String;
		
		
		public function DisplayWordVO(word:WordVO, fontName:String, fontSize:Number, color:uint=0x0, place:PlaceInfo = null){
			super();
			this.useHandCursor = true;
			this.buttonMode = true;
			this.mouseChildren = true;
			this._word = word;
			this._place = place;
			this._fontSize = fontSize;
			
			textField = getTextField(word.word, fontName, fontSize, color);
			textField.x = 0;
			textField.y = 0;
			
			if(this._place!=null){
				putToPlace(place);
			}
		}
		
		public function putToPlace(place:PlaceInfo){
			this.x = place.x;
			this.y = place.y;
			
			var centerX:Number=this.x+this.width/2;
			var centerY:Number = this.y+this.height/2;
			
			//						trace("CenterX: "+centerX.toString()+", CenterY: "+centerY.toString()+", width: "+ s.width.toString() +", height: "+ s.height.toString() +" rotation: "+rotation.toString());
			//rotate
			var m:Matrix=this.transform.matrix;
			m.tx -= centerX;
			m.ty -= centerY;
			m.rotate(-place.rotation); // was a missing "=" here
			m.tx += centerX;
			m.ty += centerY;
			this.transform.matrix = m;
		}
		
		public function get fontSize():Number{
			return this._fontSize;
		}
		
		public function get fontName():String{
			return this._fontName;
		}
		
		
		private static function getTextField(text: String, fontName:String, size: Number, color:uint):TextField
		{
			var textField: TextField = new TextField();
			//      textField.setTextFormat( new TextFormat( font.fontName, size ) );
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("div{font-size: "+size+"px; font-family: "+fontName+"; leading: 0; text-align: center;}");
			textField.styleSheet = style;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = false;
			textField.selectable = false;
			textField.embedFonts = true;
			//textField.cacheAsBitmap = true;
			textField.x = 0;
			textField.y = 0;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = color;
			textField.htmlText = "<div>"+text+"</div>";
			textField.filters = [new DropShadowFilter(0.5,45,0,1.0,0.5,0.5)];
			if(text.length>11){ //TODO: this is a temporary fix
				var w:Number = textField.width;
				textField.wordWrap = true;
				textField.width = w/(text.length/11)*1.1 ;
			}
			return textField;
		}
		

		

		
		public function set textField(t:TextField):void{
			if(t==null && _textField!=null){
				super.removeChild(_textField);
			}
			this._textField=t;
			if(_textField!=null)
				super.addChild(_textField);
		}
		
		public function get textField():TextField{
			return _textField;
		}
		
		public function get word():WordVO{
			return _word;
		}
		
		public function get place():PlaceInfo{
			return _place;
		}
		
	}
}