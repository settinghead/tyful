package org.sepy.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.controls.Label;
	import mx.controls.Spacer;
	import mx.controls.TextInput;
	import mx.core.BitmapAsset;
	import mx.core.MovieClipAsset;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.FocusManager;
	import mx.managers.IFocusManagerComponent;
	
	import org.sepy.color.HLS;
	import org.sepy.events.ImageFilterEvent;
	import org.sepy.events.SPickerEvent;
	import org.sepy.graphics.ColorMatrix;
	import org.sepy.graphics.filters.WebcolorsImageFilter;
	import org.sepy.utils.ColorUtils;
	import org.sepy.utils.StringUtils;
	import flash.display.DisplayObject;
	import flash.display.Stage;

	[Event(name="changing", type="org.sepy.events.SPickerEvent")]
	[Event(name="swatchAdd", type="org.sepy.events.SPickerEvent")]
	[Event(name="close",    type="mx.events.CloseEvent")]
	[Event(name="change",   type="flash.events.Event")]		

	[IconFile("ColorPicker.png")]
	public class SColorPicker extends TitleWindow
	{
		private const BOX_HEIGHT:uint = 200;
		private const BOX_WIDTH:uint  = 180;
		private const COLOR_WIDTH:uint = 60;
		private const COLOR_HEIGHT:uint = 40;
		private const SLIDER_WIDTH:uint = 22;
		private const MAX_STEPS:int = 1000;

		private const c_fillType:String = "linear";
		private const c_colors:Array = [0x000000, 0x000000];
		private const c_alphas:Array = [0, 1];
		private const c_ratios:Array = [0, 255];
		private const c_matrix:Matrix = new Matrix();

	    private const m_fillType:String = "linear"
	    private var m_colors:Array = [0xFFFFFF, 0x000000]
	    private var m_alphas:Array = [1, 1]
    	private var m_ratios:Array = [0, 255]
	    private const m_matrix:Matrix = new Matrix();
	    
	    private const s_fillType:String = "linear"
	    private const s_matrix:Matrix = new Matrix();
	    private var s_colors:Array  = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF,  0xFF00FF, 0xFF0000 ]
	    private var s_ratios:Array;
	    private var s_alphas:Array;
				
		protected var _selectedColor:uint;
		protected var _originalColor:int = -1;
		protected var _suggested_websafe:uint;
		protected var _add_swatch_enabled:Boolean;
		
		private var _box1:HBox;
		private var _slider_mc:UIComponent;
		private var _slider_bmp:BitmapData;
		private var gradient_bitmap:Bitmap;
		private var _websafe_canvas:Canvas;
		private var gradient_canvas:Canvas;
		private var gradient_mc:UIComponent;
		private var gradient_rect:Rectangle;
		
		private var _buffer:BitmapData;
		private var _output:BitmapData;
		private var _right_color:UIComponent;
		private var _right_safe_mc:UIComponent;
		private var _right_safe_bitmap:Bitmap;
		
		private var sliderDirty:Boolean;
		private var matrixDirty:Boolean;
		private var dirty:Boolean;
		private var slider_down:Boolean;
		private var matrix_down:Boolean;
		
		private var rgb_input:TextInput;
		private var r_input:TextInput;
		private var g_input:TextInput;
		private var b_input:TextInput;
		
		private var h_input:TextInput;
		private var l_input:TextInput;
		private var s_input:TextInput;		
		
		private var ok_button:Button;
		private var cancel_button:Button;
		private var add_swatch_button:Button;
		
		private var websafe_check:CheckBox;
		
		private var _picker_enabled:Boolean;
		private var pickerDirty:Boolean;
		
		[Embed(source="/assets/scolorpicker/spicker_assets.swf", symbol="cross_png")]
		private var baseClass:Class;
		private var _crossair:BitmapAsset;
		
		[Embed(source="/assets/scolorpicker/spicker_assets.swf", symbol="cross_slider")]
		private var sliderClass:Class;
		private var _cross_slider:BitmapAsset;
		
		[Embed(source="/assets/scolorpicker/warning_small.png")]
		private var warningClass:Class;
		private var warningAsset:BitmapAsset;
		
		[Embed(source="/assets/scolorpicker/warning_small_disabled.png")]
		private var warningClassDisabled:Class;
		private var warningAssetDisabled:BitmapAsset;
		private var currentCursorID:int = -1;
		private var currentStageBuffer:BitmapData;
		
		[Embed(source="/assets/scolorpicker/picker.png")]
		private var pickerClass:Class;
		
		public static const VERSION:String = "1.0";
		public static const AUTHOR:String  = "Alessandro Crugnola";
		
		public function SColorPicker()
		{
			super();	
			
			s_ratios = new Array();
			s_alphas = new Array();
			
			for(var i:uint = 0; i < s_colors.length; i++)
			{
				s_ratios.push(int((i/(s_colors.length-1))*255));
				s_alphas.push(1);
			}

			_slider_bmp = new BitmapData(SLIDER_WIDTH, BOX_HEIGHT, false, 0x00);
		}

		
		override protected function measure():void
		{
			super.measure();			
		}
		
		override protected function commitProperties():void
		{
			// TODO: commitProperties
			super.commitProperties();
			
			var pt:Point;
			
			if(dirty)
			{
				dirty = false;
				var s:uint = selectedColor;
				var steps:uint = 0;
				var r:uint;
				var g:uint;
				var b:uint;
				var rect:Rectangle;
				do
				{
					rect = _output.getColorBoundsRect(0xFFFFFFFF, 0xFF000000+s, true);
					s++
					steps++;
				} while(rect.width == 0 && s < 0xffffff && steps < MAX_STEPS);
				if(rect.width > 0 && rect.height > 0)
				{
					_crossair.x = rect.x - _crossair.width/2;
					_crossair.y = rect.y - _crossair.height/2;
				}
				setSelectedColor(selectedColor, false);
				
			}
			if(sliderDirty)
			{
				sliderDirty = false;
				pt = new Point(Math.floor(_crossair.x + _crossair.width/2), Math.floor(_crossair.y + _crossair.height/2));
				updateGradient(_slider_bmp.getPixel(_slider_bmp.width/2, _cross_slider.y + _cross_slider.height/2));
				setSelectedColor(_output.getPixel(pt.x, pt.y), false);	// TODO: fix here
			}
			if(matrixDirty){
				matrixDirty = false;
				pt = new Point(_crossair.x + _crossair.width/2, _crossair.y + _crossair.height/2)
				//changeSliderColor(_output.getPixel(pt.x, pt.y));
				setSelectedColor(_output.getPixel(pt.x, pt.y), false);
			}
			if(pickerDirty){
				if(picker_enabled){
					this.visible = false;
					if(stage)
					{
						currentStageBuffer = new BitmapData(Math.min(stage.width, 2880), Math.min(stage.height, 2880));
						currentStageBuffer.draw(this.stage);
						this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseStage_event);
						this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseStage_event);
					}
				} else {
					if(stage)
					{
						this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseStage_event);
						this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseStage_event);
						if(currentStageBuffer)
							currentStageBuffer.dispose();
					}
				}
				pickerDirty = false;
			}
			
			add_swatch_button.visible = _add_swatch_enabled;
		}
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			var d:DisplayObject = this;
			callLater(
				function():void {
					gradient_rect = gradient_bitmap.getBounds(d);
				}
			);
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!_box1){
				_box1 = new HBox();
				_box1.percentWidth = 100;
				_box1.percentHeight = 100;
			} else {
				return;
			}
			
			var box2:VBox = new VBox();
			var box3:HBox = new HBox();
			var box4:HBox = new HBox();
			var box5:VBox = new VBox();
			var box6:VBox = new VBox();
			var box7:VBox = new VBox();
			var box8:HBox = new HBox();
			var spacer:Spacer;
			
			gradient_canvas = new Canvas();
			gradient_canvas.setStyle("borderStyle", "solid");
			gradient_canvas.setStyle("horizontalGap", 0);
			gradient_canvas.setStyle("verticalGap", 0);
		
			// matrix color gradient container
			gradient_mc = new UIComponent();
			gradient_mc.width  = BOX_WIDTH;
			gradient_mc.height = BOX_HEIGHT;
			gradient_mc.graphics.beginFill(0xFFFFCC, 1);
			gradient_mc.graphics.drawRect(0, 0, BOX_WIDTH, BOX_HEIGHT);
			gradient_mc.graphics.endFill();
			
			_buffer = createGradientMatrix(BOX_WIDTH, BOX_HEIGHT);
			_output = _buffer.clone();			
			_crossair = BitmapAsset(new baseClass());
			var mask:UIComponent = new UIComponent();
			mask.width = BOX_WIDTH
			mask.height = BOX_HEIGHT;
			mask.graphics.beginFill(0x00, 1);
			mask.graphics.drawRect(0,0, BOX_WIDTH, BOX_HEIGHT);
			mask.graphics.endFill();

			_crossair.x = - _crossair.width/2
			_crossair.y = - _crossair.height/2
			_crossair.mask = mask;

			box4.setStyle("horizontalGap", 1);
			var canv2:Canvas = new Canvas();
			canv2.setStyle("borderStyle", "solid");
			
			_slider_mc = new UIComponent();
			_slider_mc.width = SLIDER_WIDTH;
			_slider_mc.height = BOX_HEIGHT;

			_cross_slider = BitmapAsset(new sliderClass());
			var cross_slider_mc:UIComponent = new UIComponent();
			cross_slider_mc.width = 10;
			cross_slider_mc.height = BOX_HEIGHT
			cross_slider_mc.graphics.beginFill(0x00, 0);
			cross_slider_mc.graphics.drawRect(0, 0, 15, BOX_HEIGHT);
			cross_slider_mc.graphics.endFill();
			_cross_slider.y = -5;
			
			// original and current color container
			var canv3:Canvas = new Canvas();
			canv3.setStyle("borderStyle", "solid");
			canv3.setStyle("borderColor", 0x999999);
			_right_color = new UIComponent();
			_right_color.width  = COLOR_WIDTH;
			_right_color.height = COLOR_HEIGHT;
			_right_color.graphics.beginFill(0x00, 1);
			_right_color.graphics.drawRect(0, 0, COLOR_WIDTH, COLOR_HEIGHT);
			_right_color.graphics.endFill();
			
			canv3.addChild(_right_color);
			

			_websafe_canvas = new Canvas();
			_websafe_canvas.setStyle("borderStyle", "solid");
			_websafe_canvas.buttonMode = true;
			
			_right_safe_mc = new UIComponent();
			_right_safe_mc.width  = 10;
			_right_safe_mc.height = 10;
			_right_safe_mc.graphics.beginFill(0x00, 1);
			_right_safe_mc.graphics.drawRect(0, 0, 10, 10);
			_right_safe_mc.graphics.endFill();			
			_right_safe_mc.toolTip = "Suggested web-safe color (click to apply)";
			
			_right_safe_bitmap = new Bitmap(new BitmapData( 10, 10,false));
			_right_safe_mc.addChild(_right_safe_bitmap);
			
			
			var warning_ui:UIComponent = new UIComponent();
			warningAsset = BitmapAsset(new warningClass());
			warningAssetDisabled = BitmapAsset(new warningClassDisabled());
			warning_ui.addChild(warningAsset);
			warning_ui.addChild(warningAssetDisabled);

			warning_ui.width  = warningAsset.width;
			warning_ui.height = warningAsset.height;			
			
			box7.addChild(warning_ui);
			
			
			_websafe_canvas.addChild(_right_safe_mc);
			box7.addChild(_websafe_canvas);

			box8.addChild(canv3);
			box8.addChild(box7);
			box5.addChild(box8);
			
			spacer = new Spacer();
			spacer.height = 1;
			box5.addChild(spacer);
			
			var rgb_grid:Grid    = new Grid();
			rgb_grid.setStyle("verticalGap",   3);
			rgb_grid.setStyle("horizontalGap", 2);
			var rgb_row:GridRow  = new GridRow();
			var rgb_item1:GridItem = new GridItem();
			var rgb_item2:GridItem = new GridItem();
			
			rgb_item1.setStyle("horizontalGap", 0);
			rgb_item2.setStyle("horizontalGap", 0);
			
			// R field
			r_input = new TextInput();
			r_input.condenseWhite = true;
			r_input.maxChars = 3
			r_input.restrict = "0-9"			
			var r_label:Label = new Label();
			r_label.text = "R";
			rgb_item1.addChild(r_label);
			rgb_item2.addChild(r_input);
			rgb_row.addChild(rgb_item1);
			rgb_row.addChild(rgb_item2);
			

			// HUE field
			rgb_item1 = new GridItem();
			rgb_item2 = new GridItem();					
			h_input = new TextInput();
			h_input.condenseWhite = true;
			h_input.maxChars = 3
			h_input.restrict = "0-9"
			var h_label:Label = new Label();
			h_label.text = "H";
			rgb_item1.addChild(h_label);
			rgb_item2.addChild(h_input);
			rgb_row.addChild(rgb_item1);
			rgb_row.addChild(rgb_item2);
			rgb_grid.addChild(rgb_row);				

			// G field
			rgb_row = new GridRow();
			rgb_item1 = new GridItem();
			rgb_item2 = new GridItem();		
			g_input = new TextInput();
			g_input.condenseWhite = true;
			g_input.maxChars = 3
			g_input.restrict = "0-9"			
			var g_label:Label = new Label();
			g_label.text = "G";
			rgb_item1.addChild(g_label);
			rgb_item2.addChild(g_input);
			rgb_row.addChild(rgb_item1);
			rgb_row.addChild(rgb_item2);
			
			
			// LUMINANCE field
			rgb_item1 = new GridItem();
			rgb_item2 = new GridItem();					
			l_input = new TextInput();
			l_input.condenseWhite = true;
			l_input.maxChars = 3
			l_input.restrict = "0-9"
			var l_label:Label = new Label();
			l_label.text = "L";
			rgb_item1.addChild(l_label);
			rgb_item2.addChild(l_input);
			rgb_row.addChild(rgb_item1);
			rgb_row.addChild(rgb_item2);
			rgb_grid.addChild(rgb_row);				

			// B field
			rgb_row = new GridRow();
			rgb_item1 = new GridItem();
			rgb_item2 = new GridItem();		
			b_input = new TextInput();
			b_input.condenseWhite = true;
			b_input.maxChars = 3
			b_input.restrict = "0-9"
			var b_label:Label = new Label();
			b_label.text = "B";
			rgb_item1.addChild(b_label);
			rgb_item2.addChild(b_input);
			rgb_row.addChild(rgb_item1);
			rgb_row.addChild(rgb_item2);
			
			// SATURATION field
			rgb_item1 = new GridItem();
			rgb_item2 = new GridItem();					
			s_input = new TextInput();
			s_input.condenseWhite = true;
			s_input.maxChars = 3
			s_input.restrict = "0-9"
			var s_label:Label = new Label();
			s_label.text = "S";
			rgb_item1.addChild(s_label);
			rgb_item2.addChild(s_input);
			rgb_row.addChild(rgb_item1);
			rgb_row.addChild(rgb_item2);
			rgb_grid.addChild(rgb_row);				
			
			// RGB field
			rgb_row = new GridRow();
			rgb_item1 = new GridItem();
			rgb_item2 = new GridItem();	
			rgb_item2.colSpan = 3;				
			var rgb_label:Label = new Label();
			rgb_label.text = "#"
			rgb_input = new TextInput();
			rgb_input.condenseWhite = true;
			rgb_input.maxChars = 6
			rgb_input.restrict = "0-9A-F"
			rgb_input.percentWidth = 100;
			rgb_item1.addChild(rgb_label);
			rgb_item2.addChild(rgb_input);
			rgb_row.addChild(rgb_item1);
			rgb_row.addChild(rgb_item2);
			rgb_grid.addChild(rgb_row);
			
			box5.addChild(rgb_grid);

			ok_button = new Button();
			ok_button.label = "Ok";
			ok_button.percentWidth = 100;
			
			add_swatch_button = new Button();
			add_swatch_button.label = "Add swatch";
			add_swatch_button.percentWidth = 100;
			add_swatch_button.visible = add_swatch;
			//add_swatch_button.toolTip = "add current color to picker default colors";
			
			cancel_button = new Button();
			cancel_button.label = "Cancel";
			cancel_button.percentWidth = 100;
			
			
			box6.percentHeight = 100;
			box6.percentWidth = 100;
			box6.setStyle("verticalAlign", "bottom");
			
			spacer = new Spacer();
			spacer.height = 2;
			
			box6.addChild(spacer);
			box6.addChild(ok_button);
			box6.addChild(cancel_button);
			box6.addChild(add_swatch_button);

			
			websafe_check = new CheckBox();
			websafe_check.label = "WebSafe Colors";
			
			box5.addChild(box6);

			canv2.addChild(_slider_mc);
			box4.addChild(canv2);
			cross_slider_mc.addChild(_cross_slider);
			box4.addChild(cross_slider_mc);

			gradient_bitmap = new Bitmap(_output);

			gradient_mc.addChild(gradient_bitmap);
			gradient_mc.addChild(_crossair);
			gradient_mc.addChild(mask);
			gradient_canvas.addChild(gradient_mc);

			var box9:VBox = new VBox();
			box9.addChild(gradient_canvas);
			box9.addChild(websafe_check);
			box3.addChild(box9);
			
			box3.addChild(box4);
			box3.addChild(box5);
			box2.addChild(box3);
			//box2.addChild(websafe_check);
			_box1.addChild(box2);			
			this.addChild(_box1);

			gradient_mc.addEventListener(MouseEvent.MOUSE_DOWN, matrix_mouseEvent);
			//gradient_mc.addEventListener(MouseEvent.MOUSE_UP, matrix_mouseEvent);
			//gradient_mc.addEventListener(MouseEvent.MOUSE_MOVE, matrix_mouseEvent);
			
			cross_slider_mc.addEventListener(MouseEvent.MOUSE_DOWN, slider_mouseEvent);			
			cross_slider_mc.addEventListener(MouseEvent.MOUSE_UP, slider_mouseEvent);
			cross_slider_mc.addEventListener(MouseEvent.MOUSE_OUT, slider_mouseEvent);
			cross_slider_mc.addEventListener(MouseEvent.MOUSE_MOVE, slider_mouseEvent);
			_right_color.addEventListener(MouseEvent.CLICK, restore_color);
			rgb_input.addEventListener( Event.CHANGE, text_rgb_change);
			r_input.addEventListener(Event.CHANGE, text_rgb_change);
			g_input.addEventListener(Event.CHANGE, text_rgb_change);
			b_input.addEventListener(Event.CHANGE, text_rgb_change);
			
			h_input.addEventListener(Event.CHANGE, text_hls_change);
			l_input.addEventListener(Event.CHANGE, text_hls_change);
			s_input.addEventListener(Event.CHANGE, text_hls_change);			
			
			ok_button.addEventListener(MouseEvent.CLICK, button_event)
			cancel_button.addEventListener(MouseEvent.CLICK, button_event)	
			websafe_check.addEventListener(Event.CHANGE, websafe_event);	
			add_swatch_button.addEventListener(MouseEvent.CLICK, button_event);
			_right_safe_mc.addEventListener(MouseEvent.CLICK, websafe_click);
			
			this.addEventListener(CloseEvent.CLOSE, onClose);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onClose);
			
			updateSliderColor();
		}
		
		private function createGradientMatrix(w:uint, h:uint):BitmapData
		{
			var mc:Sprite = new Sprite();
			var bmp:BitmapData = new BitmapData(w, h, false, 0x00);
			var gr:Graphics = mc.graphics;
			mc.width  = w
			mc.height = h
			m_matrix.createGradientBox(w, h, 0, 0, 0);
			gr.clear();
			gr.beginGradientFill(m_fillType, m_colors, m_alphas, m_ratios, m_matrix);
			gr.drawRect(0, 0, w, h);
			gr.endFill()
			
			c_matrix.createGradientBox(w, h, 90*Math.PI/180, 0, 0);
			gr.beginGradientFill(c_fillType, c_colors, c_alphas, c_ratios, c_matrix)
			gr.moveTo(0,0)
			gr.lineTo(w,0)
			gr.lineTo(w, h)
			gr.lineTo(0, h)
			gr.lineTo(0,0)	
	        gr.endFill();

	        bmp.draw(mc);
	        return bmp;
		}
		
		/**
		 * update brightness of the main gradient box display
		 * based on the selection over the right slider box
		 */		
		private function updateGradient(color:int = -1):void
		{
			m_colors[1] = color > -1 ? color : _selectedColor;
			_buffer = createGradientMatrix(BOX_WIDTH, BOX_HEIGHT);
			_output = _buffer.clone();
			gradient_bitmap.bitmapData = _output	
		}
		
		
		private function updateSliderColor():void
		{
			changeSliderColor(selectedColor);
		}
		
		/**
		 * Update display colors, and color RGB/HLS informations
		 * 
		 */
		private function updateColors(updateGColor:Boolean = true):void
		{
			var current:IFocusManagerComponent;
			var r:uint, g:uint, b:uint;			
			
			_right_color.graphics.beginFill(_selectedColor, 1);
			_right_color.graphics.drawRect(0,0, COLOR_WIDTH, COLOR_HEIGHT/2);
			_right_color.graphics.endFill();
			_right_color.graphics.beginFill(_originalColor, 1);
			_right_color.graphics.drawRect(0, COLOR_HEIGHT/2, COLOR_WIDTH, COLOR_HEIGHT/2);
			_right_color.graphics.endFill();
			
			r = _selectedColor >> 16;
			g = _selectedColor >> 8 & 0xFF;
			b = _selectedColor & 0xFF;	
			
			// update websafe suggested color
			var sr:uint = Math.round(r / 51) * 51;
			var sg:uint = Math.round(g  / 51) * 51;
			var sb:uint = Math.round(b / 51) * 51;
			
			_suggested_websafe = sr << 16 | sg << 8 | sb
			
			
			
			if(_suggested_websafe != _selectedColor){
				warningAsset.visible = true;
				warningAssetDisabled.visible = false;
			} else {
				warningAsset.visible = false;
				warningAssetDisabled.visible = true;
			}
			_right_safe_bitmap.bitmapData.fillRect(_right_safe_bitmap.bitmapData.rect, _suggested_websafe);
			
			if(!matrix_down && !slider_down){
				try{
					current = focusManager.getFocus()
				} catch(e:Error){
					
				}
			}
			
			if(current != r_input){
				r_input.text = r.toString();
			}
			
			if(current != g_input){
				g_input.text = g.toString();
			}
			
			if(current != b_input){
				b_input.text = b.toString();
			}
			
			if(current != rgb_input){
				rgb_input.text = StringUtils.fillLeft(_selectedColor.toString(16), "0", 6);
			}
			
			var _hls:HLS = ColorUtils.RGB2HLS(r,g,b);
			
			if(current != h_input){
				h_input.text = _hls.hue.toString()
			}
			
			if(current != l_input){
				l_input.text = _hls.luminance.toString()
			}
			
			if(current != s_input){
				s_input.text = _hls.saturation.toString()
			}
			
			if(updateGColor)
				updateGradient(_selectedColor);
		}
		
		
		private function setSelectedColor(c:uint, updateGColor:Boolean = true):void
		{
			_selectedColor = c;
			updateColors(updateGColor);
			var evt:SPickerEvent = new SPickerEvent(SPickerEvent.CHANGING);
			evt.value = _selectedColor;
			dispatchEvent(evt);
		}
		
		
		/**
		 * change the slider color based on the selection
		 * of the matrix color cross-air
		 * 
		 */
		private function changeSliderColor(c:uint):void
		{
			// TODO: changeSliderColor
			
			var _m:Matrix = new Matrix();
			var _c:Array = [s_colors[s_colors.length-1], 0x000000, 0xFFFFFF]
			var gr:Graphics = _slider_mc.graphics;
			var w:uint = SLIDER_WIDTH;
			var h:uint = _slider_mc.height;
			
			_m.createGradientBox(SLIDER_WIDTH, 20, 90*Math.PI/180, 0, _slider_mc.height - 20);
			
			s_matrix.createGradientBox(SLIDER_WIDTH, BOX_HEIGHT - 20, 90*Math.PI/180);
			
			_slider_mc.graphics.clear();
			_slider_mc.graphics.beginGradientFill(GradientType.LINEAR, s_colors, s_alphas, s_ratios, s_matrix, SpreadMethod.PAD, s_fillType);
			_slider_mc.graphics.drawRect(0, 0, SLIDER_WIDTH, _slider_mc.height - 20);
			
			_slider_mc.graphics.beginGradientFill(GradientType.LINEAR, _c, [1,1,1], [0,127,200], _m, SpreadMethod.PAD, s_fillType);
			_slider_mc.graphics.drawRect(0, _slider_mc.height - 20, SLIDER_WIDTH, 20);
			
			
			_slider_mc.graphics.endFill();
			_slider_bmp.draw(_slider_mc);

			var s:uint = c;
			var steps:uint = 0;
			var rect:Rectangle;
			var r:uint;
			var g:uint;
			var b:uint;
			do
			{
				rect = _slider_bmp.getColorBoundsRect(0xFFFFFFFF, 0xFF000000+s, true);
				steps++;
				
				r = s >> 16 & 0xff
				g = s >> 8 & 0xff
				b = s & 0xff;
				r = Math.min(r+1, 255);
				g = Math.min(g+1, 255);
				b = Math.min(b+1, 255);
				
				s = r << 16 | g << 8 | b
			} while(rect.width == 0 && s > 0 && steps < MAX_STEPS);

			_cross_slider.y = rect.bottom - _cross_slider.height/2
			setSelectedColor(c);
		}
		
		/**
		 * Events dispatched from the right slider bar
		 * 
		 */
		private function slider_mouseEvent(evt:MouseEvent):void
		{
			if(evt.type == MouseEvent.MOUSE_DOWN)
			{
				slider_down = true;
				websafe_check.selected = false;
			} else if(evt.type == MouseEvent.MOUSE_UP)
			{
				slider_down = false;
			} else if(evt.type == MouseEvent.MOUSE_MOVE && slider_down && evt.localY < _slider_mc.height && evt.localY >= _slider_mc.y)
			{
				_cross_slider.y = evt.localY - (_cross_slider.height/2)
				sliderDirty = true;
				evt.updateAfterEvent();
				invalidateProperties();
				
			} else if(evt.type == MouseEvent.MOUSE_OUT)
			{
				slider_down = false;
			}
		}


		/**
		 * Events dispatched from the gradient cross-air
		 * 
		 */
		private function matrix_mouseEvent(evt:MouseEvent):void
		{
			if(evt.type == MouseEvent.MOUSE_DOWN)
			{
				matrix_down = true;
				_crossair.y = evt.localY - (_crossair.height/2)
				_crossair.x = evt.localX - (_crossair.width/2)
				matrixDirty = true;
				evt.updateAfterEvent();
				invalidateProperties();
				
				this.addEventListener(MouseEvent.MOUSE_MOVE, matrix_mouseEvent);
				this.addEventListener(MouseEvent.MOUSE_UP, matrix_mouseEvent);
				if(stage)
					stage.addEventListener(MouseEvent.MOUSE_MOVE, matrix_mouseEvent);
			} else if(evt.type == MouseEvent.MOUSE_UP)
			{
				matrix_down = false;
				this.removeEventListener(MouseEvent.MOUSE_MOVE, matrix_mouseEvent);
				this.removeEventListener(MouseEvent.MOUSE_UP, matrix_mouseEvent);
				if(stage)
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, matrix_mouseEvent);
			} else if(evt.type == MouseEvent.MOUSE_MOVE && matrix_down)
			{
				if(evt.currentTarget is Stage)
				{
					if(!this.getBounds(stage).contains(stage.mouseX, stage.mouseY))
					{
						matrix_down = false;
						this.removeEventListener(MouseEvent.MOUSE_MOVE, matrix_mouseEvent);
						this.removeEventListener(MouseEvent.MOUSE_UP, matrix_mouseEvent);
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, matrix_mouseEvent);
						return;
					}
				}
				
				var pt:Point = new Point(this.mouseX, this.mouseY);
				
				if(gradient_mc.mouseX < 0)
					pt.x = gradient_rect.x;
				else if(gradient_rect.right - 1 < this.mouseX)
					pt.x = gradient_rect.right - 1

				if(gradient_mc.mouseY < 0)
					pt.y = gradient_rect.y
				else if(gradient_rect.bottom - 1 < this.mouseY)
					pt.y = gradient_rect.bottom	-1 
				
				_crossair.y = (pt.y - (_crossair.height/2)) - gradient_rect.y
				_crossair.x = pt.x - ((_crossair.width/2)) - gradient_rect.x
				matrixDirty = true;
				evt.updateAfterEvent();
				invalidateProperties();
				
			}
		}

		/**
		 * User click on the original starting color box
		 * 
		 */
		private function restore_color(evt:MouseEvent):void
		{
			if(evt.localY > UIComponent(evt.target).height/2){
				selectedColor = int(_originalColor);
			}
		}
		
		/**
		 * User change values from the text input (RGB)
		 * 
		 */
		private function text_rgb_change(evt:Event):void
		{
			var nextColor:uint;
			var textColor:String = TextInput(evt.target).text;
			switch(evt.target){
				case rgb_input:
						nextColor = parseInt(textColor, 16);
					break;
				case r_input:
						nextColor = uint( uint(textColor) << 16 | uint(g_input.text) << 8 | uint(b_input.text) )
					break;				
				case g_input:
						nextColor = uint( uint(r_input.text) << 16 | uint(textColor) << 8 | uint(b_input.text) )
					break;
				case b_input:
						nextColor = uint( uint(r_input.text) << 16 | uint(g_input.text) << 8 | uint(textColor) )
					break;
			}
			websafe_check.selected = false;
			changeSliderColor(nextColor);
		}

		/**
		 * User change values from the text input (HLS)
		 * 
		 */
		private function text_hls_change(evt:Event):void
		{
			var _hls:HLS;
			var nextColor:uint;
			var textColor:String = TextInput(evt.target).text;
			switch(evt.target){
				case h_input:
						_hls = new HLS( uint(textColor), uint(l_input.text), uint(s_input.text))
					break;				
				case l_input:
						_hls = new HLS(uint(h_input.text), uint(textColor) , uint(s_input.text))
					break;
				case s_input:
						_hls = new HLS(uint(h_input.text), uint(h_input.text), uint(textColor))
					break;
			}
			nextColor = ColorUtils.HLS2RGB(_hls);
			websafe_check.selected = false;
			changeSliderColor(nextColor);
		}

		

		/**
		 * ok and cancel button events
		 * 
		 */
		private function button_event(evt:MouseEvent):void
		{
			if(evt.target == ok_button){
				dispatchEvent(new Event(Event.CHANGE));
			} else if(evt.target == add_swatch_button){
				var event:SPickerEvent = new SPickerEvent(SPickerEvent.SWATCH_ADD);
				event.value = _selectedColor;
				dispatchEvent(event);
			} else {
				dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			}
		}
		
		
		/**
		 * Perform internal actions before closing the window
		 * 
		 */
		private function onClose(evt:Event):void
		{
			CursorManager.removeAllCursors();
			if(currentStageBuffer){
				currentStageBuffer.dispose();
			}
			if(evt.type == Event.REMOVED_FROM_STAGE){
				cleanup();
			}	
		}
		
		/**
		 * Clean-up everything before removing
		 * this component from the display list
		 * 
		 */
		private function cleanup():void
		{
			if(this.stage.hasEventListener(MouseEvent.MOUSE_MOVE)){
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseStage_event);
				this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseStage_event);
			}
			if(currentStageBuffer){
				currentStageBuffer.dispose();
			}
		}
		
		/**
		 * switch between web-safe or regular colors
		 * 
		 */
		private function websafe_event(evt:Event):void
		{
			if(websafe_check.selected){
				CursorManager.setBusyCursor();
				var tmp:BitmapData = new BitmapData(_buffer.width, _buffer.height);
				var filter:WebcolorsImageFilter = new WebcolorsImageFilter(40);
				filter.addEventListener(ImageFilterEvent.COMPLETE, onwebsafe_complete)
				filter.apply(_buffer, tmp);				
				this.enabled = false;
			} else {
				_output = _buffer.clone();
				gradient_bitmap.bitmapData = _output;
				
				matrixDirty = true;	// TODO: websafe_event
				invalidateProperties();
				
			}
		}
		
		
		/**
		 * Mouse stage event
		 * currently dispatched when outside picker is enabled
		 * 
		 */
		private function mouseStage_event(evt:MouseEvent):void
		{
			var pt:Point = new Point(evt.stageX, evt.stageY);
			if(evt.type == MouseEvent.MOUSE_MOVE){
				if(this.getRect(stage).containsPoint(pt)){
					if(CursorManager.currentCursorID == currentCursorID){
						CursorManager.removeCursor(currentCursorID);
					}
				} else {
					if(CursorManager.currentCursorID != currentCursorID){
						currentCursorID = CursorManager.setCursor(pickerClass, 2, 0, -17);
					}
					selectedColor = currentStageBuffer.getPixel(pt.x, pt.y);
				}
			} else if(evt.type == MouseEvent.MOUSE_DOWN){
				if(!this.getRect(stage).containsPoint(pt)){
					selectedColor = currentStageBuffer.getPixel(pt.x, pt.y);
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		
		private function websafe_click(evt:MouseEvent):void
		{
			// TODO: websafe_click
			selectedColor = int(_suggested_websafe);
		}
		
		private function onwebsafe_complete(evt:ImageFilterEvent):void
		{
			CursorManager.removeAllCursors();
			this.enabled = true;
			
			_output = evt.dest;
			gradient_bitmap.bitmapData = _output

			matrixDirty = true;	// TODO: websafe_event
			invalidateProperties();			
		}
		
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		
		public function set selectedColor(i:uint):void
		{
			//if(i != _selectedColor){
				_selectedColor = i;
				if(_originalColor < 0){
					_originalColor = i;
				}
				dirty = true;
				invalidateProperties();
			//}
		}
		
		/**
		 * Return the original color (defined on window opening)
		 * @return 
		 * 
		 */
		public function get originalColor():uint
		{
			return _originalColor;
		}
		
		
		/**
		 * Return the suggested websafe color
		 * @return
		 * 
		 */
		public function get suggested_websafe():uint
		{
			return _suggested_websafe;
		}
		
		
		/**
		 * Display the 'add swatch' button
		 * @param value
		 * @see org.sepy.events.SPickerEvent.SWATCH_ADD
		 */
		public function set add_swatch(value:Boolean):void
		{
			_add_swatch_enabled = value;
			invalidateProperties();
		}
		
		public function get add_swatch():Boolean
		{
			return _add_swatch_enabled;
		}
		
		
		
		/**
		 * Enable/Disable the possibility to pick color 
		 * from the stage DisplayObject
		 * 
		 */
		public function set picker_enabled(value:Boolean):void
		{
			_picker_enabled = value;
			pickerDirty = true;
			invalidateProperties()
		}
		
		public function get picker_enabled():Boolean
		{
			return _picker_enabled;
		}
	}
}