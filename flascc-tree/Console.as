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
package com.adobe.flascc
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.filters.DropShadowFilter;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.AntiAliasType;
  import flash.text.StyleSheet;
  import flash.text.TextFieldAutoSize;
  import flash.display.DisplayObjectContainer;
  import flash.display.Stage;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.net.LocalConnection;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.utils.ByteArray;
  import com.adobe.flascc.vfs.ISpecialFile;
  import polartree.PolarTree.slapWord;


  /**
  * A basic implementation of a console for flascc apps.
  * The PlayerKernel class delegates to this for things like read/write
  * so that console output can be displayed in a TextField on the Stage.
  */
  public class Console extends Sprite implements ISpecialFile
  {
    private var inputContainer:DisplayObjectContainer
    
    public var bmd:BitmapData;
    public var bm:Bitmap;

    include "./TestingCode.as";

    /**
    * To Support the preloader case you might want to have the Console
    * act as a child of some other DisplayObjectContainer.
    */
    public function Console(container:DisplayObjectContainer = null)
    {
      CModule.rootSprite = container ? container.root : this

      if(container) {
        container.addChild(this)
        init(null)
      } else {
        addEventListener(Event.ADDED_TO_STAGE, init)
      }
    }

    /**
    * All of the real flascc init happens in this method
    * which is either run on startup or once the SWF has
    * been added to the stage.
    */
    protected function init(e:Event):void
    {
      inputContainer = new Sprite()
      addChild(inputContainer)

      addEventListener(Event.ENTER_FRAME, enterFrame)

      stage.frameRate = 60
      stage.scaleMode = StageScaleMode.NO_SCALE
      
      bmd = new BitmapData(stage.stageWidth, stage.stageHeight, false)
      bm = new Bitmap(bmd)
      addChild(bm)
      CModule.startAsync(this)
      initTesting()
    }

    /**
    * The callback to call when flascc code calls the posix exit() function. Leave null to exit silently.
    * @private
    */
    public var exitHook:Function;

    /**
    * The PlayerKernel implementation will use this function to handle
    * C process exit requests
    */
    public function exit(code:int):Boolean
    {
      // default to unhandled
      return exitHook ? exitHook(code) : false;
    }

    /**
    * The PlayerKernel implementation will use this function to handle
    * C IO write requests to the file "/dev/tty" (e.g. output from
    * printf will pass through this function). See the ISpecialFile
    * documentation for more information about the arguments and return value.
    */
    public function write(fd:int, bufPtr:int, nbyte:int, errnoPtr:int):int
    {
      var str:String = CModule.readString(bufPtr, nbyte)
      consoleWrite(str)
      return nbyte
    }

    /**
    * The PlayerKernel implementation will use this function to handle
    * C IO read requests to the file "/dev/tty" (e.g. reads from stdin
    * will expect this function to provide the data). See the ISpecialFile
    * documentation for more information about the arguments and return value.
    */
    public function read(fd:int, bufPtr:int, nbyte:int, errnoPtr:int):int
    {
      return 0
    }

    /**
    * The PlayerKernel implementation will use this function to handle
    * C fcntl requests to the file "/dev/tty" 
    * See the ISpecialFile documentation for more information about the
    * arguments and return value.
    */
    public function fcntl(fd:int, com:int, data:int, errnoPtr:int):int
    {
      return 0
    }

    /**
    * The PlayerKernel implementation will use this function to handle
    * C ioctl requests to the file "/dev/tty" 
    * See the ISpecialFile documentation for more information about the
    * arguments and return value.
    */
    public function ioctl(fd:int, com:int, data:int, errnoPtr:int):int
    {
      return 0
    }

    /**
    * Helper function that traces to the flashlog text file and also
    * displays output in the on-screen textfield console.
    */
    protected function consoleWrite(s:String):void
    {
      trace(s)
    }

    /**
    * The enterFrame callback will be run once every frame. UI thunk requests should be handled
    * here by calling CModule.serviceUIRequests() (see CModule ASdocs for more information on the UI thunking functionality).
    */
    protected function enterFrame(e:Event):void
    {
      CModule.serviceUIRequests()
      var args:Vector.<int> = new Vector.<int>;

      var textField:TextField = getTextField("Blah", 30);
      var params:Array = getTextShape(textField);
      args.push(params[0]);
      args.push(params[1]);
      args.push(params[2]);
      var coord:Vector.<int> =
       polartree.PolarTree.CModule.callI(polartree.PolarTree.CModule.getPublicSymbol("slapShape"), args);
       //slapShape();
      //textField.x = coord[0];
      //textField.y = coord[1];

      CModule.activeConsole.addChild(textField);


    }
    private const HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );

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
      textField.embedFonts = true;
      textField.cacheAsBitmap = false;
      textField.x = 0;
      textField.y = 0;
      textField.antiAliasType = AntiAliasType.ADVANCED;
//      textField.text  = text;
      textField.htmlText = "<div>"+text+"</div>";
      textField.filters = [new DropShadowFilter(0.5,45,0,1.0,0.5,0.5)];
      if(text.length>11){ //TODO: this is a temporary fix
        var w:Number = textField.width;
        textField.wordWrap = true;
        textField.width = w/(text.length/11)*1.1 ;
      }
      return textField;
    }

    private function getTextShape(textField:TextField, safetyBorder:Number=0):Array{
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


    /**
    * Provide a way to get the TextField's text.
    */
    public function get consoleText():String
    {
        var txt:String = null;

        if(_tf != null){
            txt = _tf.text;
        }
        
        return txt;
    }
  }
}
