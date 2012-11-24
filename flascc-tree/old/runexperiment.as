/*
** ADOBE SYSTEMS INCORPORATED
** Copyright 2012 Adobe Systems Incorporated
** All Rights Reserved.
**
** NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
** terms of the Adobe license agreement accompanying it.  If you have received this file from a
** source other than Adobe, then your use, modification, or distribution of it requires the prior
** written permission of Adobe.
*/
package
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.filters.DropShadowFilter;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.display.Loader;
  import flash.display.LoaderInfo;
  import flash.display.Sprite;
  import flash.events.*;
  import flash.net.URLRequest;
  import flash.text.AntiAliasType;
  import flash.text.StyleSheet;
  import flash.text.TextFieldAutoSize;
  import flash.display.DisplayObjectContainer;
  import flash.display.SimpleButton;
  import flash.display.Stage;
  import flash.display.StageScaleMode;
  import flash.net.LocalConnection;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.utils.ByteArray;
  import polartree.PolarTree.slapShape;
  import polartree.PolarTree.initCanvas;
  import polartree.PolarTree.CModule;

  public class runexperiment extends Sprite
  {


    private const HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );
    var init_complete:Boolean = false;
    public function runexperiment()
    {

      addEventListener(Event.ADDED_TO_STAGE, initCode)
      addEventListener(Event.ENTER_FRAME, enterFrame);
      CModule.startAsync(this);
    }

    protected function enterFrame(e:Event):void
    {
      trace("enterFrame event");
      if(init_complete){
        CModule.serviceUIRequests()

        var textField:TextField = getTextField("Blah", 100);
        var params:Array = getTextShape(textField);

        //var args:Vector.<int> = new Vector.<int>;
        //args.push(params[0]);
        //args.push(params[1]);
        //args.push(params[2]);

        var coord:Vector.<Number> =
         slapShape(params[0],params[1],params[2]);

         if(coord!=null){
          textField.x = coord[0];
          textField.y = coord[1];
          addChild(textField);
        }
      }
    }

    public function initCode(e:Event):void
    {
      //CModule.rootSprite = this;
      //CModule.vfs.console = this;
      init_complete = false;
      //var width:int = 1024, height:int = 768;
      var loader:Loader = new Loader();
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
      loader.load(new URLRequest("../static/f/templates/egg.png"));
    }

    function onLoadComplete (event:Event):void
    {
      CModule.serviceUIRequests()
      var bitmapData:BitmapData;
      bitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
      var directionBmp:Bitmap = new Bitmap(bitmapData);
      var data:ByteArray = directionBmp.bitmapData.getPixels(new Rectangle(directionBmp.width, directionBmp.height));
      trace(data.length);
      var addr:int = CModule.malloc(data.length);
      CModule.writeBytes(addr, data.length, data);

      initCanvas(addr,directionBmp.width,directionBmp.height);
      init_complete = true;
    }

    private function getTextShape(textField:TextField, safetyBorder:Number=0):Array
    {
      var bounds: Rectangle = textField.getBounds( textField );
      HELPER_MATRIX.tx = -bounds.x + safetyBorder;
      HELPER_MATRIX.ty = -bounds.y + safetyBorder;

      var bmp:Bitmap = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0 ) );
      var s:Sprite = new Sprite();
      s.width = textField.width;
      s.height = textField.height;
        
      s.addChild(textField);
      bmp.bitmapData.draw( s );


      var data:ByteArray = bmp.bitmapData.getPixels(new Rectangle(bmp.width, bmp.height));
      trace(data.length);
      var addr:int = CModule.malloc(data.length);
      CModule.writeBytes(addr, data.length, data);
      return [addr,bmp.width, bmp.height];
    }

    public function getTextField(text: String, size: Number, rotation: Number = 0):TextField
    {
      var textField: TextField = new TextField();
//      textField.setTextFormat( new TextFormat( font.fontName, size ) );
      var style:StyleSheet = new StyleSheet();
      style.parseCSS("div{font-size: "+size+"; leading: 0; text-align: center;}");
      textField.styleSheet = style;
      textField.autoSize = TextFieldAutoSize.LEFT;
      textField.background = false;
      textField.selectable = false;
      //textField.embedFonts = true;
      //textField.cacheAsBitmap = true;
      //textField.x = 0;
      //textField.y = 0;
      textField.antiAliasType = AntiAliasType.ADVANCED;
      textField.htmlText = "<div>"+text+"</div>";
      textField.filters = [new DropShadowFilter(0.5,45,0,1.0,0.5,0.5)];
      if(text.length>11){ //TODO: this is a temporary fix
        var w:Number = textField.width;
        textField.wordWrap = true;
        textField.width = w/(text.length/11)*1.1 ;
      }
      return textField;
    }
  }
}
