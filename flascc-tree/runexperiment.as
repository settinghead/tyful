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
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.display.Loader;
  import flash.display.LoaderInfo;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.display.StageScaleMode;
  import flash.net.LocalConnection;
  import flash.net.URLRequest;
  import flash.events.*;
  import flash.net.LocalConnection;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.AntiAliasType;
  import flash.text.StyleSheet;
  import flash.text.TextFieldAutoSize;  
  import flash.filters.DropShadowFilter;
  import flash.utils.ByteArray;
  import polartree.PolarTree.vfs.ISpecialFile;
  import polartree.PolarTree.slapShape;
  import polartree.PolarTree.initCanvas;
  import polartree.PolarTree.getShrinkage;
  import polartree.PolarTree.getStatus;
  import polartree.PolarTree.CModule;
  import flash.utils.Endian;



  /**
  * A basic implementation of a console for FlasCC apps.
  * The PlayerKernel class delegates to this for things like read/write
  * so that console output can be displayed in a TextField on the Stage.
  */
  public class runexperiment extends Sprite implements ISpecialFile
  {

    [Embed(source="./fonts/konstellation/panefresco-500.ttf", fontFamily="panefresco500", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
    public static const Panefresco500: Class;
    [Embed(source="./fonts/konstellation/permanentmarker.ttf", fontFamily="permanentmarker", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
    public static const PermanentMarker: Class;
    [Embed(source="./fonts/konstellation/romeral.ttf", fontFamily="romeral", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
    public static const Romeral: Class;

    [Embed(source="./fonts/konstellation/bpreplay-kRB.ttf", fontFamily="bpreplay-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
    public static const BpreplayKRB: Class;
    [Embed(source="./fonts/konstellation/fifthleg-kRB.ttf", fontFamily="fifthleg-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
    public static const FifthlegKRB: Class;
    [Embed(source="./fonts/konstellation/pecita-kRB.ttf", fontFamily="pecita-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
    public static const PecitaKRB: Class;
    [Embed(source="./fonts/konstellation/sniglet-kRB.ttf", fontFamily="sniglet-kRB", mimeType='application/x-font',
        embedAsCFF='false', advancedAntiAliasing="true")]
    public static const snigletKRB: Class;

    private var inputContainer:DisplayObjectContainer
    private var enableConsole:Boolean = true
    private var _tf:TextField

    private const HELPER_MATRIX: Matrix = new Matrix( 1, 0, 0, 1 );

    /**
    * To Support the preloader case you might want to have the Console
    * act as a child of some other DisplayObjectContainer.
    */
    public function runexperiment(container:DisplayObjectContainer = null)
    {
      CModule.rootSprite = container ? container.root : this
      //CModule.rootSprite = this

      if(container) {
        container.addChild(this)
        init(null)
      } else {
        addEventListener(Event.ADDED_TO_STAGE, init)
      }
    }

    /**
    * All of the real FlasCC init happens in this method
    * which is either run on startup or once the SWF has
    * been added to the stage.
    */
    protected function init(e:Event):void
    {

      //CModule.rootSprite = this;
      CModule.vfs.console = this;
      //var width:int = 1024, height:int = 768;

      inputContainer = new Sprite()
      addChild(inputContainer)

      stage.frameRate = 60
      stage.scaleMode = StageScaleMode.NO_SCALE

      if(enableConsole) {
        _tf = new TextField
        _tf.multiline = true
        _tf.width = stage.stageWidth
        _tf.height = stage.stageHeight 
        inputContainer.addChild(_tf)
      }

      var loader:Loader = new Loader();
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
      loader.load(new URLRequest("../static/f/templates/wheel_h.png"));
    }

    protected function onLoadComplete (event:Event):void{
      //inputContainer = new Sprite()
      //addChild(inputContainer)

      CModule.serviceUIRequests()
      var bitmapData:BitmapData;
      bitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
      var directionBmp:Bitmap = new Bitmap(bitmapData);
      var data:ByteArray = directionBmp.bitmapData.getPixels(new Rectangle(0,0,bitmapData.width, bitmapData.height));
      consoleWrite("data length: "+ data.length.toString()+"\n");
      data.position = 0;
      var addr:int = CModule.malloc(data.length);
      CModule.writeBytes(addr, data.length, data);

      initCanvas(addr,directionBmp.width,directionBmp.height);


      addEventListener(Event.ENTER_FRAME, enterFrame)

      //inputContainer.addChild(directionBmp);
      CModule.startAsync(this)
    }

    /**
    * The callback to call when FlasCC code calls the posix exit() function. Leave null to exit silently.
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
      if(enableConsole) {
        _tf.appendText(s)
        _tf.scrollV = _tf.maxScrollV
      }
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

    /**
    * The enterFrame callback will be run once every frame. UI thunk requests should be handled
    * here by calling CModule.serviceUIRequests() (see CModule ASdocs for more information on the UI thunking functionality).
    */

    protected function enterFrame(e:Event):void
    {
      CModule.serviceUIRequests()
      trace("enterFrame event");

      if(getStatus()>0){

        var textField:TextField = getTextField("Test", 100*getShrinkage()+10);
        var params:Array = getTextShape(textField);

        var coord:Vector.<Number> =
          slapShape(params[0],params[1],params[2]);

         if(coord!=null){
          var rotation:Number = coord[2];

          var s:Sprite = new Sprite();
          //s.width = textField.width;
          //s.height = textField.height;
          textField.x = 0;
          textField.y = 0;

          s.addChild(textField);
          var w:Number = s.width;
          var h:Number = s.height;
          s.x = coord[0];
          s.y = coord[1];

          var centerX:Number=s.x+s.width/2;
          var centerY:Number = s.y+s.height/2;

          consoleWrite("CenterX: "+centerX.toString()+", CenterY: "+centerY.toString()+", width: "+ s.width.toString() +", height: "+ s.height.toString() +" rotation: "+rotation.toString());

          var m:Matrix=s.transform.matrix;
          m.tx -= centerX;
          m.ty -= centerY;
          m.rotate(-rotation); // was a missing "=" here
          m.tx += centerX;
          m.ty += centerY;
          s.transform.matrix = m;
          addChild(s);
        }
      }
//      var args:Vector.<int> = new Vector.<Number>;
//      args.push(params[0]);
//      args.push(params[1]);
//      args.push(params[2]);
    }

    private function getTextShape(textField:TextField, safetyBorder:Number=0):Array
    {
      var bounds: Rectangle = textField.getBounds( textField );
      HELPER_MATRIX.tx = -bounds.x + safetyBorder;
      HELPER_MATRIX.ty = -bounds.y + safetyBorder;

      var bmp:Bitmap = new Bitmap( new BitmapData( bounds.width + safetyBorder * 2, bounds.height + safetyBorder * 2, true, 0xFFFFFFFF ) );
      var s:Sprite = new Sprite();
      //s.width = textField.width;
      //s.height = textField.height;
      s.x = 0;
      s.y = 0;
      s.addChild(textField);
      bmp.bitmapData.draw( s );


      var data:ByteArray = bmp.bitmapData.getPixels(new Rectangle(0,0,bmp.bitmapData.width, bmp.bitmapData.height));
      consoleWrite("width: "+s.width.toString()+", height: "+s.height.toString()+", length: "+data.length.toString()+"\n");
      data.position = 0;
      var addr:int = CModule.malloc(data.length);
      CModule.writeBytes(addr, data.length, data);
      return [addr,bmp.width, bmp.height];
    }

    public function getTextField(text: String, size: Number, rotation: Number = 0):TextField
    {
      var textField: TextField = new TextField();
//      textField.setTextFormat( new TextFormat( font.fontName, size ) );
      var style:StyleSheet = new StyleSheet();
      style.parseCSS("div{font-size: "+size+"; font-family: romeral; leading: 0; text-align: center;}");
      textField.styleSheet = style;
      textField.autoSize = TextFieldAutoSize.LEFT;
      textField.background = false;
      textField.selectable = false;
      textField.embedFonts = true;
      //textField.cacheAsBitmap = true;
      textField.x = 0;
      textField.y = 0;
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
