/* -*- mode: java; c-basic-offset: 2; indent-tabs-mode: nil -*- */

/*
 Part of the Processing project - http://processing.org

 Copyright (c) 2004-11 Ben Fry and Casey Reas
 Copyright (c) 2001-04 Massachusetts Institute of Technology

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation, version 2.1.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General private License for more details.

 You should have received a copy of the GNU Lesser General
 private License along with this library; if not, write to the
 Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 Boston, MA  02111-1307  USA
 */

package processing.core;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.io.*;
import java.lang.reflect.*;
import java.net.*;
import java.text.*;
import java.util.*;
import java.util.regex.*;
import java.util.zip.*;

import javax.imageio.ImageIO;

/**
 * Base class for all sketches that use processing.core.
 * <p/>
 * Note that you should not use AWT or Swing components inside a Processing
 * applet. The surface is made to automatically update itself, and will cause
 * problems with redraw of components drawn above it. If you'd like to integrate
 * other Java components, see below.
 * <p/>
 * As of release 0145, Processing uses active mode rendering in all cases. All
 * animation tasks happen on the "Processing Animation Thread". The setup() and
 * draw() methods are handled by that thread, and events (like mouse movement
 * and key presses, which are fired by the event dispatch thread or EDT) are
 * queued to be (safely) handled at the end of draw(). For code that needs to
 * run on the EDT, use SwingUtilities.invokeLater(). When doing so, be careful
 * to synchronize between that code (since invokeLater() will make your code run
 * from the EDT) and the Processing animation thread. Use of a callback function
 * or the registerXxx() methods in PApplet can help ensure that your code
 * doesn't do something naughty.
 * <p/>
 * As of release 0136 of Processing, we have discontinued support for versions
 * of Java prior to 1.5. We don't have enough people to support it, and for a
 * project of our size, we should be focusing on the future, rather than working
 * around legacy Java code. In addition, Java 1.5 gives us access to better
 * timing facilities which will improve the steadiness of animation.
 * <p/>
 * This class extends Applet instead of JApplet because 1) historically, we
 * supported Java 1.1, which does not include Swing (without an additional,
 * sizable, download), and 2) Swing is a bloated piece of crap. A Processing
 * applet is a heavyweight AWT component, and can be used the same as any other
 * AWT component, with or without Swing.
 * <p/>
 * Similarly, Processing runs in a Frame and not a JFrame. However, there's
 * nothing to prevent you from embedding a PApplet into a JFrame, it's just that
 * the base version uses a regular AWT frame because there's simply no need for
 * swing in that context. If people want to use Swing, they can embed themselves
 * as they wish.
 * <p/>
 * It is possible to use PApplet, along with core.jar in other projects. In
 * addition to enabling you to use Java 1.5+ features with your sketch, this
 * also allows you to embed a Processing drawing area into another Java
 * application. This means you can use standard GUI controls with a Processing
 * sketch. Because AWT and Swing GUI components cannot be used on top of a
 * PApplet, you can instead embed the PApplet inside another GUI the way you
 * would any other Component.
 * <p/>
 * It is also possible to resize the Processing window by including
 * <tt>frame.setResizable(true)</tt> inside your <tt>setup()</tt> method. Note
 * that the Java method <tt>frame.setSize()</tt> will not work unless you first
 * set the frame to be resizable.
 * <p/>
 * Because the default animation thread will run at 60 frames per second, an
 * embedded PApplet can make the parent sluggish. You can use frameRate() to
 * make it update less often, or you can use noLoop() and loop() to disable and
 * then re-enable looping. If you want to only update the sketch intermittently,
 * use noLoop() inside setup(), and redraw() whenever the screen needs to be
 * updated once (or loop() to re-enable the animation thread). The following
 * example embeds a sketch and also uses the noLoop() and redraw() methods. You
 * need not use noLoop() and redraw() when embedding if you want your
 * application to animate continuously.
 * 
 * <PRE>
 * private class ExampleFrame extends Frame {
 * 
 *   private ExampleFrame() {
 *     super(&quot;Embedded PApplet&quot;);
 * 
 *     setLayout(new BorderLayout());
 *     PApplet embed = new Embedded();
 *     add(embed, BorderLayout.CENTER);
 * 
 *     // important to call this whenever embedding a PApplet.
 *     // It ensures that the animation thread is started and
 *     // that other internal variables are properly set.
 *     embed.init();
 *   }
 * }
 * 
 * private class Embedded extends PApplet {
 * 
 *   private void setup() {
 *     // original setup code here ...
 *     size(400, 400);
 * 
 *     // prevent thread from starving everything else
 *     noLoop();
 *   }
 * 
 *   private void draw() {
 *     // drawing code goes here
 *   }
 * 
 *   private void mousePressed() {
 *     // do something based on mouse movement
 * 
 *     // update the screen (run draw once)
 *     redraw();
 *   }
 * }
 * </PRE>
 * 
 * <H2>Processing on multiple displays</H2>
 * <p>
 * I was asked about Processing with multiple displays, and for lack of a better
 * place to document it, things will go here.
 * </P>
 * <p>
 * You can address both screens by making a window the width of both, and the
 * height of the maximum of both screens. In this case, do not use present mode,
 * because that's exclusive to one screen. Basically it'll give you a PApplet
 * that spans both screens. If using one half to control and the other half for
 * graphics, you'd just have to put the 'live' stuff on one half of the canvas,
 * the control stuff on the other. This works better in windows because on the
 * mac we can't get rid of the menu bar unless it's running in present mode.
 * </P>
 * <p>
 * For more control, you need to write straight java code that uses p5. You can
 * create two windows, that are shown on two separate screens, that have their
 * own PApplet. this is just one of the tradeoffs of one of the things that we
 * don't support in p5 from within the environment itself (we must draw the line
 * somewhere), because of how messy it would get to start talking about multiple
 * screens. It's also not that tough to do by hand w/ some Java code.
 * </P>
 * 
 * @usage Web &amp; Application
 */
public class PApplet
//extends Applet 
    implements PConstants

{
  /**
   * Full name of the Java version (i.e. 1.5.0_11). Prior to 0125, this was only
   * the first three digits.
   */
  private static final String javaVersionName = System
      .getProperty("java.version");

  /**
   * Version of Java that's in use, whether 1.1 or 1.3 or whatever, stored as a
   * float.
   * <p>
   * Note that because this is stored as a float, the values may not be
   * <EM>exactly</EM> 1.3 or 1.4. Instead, make sure you're comparing against
   * 1.3f or 1.4f, which will have the same amount of error (i.e. 1.40000001).
   * This could just be a double, but since Processing only uses floats, it's
   * safer for this to be a float because there's no good way to specify a
   * double with the preproc.
   */
  private static final float javaVersion = new Float(
                                                     javaVersionName
                                                         .substring(0, 3))
      .floatValue();

  /**
   * Current platform in use.
   * <p>
   * Equivalent to System.getProperty("os.name"), just used internally.
   */

  /**
   * Current platform in use, one of the PConstants WINDOWS, MACOSX, MACOS9,
   * LINUX or OTHER.
   */
  static int platform;

  /**
   * Name associated with the current 'platform' (see PConstants.platformNames)
   */
  //static private String platformName;

  static {
    String osname = System.getProperty("os.name");

    if (osname.indexOf("Mac") != -1) {
      platform = MACOSX;

    } else if (osname.indexOf("Windows") != -1) {
      platform = WINDOWS;

    } else if (osname.equals("Linux")) { // true for the ibm vm
      platform = LINUX;

    } else {
      platform = OTHER;
    }
  }

  /** The PGraphics renderer associated with this PApplet */
  public PGraphics g;

  //protected Object glock = new Object(); // for sync

  /** The frame containing this applet (if any) */
  private Frame frame;

  /**
   * A leech graphics object that is echoing all events.
   */
  private PGraphics recorder;

  /** Path to sketch folder */
  private String sketchPath; //folder;

  /** When debugging headaches */
  static final boolean THREAD_DEBUG = false;

  /** Default width and height for applet when not specified */
  static private final int DEFAULT_WIDTH = 100;

  static private final int DEFAULT_HEIGHT = 100;

  /**
   * Exception thrown when size() is called the first time.
   * <p>
   * This is used internally so that setup() is forced to run twice when the
   * renderer is changed. This is the only way for us to handle invoking the new
   * renderer while also in the midst of rendering.
   */
  static private class RendererChangeException extends RuntimeException {
  }

  volatile boolean resizeRequest;

  volatile int resizeWidth;

  volatile int resizeHeight;

  /**
   * ( begin auto-generated from width.xml )
   * 
   * System variable which stores the width of the display window. This value is
   * set by the first parameter of the <b>size()</b> function. For example, the
   * function call <b>size(320, 240)</b> sets the <b>width</b> variable to the
   * value 320. The value of <b>width</b> is zero until <b>size()</b> is called.
   * 
   * ( end auto-generated )
   * 
   * @webref environment
   */
  public int width;

  /**
   * ( begin auto-generated from height.xml )
   * 
   * System variable which stores the height of the display window. This value
   * is set by the second parameter of the <b>size()</b> function. For example,
   * the function call <b>size(320, 240)</b> sets the <b>height</b> variable to
   * the value 240. The value of <b>height</b> is zero until <b>size()</b> is
   * called.
   * 
   * ( end auto-generated )
   * 
   * @webref environment
   * 
   */
  public int height;

  /**
   * Time in milliseconds when the applet was started.
   * <p>
   * Used by the millis() function.
   */
  long millisOffset = System.currentTimeMillis();

  /**
   * ( begin auto-generated from frameRate_var.xml )
   * 
   * The system variable <b>frameRate</b> contains the approximate frame rate of
   * the software as it executes. The initial value is 10 fps and is updated
   * with each frame. The value is averaged (integrated) over several frames. As
   * such, this value won't be valid until after 5-10 frames.
   * 
   * ( end auto-generated )
   * 
   * @webref environment
   * @see PApplet#frameRate(float)
   */
  private float frameRate = 10;

  /** Last time in nanoseconds that frameRate was checked */
  protected long frameRateLastNanos = 0;

  /** As of release 0116, frameRate(60) is called as a default */
  protected float frameRateTarget = 60;

  protected long frameRatePeriod = 1000000000L / 60L;

  protected boolean looping;

  /** flag set to true when a redraw is asked for by the user */
  protected boolean redraw;

  private Dimension size;

  /**
   * ( begin auto-generated from frameCount.xml )
   * 
   * The system variable <b>frameCount</b> contains the number of frames
   * displayed since the program started. Inside <b>setup()</b> the value is 0
   * and and after the first iteration of draw it is 1, etc.
   * 
   * ( end auto-generated )
   * 
   * @webref environment
   * @see PApplet#frameRate(float)
   */
  private int frameCount;

  /**
   * true if this applet has had it.
   */
  private volatile boolean finished;

  /**
   * true if the animation thread is paused.
   */
  private volatile boolean paused;

  /**
   * true if exit() has been called so that things shut down once the main
   * thread kicks off.
   */
  protected boolean exitCalled;

  Thread thread;

  protected RegisteredMethods sizeMethods;

  protected RegisteredMethods preMethods, drawMethods, postMethods;

  protected RegisteredMethods mouseEventMethods, keyEventMethods;

  protected RegisteredMethods disposeMethods;

  // messages to send if attached as an external vm

  /**
   * When run externally to a PDE Editor, this is sent by the applet whenever
   * the window is moved.
   * <p>
   * This is used so that the editor can re-open the sketch window in the same
   * position as the user last left it.
   */
  static private final String EXTERNAL_MOVE = "__MOVE__";

  /** true if this sketch is being run by the PDE */
  boolean external = false;

  static final String ERROR_MIN_MAX = "Cannot use min() or max() on an empty array.";

  // during rev 0100 dev cycle, working on new threading model,
  // but need to disable and go conservative with changes in order
  // to get pdf and audio working properly first.
  // for 0116, the CRUSTY_THREADS are being disabled to fix lots of bugs.
  //static final boolean CRUSTY_THREADS = false; //true;

  public void init() {
    finished = false; // just for clarity

    // this will be cleared by draw() if it is not overridden
    looping = true;
    redraw = true; // draw this guy once

    // these need to be inited before setup
    sizeMethods = new RegisteredMethods();
    preMethods = new RegisteredMethods();
    drawMethods = new RegisteredMethods();
    postMethods = new RegisteredMethods();
    mouseEventMethods = new RegisteredMethods();
    keyEventMethods = new RegisteredMethods();
    disposeMethods = new RegisteredMethods();

    try {
      //getAppletContext();
    } catch (NullPointerException e) {
    }

    try {
      if (sketchPath == null) {
        sketchPath = System.getProperty("user.dir");
      }
    } catch (Exception e) {
    } // may be a security problem

    Dimension size = getSize();
    if (size != null && (size.width != 0) && (size.height != 0)) {
      // When this PApplet is embedded inside a Java application with other
      // Component objects, its size() may already be set externally (perhaps
      // by a LayoutManager). In this case, honor that size as the default.
      // Size of the component is set, just create a renderer.
      g = makeGraphics(size.width, size.height, sketchRenderer(), null, true);
      // This doesn't call setSize() or setPreferredSize() because the fact
      // that a size was already set means that someone is already doing it.

    } else {
      int w = sketchWidth();
      int h = sketchHeight();
      g = makeGraphics(w, h, sketchRenderer(), null, true);
      // Fire component resize event
      setSize(w, h);
      //setPreferredSize(new Dimension(w, h));
    }
    width = g.width;
    height = g.height;

    //addListeners();

    // this is automatically called in applets
    // though it's here for applications anyway
    run();
  }

  private int sketchWidth() {
    return DEFAULT_WIDTH;
  }

  private int sketchHeight() {
    return DEFAULT_HEIGHT;
  }

  private String sketchRenderer() {
    return JAVA2D;
  }

  /**
   * This returns the last width and height specified by the user via the size()
   * command.
   */
//  private Dimension getPreferredSize() {
//    return new Dimension(width, height);
//  }

//  private void addNotify() {
//    super.addNotify();
//    println("addNotify()");
//  }

  //////////////////////////////////////////////////////////////

  private class RegisteredMethods {
    int count;

    Object objects[];

    Method methods[];

    // convenience version for no args
    private void handle() {
      handle(new Object[] {});
    }

    private void handle(Object oargs[]) {
      for (int i = 0; i < count; i++) {
        try {
          //System.out.println(objects[i] + " " + args);
          methods[i].invoke(objects[i], oargs);
        } catch (Exception e) {
          if (e instanceof InvocationTargetException) {
            InvocationTargetException ite = (InvocationTargetException) e;
            ite.getTargetException().printStackTrace();
          } else {
            e.printStackTrace();
          }
        }
      }
    }

    private void add(Object object, Method method) {
      if (objects == null) {
        objects = new Object[5];
        methods = new Method[5];
      }
      if (count == objects.length) {
        objects = (Object[]) PApplet.expand(objects);
        methods = (Method[]) PApplet.expand(methods);
//        Object otemp[] = new Object[count << 1];
//        System.arraycopy(objects, 0, otemp, 0, count);
//        objects = otemp;
//        Method mtemp[] = new Method[count << 1];
//        System.arraycopy(methods, 0, mtemp, 0, count);
//        methods = mtemp;
      }
      objects[count] = object;
      methods[count] = method;
      count++;
    }

    /**
     * Removes first object/method pair matched (and only the first, must be
     * called multiple times if object is registered multiple times). Does not
     * shrink array afterwards, silently returns if method not found.
     */
    private void remove(Object object, Method method) {
      int index = findIndex(object, method);
      if (index != -1) {
        // shift remaining methods by one to preserve ordering
        count--;
        for (int i = index; i < count; i++) {
          objects[i] = objects[i + 1];
          methods[i] = methods[i + 1];
        }
        // clean things out for the gc's sake
        objects[count] = null;
        methods[count] = null;
      }
    }

    protected int findIndex(Object object, Method method) {
      for (int i = 0; i < count; i++) {
        if (objects[i] == object && methods[i].equals(method)) {
          //objects[i].equals() might be overridden, so use == for safety
          // since here we do care about actual object identity
          //methods[i]==method is never true even for same method, so must use
          // equals(), this should be safe because of object identity
          return i;
        }
      }
      return -1;
    }
  }

  protected void registerNoArgs(RegisteredMethods meth, String name, Object o) {
    Class<?> c = o.getClass();
    try {
      Method method = c.getMethod(name, new Class[] {});
      meth.add(o, method);

    } catch (NoSuchMethodException nsme) {
      die("There is no private " + name + "() method in the class "
          + o.getClass().getName());

    } catch (Exception e) {
      die("Could not register " + name + " + () for " + o, e);
    }
  }

  protected void registerWithArgs(RegisteredMethods meth, String name,
                                  Object o, Class<?> cargs[]) {
    Class<?> c = o.getClass();
    try {
      Method method = c.getMethod(name, cargs);
      meth.add(o, method);

    } catch (NoSuchMethodException nsme) {
      die("There is no private " + name + "() method in the class "
          + o.getClass().getName());

    } catch (Exception e) {
      die("Could not register " + name + " + () for " + o, e);
    }
  }

  protected void unregisterNoArgs(RegisteredMethods meth, String name, Object o) {
    Class<?> c = o.getClass();
    try {
      Method method = c.getMethod(name, new Class[] {});
      meth.remove(o, method);
    } catch (Exception e) {
      die("Could not unregister " + name + "() for " + o, e);
    }
  }

  protected void unregisterWithArgs(RegisteredMethods meth, String name,
                                    Object o, Class<?> cargs[]) {
    Class<?> c = o.getClass();
    try {
      Method method = c.getMethod(name, cargs);
      meth.remove(o, method);
    } catch (Exception e) {
      die("Could not unregister " + name + "() for " + o, e);
    }
  }

  //////////////////////////////////////////////////////////////

  /**
   * ( begin auto-generated from setup.xml )
   * 
   * The <b>setup()</b> function is called once when the program starts. It's
   * used to define initial enviroment properties such as screen size and
   * background color and to load media such as images and fonts as the program
   * starts. There can only be one <b>setup()</b> function for each program and
   * it shouldn't be called again after its initial execution. Note: Variables
   * declared within <b>setup()</b> are not accessible within other functions,
   * including <b>draw()</b>.
   * 
   * ( end auto-generated )
   * 
   * @webref structure
   * @usage web_application
   * @see PApplet#loop()
   * @see PApplet#size(int, int)
   */
  private void setup() {
  }

  /**
   * ( begin auto-generated from draw.xml )
   * 
   * Called directly after <b>setup()</b> and continuously executes the lines of
   * code contained inside its block until the program is stopped or
   * <b>noLoop()</b> is called. The <b>draw()</b> function is called
   * automatically and should never be called explicitly. It should always be
   * controlled with <b>noLoop()</b>, <b>redraw()</b> and <b>loop()</b>. After
   * <b>noLoop()</b> stops the code in <b>draw()</b> from executing,
   * <b>redraw()</b> causes the code inside <b>draw()</b> to execute once and
   * <b>loop()</b> will causes the code inside <b>draw()</b> to execute
   * continuously again. The number of times <b>draw()</b> executes in each
   * second may be controlled with the <b>delay()</b> and <b>frameRate()</b>
   * functions. There can only be one <b>draw()</b> function for each sketch and
   * <b>draw()</b> must exist if you want the code to run continuously or to
   * process events such as <b>mousePressed()</b>. Sometimes, you might have an
   * empty call to <b>draw()</b> in your program as shown in the above example.
   * 
   * ( end auto-generated )
   * 
   * @webref structure
   * @usage web_application
   * @see PApplet#setup()
   * @see PApplet#loop()
   * @see PApplet#noLoop()
   */
  private void draw() {
    // if no draw method, then shut things down
    //System.out.println("no draw method, goodbye");
    finished = true;
  }

  //////////////////////////////////////////////////////////////

  protected void resizeRenderer(int iwidth, int iheight) {
//    println("resizeRenderer request for " + iwidth + " " + iheight);
    if (width != iwidth || height != iheight) {
//      println("  former size was " + width + " " + height);
      g.setSize(iwidth, iheight);
      width = iwidth;
      height = iheight;
    }
  }

  /**
   * ( begin auto-generated from createGraphics.xml )
   * 
   * Creates and returns a new <b>PGraphics</b> object of the types P2D or P3D.
   * Use this class if you need to draw into an off-screen graphics buffer. The
   * PDF renderer requires the filename parameter. The DXF renderer should not
   * be used with <b>createGraphics()</b>, it's only built for use with
   * <b>beginRaw()</b> and <b>endRaw()</b>.<br />
   * <br />
   * It's important to call any drawing functions between <b>beginDraw()</b> and
   * <b>endDraw()</b> statements. This is also true for any functions that
   * affect drawing, such as <b>smooth()</b> or <b>colorMode()</b>.<br/>
   * <br/>
   * the main drawing surface which is completely opaque, surfaces created with
   * <b>createGraphics()</b> can have transparency. This makes it possible to
   * draw into a graphics and maintain the alpha channel. By using <b>save()</b>
   * to write a PNG or TGA file, the transparency of the graphics object will be
   * honored. Note that transparency levels are binary: pixels are either
   * complete opaque or transparent. For the time being, this means that text
   * characters will be opaque blocks. This will be fixed in a future release
   * (<a href="http://code.google.com/p/processing/issues/detail?id=80">Issue
   * 80</a>).
   * 
   * ( end auto-generated ) <h3>Advanced</h3> Create an offscreen PGraphics
   * object for drawing. This can be used for bitmap or vector images drawing or
   * rendering.
   * <UL>
   * <LI>Do not use "new PGraphicsXxxx()", use this method. This method ensures
   * that internal variables are set up properly that tie the new graphics
   * context back to its parent PApplet.
   * <LI>The basic way to create bitmap images is to use the <A
   * HREF="http://processing.org/reference/saveFrame_.html">saveFrame()</A>
   * function.
   * <LI>If you want to create a really large scene and write that, first make
   * sure that you've allocated a lot of memory in the Preferences.
   * <LI>If you want to create images that are larger than the screen, you
   * should create your own PGraphics object, draw to that, and use <A
   * HREF="http://processing.org/reference/save_.html">save()</A>. For now, it's
   * best to use <A HREF=
   * "http://dev.processing.org/reference/everything/javadoc/processing/core/PGraphics3D.html"
   * >P3D</A> in this scenario. P2D is currently disabled, and the JAVA2D
   * default will give mixed results. An example of using P3D:
   * 
   * <PRE>
   * 
   * PGraphics big;
   * 
   * void setup() {
   *   big = createGraphics(3000, 3000, P3D);
   * 
   *   big.beginDraw();
   *   big.background(128);
   *   big.line(20, 1800, 1800, 900);
   *   // etc..
   *   big.endDraw();
   * 
   *   // make sure the file is written to the sketch folder
   *   big.save(&quot;big.tif&quot;);
   * }
   * 
   * </PRE>
   * 
   * <LI>It's important to always wrap drawing to createGraphics() with
   * beginDraw() and endDraw() (beginFrame() and endFrame() prior to revision
   * 0115). The reason is that the renderer needs to know when drawing has
   * stopped, so that it can update itself internally. This also handles calling
   * the defaults() method, for people familiar with that.
   * <LI>It's not possible to use createGraphics() with the OPENGL renderer,
   * because it doesn't allow offscreen use.
   * <LI>With Processing 0115 and later, it's possible to write images in
   * formats other than the default .tga and .tiff. The exact formats and
   * background information can be found in the developer's reference for <A
   * HREF=
   * "http://dev.processing.org/reference/core/javadoc/processing/core/PImage.html#save(java.lang.String)"
   * >PImage.save()</A>.
   * </UL>
   * 
   * @webref rendering
   * @param iwidth
   *          width in pixels
   * @param iheight
   *          height in pixels
   * @param irenderer
   *          Either P2D, P3D, PDF, DXF
   * 
   * @see PGraphics#PGraphics
   * 
   */
  public PGraphics createGraphics(int iwidth, int iheight, String irenderer) {
    PGraphics pg = makeGraphics(iwidth, iheight, irenderer, null, false);
    //pg.parent = this;  // make save() work
    return pg;
  }

  /**
   * Version of createGraphics() used internally.
   */
  protected PGraphics makeGraphics(int iwidth, int iheight, String irenderer,
                                   String ipath, boolean iprimary) {
    if (irenderer.equals(OPENGL)) {
      if (PApplet.platform == WINDOWS) {
        String s = System.getProperty("java.version");
        if (s != null) {
          if (s.equals("1.5.0_10")) {
            System.err.println("OpenGL support is broken with Java 1.5.0_10");
            System.err.println("See http://dev.processing.org"
                + "/bugs/show_bug.cgi?id=513 for more info.");
            throw new RuntimeException("Please update your Java "
                + "installation (see bug #513)");
          }
        }
      }
    }

//    if (irenderer.equals(P2D)) {
//      throw new RuntimeException("The P2D renderer is currently disabled, " +
//                                 "please use P3D or JAVA2D.");
//    }

    String openglError = "Before using OpenGL, first select "
        + "Import Library > opengl from the Sketch menu.";

    try {
      /*
       * Class<?> rendererClass = Class.forName(irenderer);
       * 
       * Class<?> constructorParams[] = null; Object constructorValues[] = null;
       * 
       * if (ipath == null) { constructorParams = new Class[] { Integer.TYPE,
       * Integer.TYPE, PApplet.class }; constructorValues = new Object[] { new
       * Integer(iwidth), new Integer(iheight), this }; } else {
       * constructorParams = new Class[] { Integer.TYPE, Integer.TYPE,
       * PApplet.class, String.class }; constructorValues = new Object[] { new
       * Integer(iwidth), new Integer(iheight), this, ipath }; }
       * 
       * Constructor<?> constructor =
       * rendererClass.getConstructor(constructorParams); PGraphics pg =
       * (PGraphics) constructor.newInstance(constructorValues);
       */

      Class<?> rendererClass = Thread.currentThread().getContextClassLoader()
          .loadClass(irenderer);

      //Class<?> params[] = null;
      //PApplet.println(rendererClass.getConstructors());
      Constructor<?> constructor = rendererClass.getConstructor(new Class[] {});
      PGraphics pg = (PGraphics) constructor.newInstance();

      pg.setParent(this);
      pg.setPrimary(iprimary);
      if (ipath != null)
        pg.setPath(ipath);
      pg.setSize(iwidth, iheight);

      // everything worked, return it
      return pg;

    } catch (InvocationTargetException ite) {
      String msg = ite.getTargetException().getMessage();
      if ((msg != null) && (msg.indexOf("no jogl in java.library.path") != -1)) {
        throw new RuntimeException(openglError
            + " (The native library is missing.)");

      } else {
        ite.getTargetException().printStackTrace();
        Throwable target = ite.getTargetException();
        if (platform == MACOSX)
          target.printStackTrace(System.out); // bug
        // neither of these help, or work
        //target.printStackTrace(System.err);
        //System.err.flush();
        //System.out.println(System.err);  // and the object isn't null
        throw new RuntimeException(target.getMessage());
      }

    } catch (ClassNotFoundException cnfe) {
      if (cnfe.getMessage().indexOf("processing.opengl.PGraphicsGL") != -1) {
        throw new RuntimeException(openglError
            + " (The library .jar file is missing.)");
      } else {
        throw new RuntimeException("You need to use \"Import Library\" "
            + "to add " + irenderer + " to your sketch.");
      }

    } catch (Exception e) {
      //System.out.println("ex3");
      if ((e instanceof IllegalArgumentException)
          || (e instanceof NoSuchMethodException)
          || (e instanceof IllegalAccessException)) {
        e.printStackTrace();
        /*
         * String msg = "private " +
         * irenderer.substring(irenderer.lastIndexOf('.') + 1) +
         * "(int width, int height, PApplet parent" + ((ipath == null) ? "" :
         * ", String filename") + ") does not exist.";
         */
        String msg = irenderer + " needs to be updated "
            + "for the current release of Processing.";
        throw new RuntimeException(msg);

      } else {
        if (platform == MACOSX)
          e.printStackTrace(System.out);
        throw new RuntimeException(e.getMessage());
      }
    }
  }

  /**
   * ( begin auto-generated from createImage.xml )
   * 
   * Creates a new PImage (the datatype for storing images). This provides a
   * fresh buffer of pixels to play with. Set the size of the buffer with the
   * <b>width</b> and <b>height</b> parameters. The <b>format</b> parameter
   * defines how the pixels are stored. See the PImage reference for more
   * information. <br/>
   * <br/>
   * Be sure to include all three parameters, specifying only the width and
   * height (but no format) will produce a strange error. <br/>
   * <br/>
   * Advanced users please note that createImage() should be used instead of the
   * syntax <tt>new PImage()</tt>.
   * 
   * ( end auto-generated ) <h3>Advanced</h3> Preferred method of creating new
   * PImage objects, ensures that a reference to the parent PApplet is included,
   * which makes save() work without needing an absolute path.
   * 
   * @webref image
   * @param wide
   *          width in pixels
   * @param high
   *          height in pixels
   * @param format
   *          Either RGB, ARGB, ALPHA (grayscale alpha channel)
   * @see PImage#PImage
   * @see PGraphics#PGraphics
   */
  private PImage createImage(int wide, int high, int format) {
    return createImage(wide, high, format, null);
  }

  /**
   * @nowebref
   */
  private PImage createImage(int wide, int high, int format, Object params) {
    PImage image = new PImage(wide, high, format);
    if (params != null) {
      image.setParams(g, params);
    }
    image.parent = this; // make save() work
    return image;
  }

  // . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

  public void update(Graphics screen) {
    paint(screen);
  }

  public void paint(Graphics screen) {
//    int r = (int) random(10000);
//    System.out.println("into paint " + r);
    //super.paint(screen);

    // ignore the very first call to paint, since it's coming
    // from the o.s., and the applet will soon update itself anyway.
    if (frameCount == 0) {
//      println("Skipping frame");
      // paint() may be called more than once before things
      // are finally painted to the screen and the thread gets going
      return;
    }
    // without ignoring the first call, the first several frames
    // are confused because paint() gets called in the midst of
    // the initial nextFrame() call, so there are multiple
    // updates fighting with one another.

    // make sure the screen is visible and usable
    // (also prevents over-drawing when using PGraphicsOpenGL)

    /*
     * the 1.5.x version if (g != null) { // added synchronization for 0194
     * because of flicker issues with JAVA2D //
     * http://code.google.com/p/processing/issues/detail?id=558 // g.image is
     * synchronized so that draw/loop and paint don't // try to fight over it.
     * this was causing a randomized slowdown // that would cut the frameRate
     * into a third on macosx, // and is probably related to the windows
     * sluggishness bug too if (g.image != null) {
     * System.out.println("ui paint"); synchronized (g.image) {
     * screen.drawImage(g.image, 0, 0, null); } } }
     */
    // the 1.2.1 version
    if ((g != null) && (g.image != null)) {
//      println("inside paint(), screen.drawImage()");
      screen.drawImage(g.image, 0, 0, null);
    }
  }

  // active paint method
  protected void paint() {
    try {
      Graphics screen = this.getGraphics();
      if (screen != null) {
        if ((g != null) && (g.image != null)) {
          screen.drawImage(g.image, 0, 0, null);
        }
        Toolkit.getDefaultToolkit().sync();
      }
    } catch (Exception e) {
      // Seen on applet destroy, maybe can ignore?
      e.printStackTrace();

//    } finally {
//      if (g != null) {
//        g.dispose();
//      }
    }
  }

  //////////////////////////////////////////////////////////////

  private Graphics getGraphics() {
    return null;
  }

  //synchronized private void handleDisplay() {
  private void handleDraw() {
    if (g != null && (looping || redraw)) {
      if (!g.canDraw()) {
        // Don't draw if the renderer is not yet ready.
        // (e.g. OpenGL has to wait for a peer to be on screen)
        return;
      }

      g.beginDraw();
      if (recorder != null) {
        recorder.beginDraw();
      }

      long now = System.nanoTime();

      if (frameCount == 0) {
        try {
          //println("Calling setup()");
          setup();
          //println("Done with setup()");

        } catch (RendererChangeException e) {
          // Give up, instead set the new renderer and re-attempt setup()
          return;
        }

      } else { // frameCount > 0, meaning an actual draw()
        // update the current frameRate
        double rate = 1000000.0 / ((now - frameRateLastNanos) / 1000000.0);
        float instantaneousRate = (float) rate / 1000.0f;
        frameRate = (frameRate * 0.9f) + (instantaneousRate * 0.1f);

        if (frameCount != 0) {
          preMethods.handle();
        }

        //println("Calling draw()");
        draw();
        //println("Done calling draw()");

//        // dmouseX/Y is updated only once per frame (unlike emouseX/Y)
//        dmouseX = mouseX;
//        dmouseY = mouseY;

        // these are called *after* loop so that valid
        // drawing commands can be run inside them. it can't
        // be before, since a call to background() would wipe
        // out anything that had been drawn so far.
        //dequeueMouseEvents();
        //dequeueKeyEvents();

        drawMethods.handle();

        redraw = false; // unset 'redraw' flag in case it was set
        // (only do this once draw() has run, not just setup())

      }

      g.endDraw();

      if (recorder != null) {
        recorder.endDraw();
      }

      frameRateLastNanos = now;
      frameCount++;

      paint(); // back to active paint
//      repaint();
//      getToolkit().sync();  // force repaint now (proper method)

      if (frameCount != 0) {
        postMethods.handle();
      }
    }
  }

  //////////////////////////////////////////////////////////////

  /**
   * ( begin auto-generated from redraw.xml )
   * 
   * Executes the code within <b>draw()</b> one time. This functions allows the
   * program to update the display window only when necessary, for example when
   * an event registered by <b>mousePressed()</b> or <b>keyPressed()</b> occurs. <br/>
   * <br/>
   * structuring a program, it only makes sense to call redraw() within events
   * such as <b>mousePressed()</b>. This is because <b>redraw()</b> does not run
   * <b>draw()</b> immediately (it only sets a flag that indicates an update is
   * needed). <br/>
   * <br/>
   * <b>redraw()</b> within <b>draw()</b> has no effect because <b>draw()</b> is
   * continuously called anyway.
   * 
   * ( end auto-generated )
   * 
   * @webref structure
   * @usage web_application
   * @see PApplet#noLoop()
   * @see PApplet#loop()
   */
  synchronized private void redraw() {
    if (!looping) {
      redraw = true;
//      if (thread != null) {
//        // wake from sleep (necessary otherwise it'll be
//        // up to 10 seconds before update)
//        if (CRUSTY_THREADS) {
//          thread.interrupt();
//        } else {
//          synchronized (blocker) {
//            blocker.notifyAll();
//          }
//        }
//      }
    }
  }

  static String openLauncher;

  /**
   * Function for an applet/application to kill itself and display an error.
   * Mostly this is here to be improved later.
   */
  private void die(String what) {
    dispose();
    throw new RuntimeException(what);
  }

  /**
   * Same as above but with an exception. Also needs work.
   */
  private void die(String what, Exception e) {
    if (e != null)
      e.printStackTrace();
    die(what);
  }

  /**
   * ( begin auto-generated from exit.xml )
   * 
   * Quits/stops/exits the program. Programs without a <b>draw()</b> function
   * exit automatically after the last line has run, but programs with
   * <b>draw()</b> run continuously until the program is manually stopped or
   * <b>exit()</b> is run.<br />
   * <br />
   * Rather than terminating immediately, <b>exit()</b> will cause the sketch to
   * exit after <b>draw()</b> has completed (or after <b>setup()</b> completes
   * if called during the <b>setup()</b> function).<br />
   * <br />
   * For Java programmers, this is <em>not</em> the same as System.exit().
   * Further, System.exit() should not be used because closing out an
   * application while <b>draw()</b> is running may cause a crash (particularly
   * with P3D).
   * 
   * ( end auto-generated )
   * 
   * @webref structure
   */
  private void exit() {
    if (thread == null) {
      // exit immediately, dispose() has already been called,
      // meaning that the main thread has long since exited
      exitActual();

    } else if (looping) {
      // dispose() will be called as the thread exits
      finished = true;
      // tell the code to call exit2() to do a System.exit()
      // once the next draw() has completed
      exitCalled = true;

    } else if (!looping) {
      // if not looping, shut down things explicitly,
      // because the main thread will be sleeping
      dispose();

      // now get out
      exitActual();
    }
  }

  void exitActual() {
    try {
      System.exit(0);
    } catch (SecurityException e) {
      // don't care about applet security exceptions
    }
  }

  /**
   * Called to dispose of resources and shut down the sketch. Destroys the
   * thread, dispose the renderer,and notify listeners.
   * <p>
   * Not to be called or overriden by users. If called multiple times, will only
   * notify listeners once. Register a dispose listener instead.
   */
  private void dispose() {
    // moved here from stop()
    finished = true; // let the sketch know it is shut down time

    // don't run the disposers twice
    if (thread == null)
      return;
    thread = null;

    // shut down renderer
    if (g != null)
      g.dispose();
    disposeMethods.handle();
  }

  //////////////////////////////////////////////////////////////

  /**
   * Check a string for #### signs to see if the frame number should be
   * inserted. Used for functions like saveFrame() and beginRecord() to replace
   * the # marks with the frame number. If only one # is used, it will be
   * ignored, under the assumption that it's probably not intended to be the
   * frame number.
   */
  protected String insertFrame(String what) {
    int first = what.indexOf('#');
    int last = what.lastIndexOf('#');

    if ((first != -1) && (last - first > 0)) {
      String prefix = what.substring(0, first);
      int count = last - first + 1;
      String suffix = what.substring(last + 1);
      return prefix + nf(frameCount, count) + suffix;
    }
    return what; // no change
  }

  //////////////////////////////////////////////////////////////

  // CURSOR

  //

  int cursorType = ARROW; // cursor type

  boolean cursorVisible = true; // cursor visibility flag

  PImage invisibleCursor;

  static private void print(String what) {
    System.out.print(what);
    System.out.flush();
  }

  static void println(String what) {
    print(what);
    System.out.println();
  }

  /**
   * ( begin auto-generated from sq.xml )
   * 
   * Squares a number (multiplies a number by itself). The result is always a
   * positive number, as multiplying two negative numbers always yields a
   * positive result. For example, -1 * -1 = 1.
   * 
   * ( end auto-generated )
   * 
   * @webref math:calculation
   * @param a
   *          number to square
   * @see PApplet#sqrt(float)
   */
  static private final float sq(float a) {
    return a * a;
  }

  /**
   * ( begin auto-generated from sqrt.xml )
   * 
   * Calculates the square root of a number. The square root of a number is
   * always positive, even though there may be a valid negative root. The square
   * root <b>s</b> of number <b>a</b> is such that <b>s*s = a</b>. It is the
   * opposite of squaring.
   * 
   * ( end auto-generated )
   * 
   * @webref math:calculation
   * @param a
   *          non-negative number
   * @see PApplet#pow(float, float)
   * @see PApplet#sq(float)
   */
  static final float sqrt(float a) {
    return (float) Math.sqrt(a);
  }

  /**
   * ( begin auto-generated from pow.xml )
   * 
   * Facilitates exponential expressions. The <b>pow()</b> function is an
   * efficient way of multiplying numbers by themselves (or their reciprocal) in
   * large quantities. For example, <b>pow(3, 5)</b> is equivalent to the
   * expression 3*3*3*3*3 and <b>pow(3, -5)</b> is equivalent to 1 / 3*3*3*3*3.
   * 
   * ( end auto-generated )
   * 
   * @webref math:calculation
   * @param a
   *          base of the exponential expression
   * @param b
   *          power of which to raise the base
   * @see PApplet#sqrt(float)
   */
  public static final float pow(float a, float b) {
    return (float) Math.pow(a, b);
  }

  static final float max(float a, float b, float c) {
    return (a > b) ? ((a > c) ? a : c) : ((b > c) ? b : c);
  }

  /**
   * Find the maximum value in an array. Throws an
   * ArrayIndexOutOfBoundsException if the array is length 0.
   * 
   * @param list
   *          the source array
   * @return The maximum value
   */
  /*
   * static private final double max(double[] list) { if (list.length == 0) {
   * throw new ArrayIndexOutOfBoundsException(ERROR_MIN_MAX); } double max =
   * list[0]; for (int i = 1; i < list.length; i++) { if (list[i] > max) max =
   * list[i]; } return max; }
   */

  static final int min(int a, int b) {
    return (a < b) ? a : b;
  }

  /**
   * ( begin auto-generated from sin.xml )
   * 
   * Calculates the sine of an angle. This function expects the values of the
   * <b>angle</b> parameter to be provided in radians (values from 0 to 6.28).
   * Values are returned in the range -1 to 1.
   * 
   * ( end auto-generated )
   * 
   * @webref math:trigonometry
   * @param angle
   *          an angle in radians
   * @see PApplet#cos(float)
   * @see PApplet#tan(float)
   * @see PApplet#radians(float)
   */
  public static final float sin(float angle) {
    return (float) Math.sin(angle);
  }

  /**
   * ( begin auto-generated from cos.xml )
   * 
   * Calculates the cosine of an angle. This function expects the values of the
   * <b>angle</b> parameter to be provided in radians (values from 0 to PI*2).
   * Values are returned in the range -1 to 1.
   * 
   * ( end auto-generated )
   * 
   * @webref math:trigonometry
   * @param angle
   *          an angle in radians
   * @see PApplet#sin(float)
   * @see PApplet#tan(float)
   * @see PApplet#radians(float)
   */
  public static final float cos(float angle) {
    return (float) Math.cos(angle);
  }

  /**
   * ( begin auto-generated from tan.xml )
   * 
   * Calculates the ratio of the sine and cosine of an angle. This function
   * expects the values of the <b>angle</b> parameter to be provided in radians
   * (values from 0 to PI*2). Values are returned in the range <b>infinity</b>
   * to <b>-infinity</b>.
   * 
   * ( end auto-generated )
   * 
   * @webref math:trigonometry
   * @param angle
   *          an angle in radians
   * @see PApplet#cos(float)
   * @see PApplet#sin(float)
   * @see PApplet#radians(float)
   */
  static final float tan(float angle) {
    return (float) Math.tan(angle);
  }

  /**
   * ( begin auto-generated from radians.xml )
   * 
   * Converts a degree measurement to its corresponding value in radians.
   * Radians and degrees are two ways of measuring the same thing. There are 360
   * degrees in a circle and 2*PI radians in a circle. For example, 90&deg; =
   * PI/2 = 1.5707964. All trigonometric functions in Processing require their
   * parameters to be specified in radians.
   * 
   * ( end auto-generated )
   * 
   * @webref math:trigonometry
   * @param degrees
   *          degree value to convert to radians
   * @see PApplet#degrees(float)
   */
  public static final float radians(float degrees) {
    return degrees * DEG_TO_RAD;
  }

  /**
   * ( begin auto-generated from floor.xml )
   * 
   * Calculates the closest int value that is less than or equal to the value of
   * the parameter.
   * 
   * ( end auto-generated )
   * 
   * @webref math:calculation
   * @param what
   *          number to round down
   * @see PApplet#ceil(float)
   * @see PApplet#round(float)
   */
  static final int floor(float what) {
    return (int) Math.floor(what);
  }

  /**
   * ( begin auto-generated from round.xml )
   * 
   * Calculates the integer closest to the <b>value</b> parameter. For example,
   * <b>round(9.2)</b> returns the value 9.
   * 
   * ( end auto-generated )
   * 
   * @webref math:calculation
   * @param what
   *          number to round
   * @see PApplet#floor(float)
   * @see PApplet#ceil(float)
   */
  public static final int round(float what) {
    return Math.round(what);
  }

  static final float dist(float x1, float y1, float x2, float y2) {
    return sqrt(sq(x2 - x1) + sq(y2 - y1));
  }

  /**
   * ( begin auto-generated from lerp.xml )
   * 
   * Calculates a number between two numbers at a specific increment. The
   * <b>amt</b> parameter is the amount to interpolate between the two values
   * where 0.0 equal to the first point, 0.1 is very near the first point, 0.5
   * is half-way in between, etc. The lerp function is convenient for creating
   * motion along a straight path and for drawing dotted lines.
   * 
   * ( end auto-generated )
   * 
   * @webref math:calculation
   * @param start
   *          first value
   * @param stop
   *          second value
   * @param amt
   *          float between 0.0 and 1.0
   * @see PGraphics#curvePoint(float, float, float, float, float)
   * @see PGraphics#bezierPoint(float, float, float, float, float)
   */
  public static final float lerp(float start, float stop, float amt) {
    return start + (stop - start) * amt;
  }

  /**
   * ( begin auto-generated from norm.xml )
   * 
   * Normalizes a number from another range into a value between 0 and 1. <br/>
   * <br/>
   * Identical to map(value, low, high, 0, 1); <br/>
   * <br/>
   * Numbers outside the range are not clamped to 0 and 1, because out-of-range
   * values are often intentional and useful.
   * 
   * ( end auto-generated )
   * 
   * @webref math:calculation
   * @param value
   *          the incoming value to be converted
   * @param start
   *          lower bound of the value's current range
   * @param stop
   *          upper bound of the value's current range
   * @see PApplet#map(float, float, float, float, float)
   * @see PApplet#lerp(float, float, float)
   */
  public static final float norm(float value, float start, float stop) {
    return (value - start) / (stop - start);
  }

  /**
   * ( begin auto-generated from map.xml )
   * 
   * Re-maps a number from one range to another. In the example above, the
   * number '25' is converted from a value in the range 0..100 into a value that
   * ranges from the left edge (0) to the right edge (width) of the screen. <br/>
   * <br/>
   * Numbers outside the range are not clamped to 0 and 1, because out-of-range
   * values are often intentional and useful.
   * 
   * ( end auto-generated )
   * 
   * @webref math:calculation
   * @param value
   *          the incoming value to be converted
   * @param istart
   *          lower bound of the value's current range
   * @param istop
   *          upper bound of the value's current range
   * @param ostart
   *          lower bound of the value's target range
   * @param ostop
   *          upper bound of the value's target range
   * @see PApplet#norm(float, float, float)
   * @see PApplet#lerp(float, float, float)
   */
  public static final float map(float value, float istart, float istop,
                                float ostart, float ostop) {
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
  }

  /*
   * static private final double map(double value, double istart, double istop,
   * double ostart, double ostop) { return ostart + (ostop - ostart) * ((value -
   * istart) / (istop - istart)); }
   */

  //////////////////////////////////////////////////////////////

  // RANDOM NUMBERS

  Random internalRandom;

  /**
   * 
   */
  public final float random(float howbig) {
    // for some reason (rounding error?) Math.random() * 3
    // can sometimes return '3' (once in ~30 million tries)
    // so a check was added to avoid the inclusion of 'howbig'

    // avoid an infinite loop
    if (howbig == 0)
      return 0;

    // internal random number object
    if (internalRandom == null)
      internalRandom = new Random();

    float value = 0;
    do {
      //value = (float)Math.random() * howbig;
      value = internalRandom.nextFloat() * howbig;
    } while (value == howbig);
    return value;
  }

  /**
   * ( begin auto-generated from random.xml )
   * 
   * Generates random numbers. Each time the <b>random()</b> function is called,
   * it returns an unexpected value within the specified range. If one parameter
   * is passed to the function it will return a <b>float</b> between zero and
   * the value of the <b>high</b> parameter. The function call <b>random(5)</b>
   * returns values between 0 and 5 (starting at zero, up to but not including
   * 5). If two parameters are passed, it will return a <b>float</b> with a
   * value between the the parameters. The function call <b>random(-5, 10.2)</b>
   * returns values starting at -5 up to (but not including) 10.2. To convert a
   * floating-point random number to an integer, use the <b>int()</b> function.
   * 
   * ( end auto-generated )
   * 
   * @webref math:random
   * @param howsmall
   *          lower limit
   * @param howbig
   *          upper limit
   * @see PApplet#randomSeed(long)
   * @see PApplet#noise(float, float, float)
   */
  public final float random(float howsmall, float howbig) {
    if (howsmall >= howbig)
      return howsmall;
    float diff = howbig - howsmall;
    return random(diff) + howsmall;
  }

  static final int PERLIN_YWRAPB = 4;

  static final int PERLIN_YWRAP = 1 << PERLIN_YWRAPB;

  static final int PERLIN_ZWRAPB = 8;

  static final int PERLIN_ZWRAP = 1 << PERLIN_ZWRAPB;

  static final int PERLIN_SIZE = 4095;

  int perlin_octaves = 4; // default to medium smooth

  float perlin_amp_falloff = 0.5f; // 50% reduction/octave

  // [toxi 031112]
  // new vars needed due to recent change of cos table in PGraphics
  int perlin_TWOPI, perlin_PI;

  float[] perlin_cosTable;

  float[] perlin;

  Random perlinRandom;

  protected String[] loadImageFormats;

  /**
   * @param extension
   *          the type of image to load, for example "png", "gif", "jpg"
   */
  private PImage loadImage(String filename, String extension) {
    return loadImage(filename, extension, null);
  }

  /**
   * @nowebref
   */
  private PImage loadImage(String filename, String extension, Object params) {
    if (extension == null) {
      String lower = filename.toLowerCase();
      int dot = filename.lastIndexOf('.');
      if (dot == -1) {
        extension = "unknown"; // no extension found
      }
      extension = lower.substring(dot + 1);

      // check for, and strip any parameters on the url, i.e.
      // filename.jpg?blah=blah&something=that
      int question = extension.indexOf('?');
      if (question != -1) {
        extension = extension.substring(0, question);
      }
    }

    // just in case. them users will try anything!
    extension = extension.toLowerCase();

    if (extension.equals("tga")) {
      try {
        PImage image = loadImageTGA(filename);
        if (params != null) {
          image.setParams(g, params);
        }
        return image;
      } catch (IOException e) {
        e.printStackTrace();
        return null;
      }
    }

    if (extension.equals("tif") || extension.equals("tiff")) {
      byte bytes[] = loadBytes(filename);
      PImage image = (bytes == null) ? null : PImage.loadTIFF(bytes);
      if (params != null) {
        image.setParams(g, params);
      }
      return image;
    }

    // For jpeg, gif, and png, load them using createImage(),
    // because the javax.imageio code was found to be much slower, see
    // <A HREF="http://dev.processing.org/bugs/show_bug.cgi?id=392">Bug 392</A>.
    try {
      if (extension.equals("jpg") || extension.equals("jpeg")
          || extension.equals("gif") || extension.equals("png")
          || extension.equals("unknown")) {
        byte bytes[] = loadBytes(filename);
        if (bytes == null) {
          return null;
        } else {
          Image awtImage = Toolkit.getDefaultToolkit().createImage(bytes);
          PImage image = loadImageMT(awtImage);
          if (image.width == -1) {
            System.err.println("The file " + filename
                + " contains bad image data, or may not be an image.");
          }
          // if it's a .gif image, test to see if it has transparency
          if (extension.equals("gif") || extension.equals("png")) {
            image.checkAlpha();
          }

          if (params != null) {
            image.setParams(g, params);
          }
          return image;
        }
      }
    } catch (Exception e) {
      // show error, but move on to the stuff below, see if it'll work
      e.printStackTrace();
    }

    if (loadImageFormats == null) {
      loadImageFormats = ImageIO.getReaderFormatNames();
    }
    if (loadImageFormats != null) {
      for (int i = 0; i < loadImageFormats.length; i++) {
        if (extension.equals(loadImageFormats[i])) {
          PImage image;
          image = loadImageIO(filename);
          if (params != null) {
            image.setParams(g, params);
          }
          return image;
        }
      }
    }

    // failed, could not load image after all those attempts
    System.err.println("Could not find a method to load " + filename);
    return null;
  }

  /**
   * By trial and error, four image loading threads seem to work best when
   * loading images from online. This is consistent with the number of open
   * connections that web browsers will maintain. The variable is made public
   * (however no accessor has been added since it's esoteric) if you really want
   * to have control over the value used. For instance, when loading local
   * files, it might be better to only have a single thread (or two) loading
   * images so that you're disk isn't simply jumping around.
   */
  private int requestImageMax = 4;

  volatile int requestImageCount;

  class AsyncImageLoader extends Thread {
    String filename;

    String extension;

    PImage vessel;

    private AsyncImageLoader(String filename, String extension, PImage vessel) {
      this.filename = filename;
      this.extension = extension;
      this.vessel = vessel;
    }

    public void run() {
      while (requestImageCount == requestImageMax) {
        try {
          Thread.sleep(10);
        } catch (InterruptedException e) {
        }
      }
      requestImageCount++;

      PImage actual = loadImage(filename, extension);

      // An error message should have already printed
      if (actual == null) {
        vessel.width = -1;
        vessel.height = -1;

      } else {
        vessel.width = actual.width;
        vessel.height = actual.height;
        vessel.format = actual.format;
        vessel.pixels = actual.pixels;
      }
      requestImageCount--;
    }
  }

  /**
   * Load an AWT image synchronously by setting up a MediaTracker for a single
   * image, and blocking until it has loaded.
   */
  protected PImage loadImageMT(Image awtImage) {
//    MediaTracker tracker = new MediaTracker(this);
//    tracker.addImage(awtImage, 0);
//    try {
//      tracker.waitForAll();
//    } catch (InterruptedException e) {
//      //e.printStackTrace();  // non-fatal, right?
//    }

    PImage image = new PImage(awtImage);
    image.parent = this;
    return image;
  }

  /**
   * Use Java 1.4 ImageIO methods to load an image.
   */
  protected PImage loadImageIO(String filename) {
    InputStream stream = createInput(filename);
    if (stream == null) {
      System.err.println("The image " + filename + " could not be found.");
      return null;
    }

    try {
      BufferedImage bi = ImageIO.read(stream);
      PImage outgoing = new PImage(bi.getWidth(), bi.getHeight());
      outgoing.parent = this;

      bi.getRGB(0, 0, outgoing.width, outgoing.height, outgoing.pixels, 0,
                outgoing.width);

      // check the alpha for this image
      // was gonna call getType() on the image to see if RGB or ARGB,
      // but it's not actually useful, since gif images will come through
      // as TYPE_BYTE_INDEXED, which means it'll still have to check for
      // the transparency. also, would have to iterate through all the other
      // types and guess whether alpha was in there, so.. just gonna stick
      // with the old method.
      outgoing.checkAlpha();

      // return the image
      return outgoing;

    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  /**
   * Targa image loader for RLE-compressed TGA files.
   * <p>
   * Rewritten for 0115 to read/write RLE-encoded targa images. For 0125,
   * non-RLE encoded images are now supported, along with images whose y-order
   * is reversed (which is standard for TGA files).
   */
  protected PImage loadImageTGA(String filename) throws IOException {
    InputStream is = createInput(filename);
    if (is == null)
      return null;

    byte header[] = new byte[18];
    int offset = 0;
    do {
      int count = is.read(header, offset, header.length - offset);
      if (count == -1)
        return null;
      offset += count;
    } while (offset < 18);

    /*
     * header[2] image type code 2 (0x02) - Uncompressed, RGB images. 3 (0x03) -
     * Uncompressed, black and white images. 10 (0x0A) - Runlength encoded RGB
     * images. 11 (0x0B) - Compressed, black and white images. (grayscale?)
     * 
     * header[16] is the bit depth (8, 24, 32)
     * 
     * header[17] image descriptor (packed bits) 0x20 is 32 = origin upper-left
     * 0x28 is 32 + 8 = origin upper-left + 32 bits
     * 
     * 7 6 5 4 3 2 1 0 128 64 32 16 8 4 2 1
     */

    int format = 0;

    if (((header[2] == 3) || (header[2] == 11)) && // B&W, plus RLE or not
        (header[16] == 8) && // 8 bits
        ((header[17] == 0x8) || (header[17] == 0x28))) { // origin, 32 bit
      format = ALPHA;

    } else if (((header[2] == 2) || (header[2] == 10)) && // RGB, RLE or not
        (header[16] == 24) && // 24 bits
        ((header[17] == 0x20) || (header[17] == 0))) { // origin
      format = RGB;

    } else if (((header[2] == 2) || (header[2] == 10)) && (header[16] == 32)
        && ((header[17] == 0x8) || (header[17] == 0x28))) { // origin, 32
      format = ARGB;
    }

    if (format == 0) {
      System.err.println("Unknown .tga file format for " + filename);
      //" (" + header[2] + " " +
      //(header[16] & 0xff) + " " +
      //hex(header[17], 2) + ")");
      return null;
    }

    int w = ((header[13] & 0xff) << 8) + (header[12] & 0xff);
    int h = ((header[15] & 0xff) << 8) + (header[14] & 0xff);
    PImage outgoing = createImage(w, h, format);

    // where "reversed" means upper-left corner (normal for most of
    // the modernized world, but "reversed" for the tga spec)
    boolean reversed = (header[17] & 0x20) != 0;

    if ((header[2] == 2) || (header[2] == 3)) { // not RLE encoded
      if (reversed) {
        int index = (h - 1) * w;
        switch (format) {
        case ALPHA:
          for (int y = h - 1; y >= 0; y--) {
            for (int x = 0; x < w; x++) {
              outgoing.pixels[index + x] = is.read();
            }
            index -= w;
          }
          break;
        case RGB:
          for (int y = h - 1; y >= 0; y--) {
            for (int x = 0; x < w; x++) {
              outgoing.pixels[index + x] = is.read() | (is.read() << 8)
                  | (is.read() << 16) | 0xff000000;
            }
            index -= w;
          }
          break;
        case ARGB:
          for (int y = h - 1; y >= 0; y--) {
            for (int x = 0; x < w; x++) {
              outgoing.pixels[index + x] = is.read() | (is.read() << 8)
                  | (is.read() << 16) | (is.read() << 24);
            }
            index -= w;
          }
        }
      } else { // not reversed
        int count = w * h;
        switch (format) {
        case ALPHA:
          for (int i = 0; i < count; i++) {
            outgoing.pixels[i] = is.read();
          }
          break;
        case RGB:
          for (int i = 0; i < count; i++) {
            outgoing.pixels[i] = is.read() | (is.read() << 8)
                | (is.read() << 16) | 0xff000000;
          }
          break;
        case ARGB:
          for (int i = 0; i < count; i++) {
            outgoing.pixels[i] = is.read() | (is.read() << 8)
                | (is.read() << 16) | (is.read() << 24);
          }
          break;
        }
      }

    } else { // header[2] is 10 or 11
      int index = 0;
      int px[] = outgoing.pixels;

      while (index < px.length) {
        int num = is.read();
        boolean isRLE = (num & 0x80) != 0;
        if (isRLE) {
          num -= 127; // (num & 0x7F) + 1
          int pixel = 0;
          switch (format) {
          case ALPHA:
            pixel = is.read();
            break;
          case RGB:
            pixel = 0xFF000000 | is.read() | (is.read() << 8)
                | (is.read() << 16);
            //(is.read() << 16) | (is.read() << 8) | is.read();
            break;
          case ARGB:
            pixel = is.read() | (is.read() << 8) | (is.read() << 16)
                | (is.read() << 24);
            break;
          }
          for (int i = 0; i < num; i++) {
            px[index++] = pixel;
            if (index == px.length)
              break;
          }
        } else { // write up to 127 bytes as uncompressed
          num += 1;
          switch (format) {
          case ALPHA:
            for (int i = 0; i < num; i++) {
              px[index++] = is.read();
            }
            break;
          case RGB:
            for (int i = 0; i < num; i++) {
              px[index++] = 0xFF000000 | is.read() | (is.read() << 8)
                  | (is.read() << 16);
              //(is.read() << 16) | (is.read() << 8) | is.read();
            }
            break;
          case ARGB:
            for (int i = 0; i < num; i++) {
              px[index++] = is.read() | //(is.read() << 24) |
                  (is.read() << 8) | (is.read() << 16) | (is.read() << 24);
              //(is.read() << 16) | (is.read() << 8) | is.read();
            }
            break;
          }
        }
      }

      if (!reversed) {
        int[] temp = new int[w];
        for (int y = 0; y < h / 2; y++) {
          int z = (h - 1) - y;
          System.arraycopy(px, y * w, temp, 0, w);
          System.arraycopy(px, z * w, px, y * w, w);
          System.arraycopy(temp, 0, px, z * w, w);
        }
      }
    }

    return outgoing;
  }

  //////////////////////////////////////////////////////////////

  // SHAPE CREATION

  protected String[] loadShapeFormats;

  /**
   * Creates an empty shape, with the specified size and parameters. The actual
   * type will depend on the renderer.
   */
  XML loadXML(String filename) {
    return new XML(this, filename);
  }

//  private PData loadData(String filename) {
//    if (filename.toLowerCase().endsWith(".json")) {
//      return new PData(this, filename);
//    } else {
//      throw new RuntimeException("filename used for loadNode() must end with XML");
//    }
//  }

  //////////////////////////////////////////////////////////////

  // FONT I/O

  /**
   * Used by PGraphics to remove the requirement for loading a font!
   */
  protected PFont createDefaultFont(float size) {
//    Font f = new Font("SansSerif", Font.PLAIN, 12);
//    println("n: " + f.getName());
//    println("fn: " + f.getFontName());
//    println("ps: " + f.getPSName());
    return createFont("Lucida Sans", size, true, null);
  }

  public PFont createFont(String name, float size) {
    return createFont(name, size, true, null);
  }

  /**
   * ( begin auto-generated from createFont.xml )
   * 
   * Dynamically converts a font to the format used by Processing from either a
   * font name that's installed on the computer, or from a .ttf or .otf file
   * inside the sketches "data" folder. This function is an advanced feature for
   * precise control. On most occasions you should create fonts through
   * selecting "Create Font..." from the Tools menu. <br />
   * <br />
   * Use the <b>PFont.list()</b> method to first determine the names for the
   * fonts recognized by the computer and are compatible with this function.
   * Because of limitations in Java, not all fonts can be used and some might
   * work with one operating system and not others. When sharing a sketch with
   * other people or posting it on the web, you may need to include a .ttf or
   * .otf version of your font in the data directory of the sketch because other
   * people might not have the font installed on their computer. Only fonts that
   * can legally be distributed should be included with a sketch. <br />
   * <br />
   * The <b>size</b> parameter states the font size you want to generate. The
   * <b>smooth</b> parameter specifies if the font should be antialiased or not,
   * and the <b>charset</b> parameter is an array of chars that specifies the
   * characters to generate. <br />
   * <br />
   * This function creates a bitmapped version of a font in the same manner as
   * the Create Font tool. It loads a font by name, and converts it to a series
   * of images based on the size of the font. When possible, the <b>text()</b>
   * function will use a native font rather than the bitmapped version created
   * behind the scenes with <b>createFont()</b>. For instance, when using P2D,
   * the actual native version of the font will be employed by the sketch,
   * improving drawing quality and performance. With the P3D renderer, the
   * bitmapped version will be used. While this can drastically improve speed
   * and appearance, results are poor when exporting if the sketch does not
   * include the .otf or .ttf file, and the requested font is not available on
   * the machine running the sketch.
   * 
   * ( end auto-generated )
   * 
   * @webref typography:loading_displaying
   * @param name
   *          name of the font to load
   * @param size
   *          point size of the font
   * @param smooth
   *          true for an antialiased font, false for aliased
   * @param charset
   *          array containing characters to be generated
   * @see PFont#PFont
   * @see PGraphics#textFont(PFont, float)
   * @see PGraphics#text(String, float, float, float, float, float)
   * @see PApplet#loadFont(String)
   */
  private PFont createFont(String name, float size, boolean smooth,
                           char charset[]) {
    String lowerName = name.toLowerCase();
    Font baseFont = null;

    try {
      InputStream stream = null;
      if (lowerName.endsWith(".otf") || lowerName.endsWith(".ttf")) {
        stream = createInput(name);
        if (stream == null) {
          System.err.println("The font \"" + name + "\" "
              + "is missing or inaccessible, make sure "
              + "the URL is valid or that the file has been "
              + "added to your sketch and is readable.");
          return null;
        }
        baseFont = Font.createFont(Font.TRUETYPE_FONT, createInput(name));

      } else {
        baseFont = PFont.findFont(name);
      }
      return new PFont(baseFont.deriveFont(size), smooth, charset,
                       stream != null);

    } catch (Exception e) {
      System.err.println("Problem createFont(" + name + ")");
      e.printStackTrace();
      return null;
    }
  }

  //////////////////////////////////////////////////////////////

  // FILE/FOLDER SELECTION

  protected Frame parentFrame;

  /**
   * ( begin auto-generated from createReader.xml )
   * 
   * Creates a <b>BufferedReader</b> object that can be used to read files
   * line-by-line as individual <b>String</b> objects. This is the complement to
   * the <b>createWriter()</b> function. <br/>
   * <br/>
   * Starting with Processing release 0134, all files loaded and saved by the
   * Processing API use UTF-8 encoding. In previous releases, the default
   * encoding for your platform was used, which causes problems when files are
   * moved to other platforms.
   * 
   * ( end auto-generated )
   * 
   * @webref input:files
   * @param filename
   *          name of the file to be opened
   * @see BufferedReader
   * @see PApplet#createWriter(String)
   * @see PrintWriter
   */
  BufferedReader createReader(String filename) {
    try {
      InputStream is = createInput(filename);
      if (is == null) {
        System.err.println(filename + " does not exist or could not be read");
        return null;
      }
      return createReader(is);

    } catch (Exception e) {
      if (filename == null) {
        System.err.println("Filename passed to reader() was null");
      } else {
        System.err.println("Couldn't create a reader for " + filename);
      }
    }
    return null;
  }

  /**
   * @nowebref
   */
  static BufferedReader createReader(File file) {
    try {
      InputStream is = new FileInputStream(file);
      if (file.getName().toLowerCase().endsWith(".gz")) {
        is = new GZIPInputStream(is);
      }
      return createReader(is);

    } catch (Exception e) {
      if (file == null) {
        throw new RuntimeException("File passed to createReader() was null");
      } else {
        e.printStackTrace();
        throw new RuntimeException("Couldn't create a reader for "
            + file.getAbsolutePath());
      }
    }
    //return null;
  }

  /**
   * @nowebref I want to read lines from a stream. If I have to type the
   *           following lines any more I'm gonna send Sun my medical bills.
   */
  static private BufferedReader createReader(InputStream input) {
    InputStreamReader isr = null;
    try {
      isr = new InputStreamReader(input, "UTF-8");
    } catch (UnsupportedEncodingException e) {
    } // not gonna happen
    return new BufferedReader(isr);
  }

  /**
   * @nowebref I want to print lines to a file. I have RSI from typing these
   *           eight lines of code so many times.
   */
  static PrintWriter createWriter(File file) {
    try {
      createPath(file); // make sure in-between folders exist
      OutputStream output = new FileOutputStream(file);
      if (file.getName().toLowerCase().endsWith(".gz")) {
        output = new GZIPOutputStream(output);
      }
      return createWriter(output);

    } catch (Exception e) {
      if (file == null) {
        throw new RuntimeException("File passed to createWriter() was null");
      } else {
        e.printStackTrace();
        throw new RuntimeException("Couldn't create a writer for "
            + file.getAbsolutePath());
      }
    }
    //return null;
  }

  /**
   * @nowebref I want to print lines to a file. Why am I always explaining
   *           myself? It's the JavaSoft API engineers who need to explain
   *           themselves.
   */
  static private PrintWriter createWriter(OutputStream output) {
    try {
      BufferedOutputStream bos = new BufferedOutputStream(output, 8192);
      OutputStreamWriter osw = new OutputStreamWriter(bos, "UTF-8");
      return new PrintWriter(osw);
    } catch (UnsupportedEncodingException e) {
    } // not gonna happen
    return null;
  }

  //////////////////////////////////////////////////////////////

  // FILE INPUT

  /**
   * ( begin auto-generated from createInput.xml )
   * 
   * This is a function for advanced programmers to open a Java InputStream.
   * It's useful if you want to use the facilities provided by PApplet to easily
   * open files from the data folder or from a URL, but want an InputStream
   * object so that you can use other parts of Java to take more control of how
   * the stream is read.<br />
   * <br />
   * The filename passed in can be:<br />
   * - A URL, for instance <b>openStream("http://processing.org/")</b><br />
   * - A file in the sketch's <b>data</b> folder<br />
   * - The full path to a file to be opened locally (when running as an
   * application)<br />
   * <br />
   * If the requested item doesn't exist, null is returned. If not online, this
   * will also check to see if the user is asking for a file whose name isn't
   * properly capitalized. If capitalization is different, an error will be
   * printed to the console. This helps prevent issues that appear when a sketch
   * is exported to the web, where case sensitivity matters, as opposed to
   * running from inside the Processing Development Environment on Windows or
   * Mac OS, where case sensitivity is preserved but ignored.<br />
   * <br />
   * If the file ends with <b>.gz</b>, the stream will automatically be gzip
   * decompressed. If you don't want the automatic decompression, use the
   * related function <b>createInputRaw()</b>. <br />
   * In earlier releases, this function was called <b>openStream()</b>.<br />
   * <br />
   * 
   * ( end auto-generated )
   * 
   * <h3>Advanced</h3> Simplified method to open a Java InputStream.
   * <p>
   * This method is useful if you want to use the facilities provided by PApplet
   * to easily open things from the data folder or from a URL, but want an
   * InputStream object so that you can use other Java methods to take more
   * control of how the stream is read.
   * <p>
   * If the requested item doesn't exist, null is returned. (Prior to 0096,
   * die() would be called, killing the applet)
   * <p>
   * For 0096+, the "data" folder is exported intact with subfolders, and
   * openStream() properly handles subdirectories from the data folder
   * <p>
   * If not online, this will also check to see if the user is asking for a file
   * whose name isn't properly capitalized. This helps prevent issues when a
   * sketch is exported to the web, where case sensitivity matters, as opposed
   * to Windows and the Mac OS default where case sensitivity is preserved but
   * ignored.
   * <p>
   * It is strongly recommended that libraries use this method to open data
   * files, so that the loading sequence is handled in the same way as functions
   * like loadBytes(), loadImage(), etc.
   * <p>
   * The filename passed in can be:
   * <UL>
   * <LI>A URL, for instance openStream("http://processing.org/");
   * <LI>A file in the sketch's data folder
   * <LI>Another file to be opened locally (when running as an application)
   * </UL>
   * 
   * @webref input:files
   * @param filename
   *          the name of the file to use as input
   * @see PApplet#createOutput(String)
   * @see PApplet#selectOutput(String)
   * @see PApplet#selectInput(String)
   * 
   */
  private InputStream createInput(String filename) {
    InputStream input = createInputRaw(filename);
    if ((input != null) && filename.toLowerCase().endsWith(".gz")) {
      try {
        return new GZIPInputStream(input);
      } catch (IOException e) {
        e.printStackTrace();
        return null;
      }
    }
    return input;
  }

  /**
   * Call openStream() without automatic gzip decompression.
   */
  private InputStream createInputRaw(String filename) {
    InputStream stream = null;

    if (filename == null)
      return null;

    if (filename.length() == 0) {
      // an error will be called by the parent function
      //System.err.println("The filename passed to openStream() was empty.");
      return null;
    }

    // safe to check for this as a url first. this will prevent online
    // access logs from being spammed with GET /sketchfolder/http://blahblah
    if (filename.indexOf(":") != -1) { // at least smells like URL
      try {
        URL url = new URL(filename);
        stream = url.openStream();
        return stream;

      } catch (MalformedURLException mfue) {
        // not a url, that's fine

      } catch (FileNotFoundException fnfe) {
        // Java 1.5 likes to throw this when URL not available. (fix for 0119)
        // http://dev.processing.org/bugs/show_bug.cgi?id=403

      } catch (IOException e) {
        // changed for 0117, shouldn't be throwing exception
        e.printStackTrace();
        //System.err.println("Error downloading from URL " + filename);
        return null;
        //throw new RuntimeException("Error downloading from URL " + filename);
      }
    }

    // Moved this earlier than the getResourceAsStream() checks, because
    // calling getResourceAsStream() on a directory lists its contents.
    // http://dev.processing.org/bugs/show_bug.cgi?id=716
    try {
      // First see if it's in a data folder. This may fail by throwing
      // a SecurityException. If so, this whole block will be skipped.
      File file = new File(dataPath(filename));
      if (!file.exists()) {
        // next see if it's just in the sketch folder
        file = new File(sketchPath, filename);
      }
      if (file.isDirectory()) {
        return null;
      }
      if (file.exists()) {
        try {
          // handle case sensitivity check
          String filePath = file.getCanonicalPath();
          String filenameActual = new File(filePath).getName();
          // make sure there isn't a subfolder prepended to the name
          String filenameShort = new File(filename).getName();
          // if the actual filename is the same, but capitalized
          // differently, warn the user.
          //if (filenameActual.equalsIgnoreCase(filenameShort) &&
          //!filenameActual.equals(filenameShort)) {
          if (!filenameActual.equals(filenameShort)) {
            throw new RuntimeException("This file is named " + filenameActual
                + " not " + filename + ". Rename the file "
                + "or change your code.");
          }
        } catch (IOException e) {
        }
      }

      // if this file is ok, may as well just load it
      stream = new FileInputStream(file);
      if (stream != null)
        return stream;

      // have to break these out because a general Exception might
      // catch the RuntimeException being thrown above
    } catch (IOException ioe) {
    } catch (SecurityException se) {
    }

    // Using getClassLoader() prevents java from converting dots
    // to slashes or requiring a slash at the beginning.
    // (a slash as a prefix means that it'll load from the root of
    // the jar, rather than trying to dig into the package location)
    ClassLoader cl = getClass().getClassLoader();

    // by default, data files are exported to the root path of the jar.
    // (not the data folder) so check there first.
    stream = cl.getResourceAsStream("data/" + filename);
    if (stream != null) {
      String cn = stream.getClass().getName();
      // this is an irritation of sun's java plug-in, which will return
      // a non-null stream for an object that doesn't exist. like all good
      // things, this is probably introduced in java 1.5. awesome!
      // http://dev.processing.org/bugs/show_bug.cgi?id=359
      if (!cn.equals("sun.plugin.cache.EmptyInputStream")) {
        return stream;
      }
    }

    // When used with an online script, also need to check without the
    // data folder, in case it's not in a subfolder called 'data'.
    // http://dev.processing.org/bugs/show_bug.cgi?id=389
    stream = cl.getResourceAsStream(filename);
    if (stream != null) {
      String cn = stream.getClass().getName();
      if (!cn.equals("sun.plugin.cache.EmptyInputStream")) {
        return stream;
      }
    }

//    // Finally, something special for the Internet Explorer users. Turns out
//    // that we can't get files that are part of the same folder using the
//    // methods above when using IE, so we have to resort to the old skool
//    // getDocumentBase() from teh applet dayz. 1996, my brotha.
//    try {
//      URL base = getDocumentBase();
//      if (base != null) {
//        URL url = new URL(base, filename);
//        URLConnection conn = url.openConnection();
//        return conn.getInputStream();
////      if (conn instanceof HttpURLConnection) {
////      HttpURLConnection httpConnection = (HttpURLConnection) conn;
////      // test for 401 result (HTTP only)
////      int responseCode = httpConnection.getResponseCode();
////    }
//      }
//    } catch (Exception e) {
//    } // IO or NPE or...
//
//    // Now try it with a 'data' subfolder. getting kinda desperate for data...
//    try {
//      URL base = getDocumentBase();
//      if (base != null) {
//        URL url = new URL(base, "data/" + filename);
//        URLConnection conn = url.openConnection();
//        return conn.getInputStream();
//      }
//    } catch (Exception e) {
//    }

    try {
      // attempt to load from a local file, used when running as
      // an application, or as a signed applet
      try { // first try to catch any security exceptions
        try {
          stream = new FileInputStream(dataPath(filename));
          if (stream != null)
            return stream;
        } catch (IOException e2) {
        }

        try {
          stream = new FileInputStream(sketchPath(filename));
          if (stream != null)
            return stream;
        } catch (Exception e) {
        } // ignored

        try {
          stream = new FileInputStream(filename);
          if (stream != null)
            return stream;
        } catch (IOException e1) {
        }

      } catch (SecurityException se) {
      } // online, whups

    } catch (Exception e) {
      //die(e.getMessage(), e);
      e.printStackTrace();
    }

    return null;
  }

  /**
   * ( begin auto-generated from loadBytes.xml )
   * 
   * Reads the contents of a file or url and places it in a byte array. If a
   * file is specified, it must be located in the sketch's "data"
   * directory/folder.<br />
   * <br />
   * The filename parameter can also be a URL to a file found online. For
   * security reasons, a Processing sketch found online can only download files
   * from the same server from which it came. Getting around this restriction
   * requires a <a href="http://wiki.processing.org/w/Sign_an_Applet">signed
   * applet</a>.
   * 
   * ( end auto-generated )
   * 
   * @webref input:files
   * @param filename
   *          name of a file in the data folder or a URL.
   * @see PApplet#loadStrings(String)
   * @see PApplet#saveStrings(String, String[])
   * @see PApplet#saveBytes(String, byte[])
   * 
   */
  private byte[] loadBytes(String filename) {
    InputStream is = createInput(filename);
    if (is != null)
      return loadBytes(is);

    System.err.println("The file \"" + filename + "\" "
        + "is missing or inaccessible, make sure "
        + "the URL is valid or that the file has been "
        + "added to your sketch and is readable.");
    return null;
  }

  /**
   * @nowebref
   */
  static private byte[] loadBytes(InputStream input) {
    try {
      BufferedInputStream bis = new BufferedInputStream(input);
      ByteArrayOutputStream out = new ByteArrayOutputStream();

      int c = bis.read();
      while (c != -1) {
        out.write(c);
        c = bis.read();
      }
      return out.toByteArray();

    } catch (IOException e) {
      e.printStackTrace();
      //throw new RuntimeException("Couldn't load bytes from stream");
    }
    return null;
  }

  /**
   * ( begin auto-generated from loadStrings.xml )
   * 
   * Reads the contents of a file or url and creates a String array of its
   * individual lines. If a file is specified, it must be located in the
   * sketch's "data" directory/folder.<br />
   * <br />
   * The filename parameter can also be a URL to a file found online. For
   * security reasons, a Processing sketch found online can only download files
   * from the same server from which it came. Getting around this restriction
   * requires a <a href="http://wiki.processing.org/w/Sign_an_Applet">signed
   * applet</a>. <br />
   * If the file is not available or an error occurs, <b>null</b> will be
   * returned and an error message will be printed to the console. The error
   * message does not halt the program, however the null value may cause a
   * NullPointerException if your code does not check whether the value returned
   * is null. <br/>
   * <br/>
   * Starting with Processing release 0134, all files loaded and saved by the
   * Processing API use UTF-8 encoding. In previous releases, the default
   * encoding for your platform was used, which causes problems when files are
   * moved to other platforms.
   * 
   * ( end auto-generated )
   * 
   * <h3>Advanced</h3> Load data from a file and shove it into a String array.
   * <p>
   * Exceptions are handled internally, when an error, occurs, an exception is
   * printed to the console and 'null' is returned, but the program continues
   * running. This is a tradeoff between 1) showing the user that there was a
   * problem but 2) not requiring that all i/o code is contained in try/catch
   * blocks, for the sake of new users (or people who are just trying to get
   * things done in a "scripting" fashion. If you want to handle exceptions, use
   * Java methods for I/O.
   * 
   * @webref input:files
   * @param filename
   *          name of the file or url to load
   * @see PApplet#loadBytes(String)
   * @see PApplet#saveStrings(String, String[])
   * @see PApplet#saveBytes(String, byte[])
   */
  public String[] loadStrings(String filename) {
    InputStream is = createInput(filename);
    if (is != null)
      return loadStrings(is);

    System.err.println("The file \"" + filename + "\" "
        + "is missing or inaccessible, make sure "
        + "the URL is valid or that the file has been "
        + "added to your sketch and is readable.");
    return null;
  }

  /**
   * @nowebref
   */
  static private String[] loadStrings(InputStream input) {
    try {
      BufferedReader reader = new BufferedReader(new InputStreamReader(input,
                                                                       "UTF-8"));
      return loadStrings(reader);
    } catch (IOException e) {
      e.printStackTrace();
    }
    return null;
  }

  static private String[] loadStrings(BufferedReader reader) {
    try {
      String lines[] = new String[100];
      int lineCount = 0;
      String line = null;
      while ((line = reader.readLine()) != null) {
        if (lineCount == lines.length) {
          String temp[] = new String[lineCount << 1];
          System.arraycopy(lines, 0, temp, 0, lineCount);
          lines = temp;
        }
        lines[lineCount++] = line;
      }
      reader.close();

      if (lineCount == lines.length) {
        return lines;
      }

      // resize array to appropriate amount for these lines
      String output[] = new String[lineCount];
      System.arraycopy(lines, 0, output, 0, lineCount);
      return output;

    } catch (IOException e) {
      e.printStackTrace();
      //throw new RuntimeException("Error inside loadStrings()");
    }
    return null;
  }

  //////////////////////////////////////////////////////////////

  // FILE OUTPUT

  /**
   * Prepend the sketch folder path to the filename (or path) that is passed in.
   * External libraries should use this function to save to the sketch folder.
   * <p/>
   * Note that when running as an applet inside a web browser, the sketchPath
   * will be set to null, because security restrictions prevent applets from
   * accessing that information.
   * <p/>
   * This will also cause an error if the sketch is not inited properly, meaning
   * that init() was never called on the PApplet when hosted my some other
   * main() or by other code. For proper use of init(), see the examples in the
   * main description text for PApplet.
   */
  private String sketchPath(String where) {
    if (sketchPath == null) {
      return where;
//      throw new RuntimeException("The applet was not inited properly, " +
//                                 "or security restrictions prevented " +
//                                 "it from determining its path.");
    }
    // isAbsolute() could throw an access exception, but so will writing
    // to the local disk using the sketch path, so this is safe here.
    // for 0120, added a try/catch anyways.
    try {
      if (new File(where).isAbsolute())
        return where;
    } catch (Exception e) {
    }

    return sketchPath + File.separator + where;
  }

  /**
   * Returns a path inside the applet folder to save to. Like sketchPath(), but
   * creates any in-between folders so that things save properly.
   * <p/>
   * All saveXxxx() functions use the path to the sketch folder, rather than its
   * data folder. Once exported, the data folder will be found inside the jar
   * file of the exported application or applet. In this case, it's not possible
   * to save data into the jar file, because it will often be running from a
   * server, or marked in-use if running from a local file system. With this in
   * mind, saving to the data path doesn't make sense anyway. If you know you're
   * running locally, and want to save to the data folder, use
   * <TT>saveXxxx("data/blah.dat")</TT>.
   */
  public String savePath(String where) {
    if (where == null)
      return null;
    String filename = sketchPath(where);
    createPath(filename);
    return filename;
  }

  /**
   * Return a full path to an item in the data folder.
   * <p>
   * In this method, the data path is defined not as the applet's actual data
   * path, but a folder titled "data" in the sketch's working directory. When
   * running inside the PDE, this will be the sketch's "data" folder. However,
   * when exported (as application or applet), sketch's data folder is exported
   * as part of the applications jar file, and it's not possible to read/write
   * from the jar file in a generic way. If you need to read data from the jar
   * file, you should use other methods such as createInput(), createReader(),
   * or loadStrings().
   */
  private String dataPath(String where) {
    // isAbsolute() could throw an access exception, but so will writing
    // to the local disk using the sketch path, so this is safe here.
    if (new File(where).isAbsolute())
      return where;

    return sketchPath + File.separator + "data" + File.separator + where;
  }

  /**
   * Takes a path and creates any in-between folders if they don't already
   * exist. Useful when trying to save to a subfolder that may not actually
   * exist.
   */
  static private void createPath(String path) {
    createPath(new File(path));
  }

  static void createPath(File file) {
    try {
      String parent = file.getParent();
      if (parent != null) {
        File unit = new File(parent);
        if (!unit.exists())
          unit.mkdirs();
      }
    } catch (SecurityException se) {
      System.err.println("You don't have permissions to create "
          + file.getAbsolutePath());
    }
  }

  //////////////////////////////////////////////////////////////

  // SORT

  /**
   * Shortcut to copy the entire contents of the source into the destination
   * array. Identical to <CODE>arraycopy(src, 0, dst, 0, src.length);</CODE>
   */
  static void arrayCopy(Object src, Object dst) {
    System.arraycopy(src, 0, dst, 0, Array.getLength(src));
  }

  /**
   * @nowebref
   */
  static Object expand(Object array) {
    return expand(array, Array.getLength(array) << 1);
  }

  static public Object expand(Object list, int newSize) {
    Class<?> type = list.getClass().getComponentType();
    Object temp = Array.newInstance(type, newSize);
    System
        .arraycopy(list, 0, temp, 0, Math.min(Array.getLength(list), newSize));
    return temp;
  }

  // contract() has been removed in revision 0124, use subset() instead.
  // (expand() is also functionally equivalent)

  static final int[] splice(int list[], int v, int index) {
    int outgoing[] = new int[list.length + 1];
    System.arraycopy(list, 0, outgoing, 0, index);
    outgoing[index] = v;
    System.arraycopy(list, index, outgoing, index + 1, list.length - index);
    return outgoing;
  }

  static final String[] splice(String list[], String v, int index) {
    String outgoing[] = new String[list.length + 1];
    System.arraycopy(list, 0, outgoing, 0, index);
    outgoing[index] = v;
    System.arraycopy(list, index, outgoing, index + 1, list.length - index);
    return outgoing;
  }

  static final Object splice(Object list, Object v, int index) {
    Object[] outgoing = null;
    int length = Array.getLength(list);

    // check whether item being spliced in is an array
    if (v.getClass().getName().charAt(0) == '[') {
      int vlength = Array.getLength(v);
      outgoing = new Object[length + vlength];
      System.arraycopy(list, 0, outgoing, 0, index);
      System.arraycopy(v, 0, outgoing, index, vlength);
      System.arraycopy(list, index, outgoing, index + vlength, length - index);

    } else {
      outgoing = new Object[length + 1];
      System.arraycopy(list, 0, outgoing, 0, index);
      Array.set(outgoing, index, v);
      System.arraycopy(list, index, outgoing, index + 1, length - index);
    }
    return outgoing;
  }

  static String[] subset(String list[], int start) {
    return subset(list, start, list.length - start);
  }

  static private String[] subset(String list[], int start, int count) {
    String output[] = new String[count];
    System.arraycopy(list, start, output, 0, count);
    return output;
  }

  static Object subset(Object list, int start, int count) {
    Class<?> type = list.getClass().getComponentType();
    Object outgoing = Array.newInstance(type, count);
    System.arraycopy(list, start, outgoing, 0, count);
    return outgoing;
  }

  static Object concat(Object a, Object b) {
    Class<?> type = a.getClass().getComponentType();
    int alength = Array.getLength(a);
    int blength = Array.getLength(b);
    Object outgoing = Array.newInstance(type, alength + blength);
    System.arraycopy(a, 0, outgoing, 0, alength);
    System.arraycopy(b, 0, outgoing, alength, blength);
    return outgoing;
  }

  //

  /**
   * ( begin auto-generated from trim.xml )
   * 
   * Removes whitespace characters from the beginning and end of a String. In
   * addition to standard whitespace characters such as space, carriage return,
   * and tab, this function also removes the Unicode "nbsp" character.
   * 
   * ( end auto-generated )
   * 
   * @webref data:string_functions
   * @param str
   *          any string
   * @see PApplet#split(String, String)
   * @see PApplet#join(String[], char)
   */
  static String trim(String str) {
    return str.replace('\u00A0', ' ').trim();
  }

  /**
   * ( begin auto-generated from join.xml )
   * 
   * Combines an array of Strings into one String, each separated by the
   * character(s) used for the <b>separator</b> parameter. To join arrays of
   * ints or floats, it's necessary to first convert them to strings using
   * <b>nf()</b> or <b>nfs()</b>.
   * 
   * ( end auto-generated )
   * 
   * @webref data:string_functions
   * @param str
   *          array of Strings
   * @param separator
   *          char or String to be placed between each item
   * @see PApplet#split(String, String)
   * @see PApplet#trim(String)
   * @see PApplet#nf(float, int, int)
   * @see PApplet#nfs(float, int, int)
   */
  public static String join(String str[], char separator) {
    return join(str, String.valueOf(separator));
  }

  public static String join(String str[], String separator) {
    StringBuffer buffer = new StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i != 0)
        buffer.append(separator);
      buffer.append(str[i]);
    }
    return buffer.toString();
  }

  static String[] splitTokens(String what) {
    return splitTokens(what, WHITESPACE);
  }

  /**
   * ( begin auto-generated from splitTokens.xml )
   * 
   * The splitTokens() function splits a String at one or many character
   * "tokens." The <b>tokens</b> parameter specifies the character or characters
   * to be used as a boundary. <br/>
   * <br/>
   * If no <b>tokens</b> character is specified, any whitespace character is
   * used to split. Whitespace characters include tab (\\t), line feed (\\n),
   * carriage return (\\r), form feed (\\f), and space. To convert a String to
   * an array of integers or floats, use the datatype conversion functions
   * <b>int()</b> and <b>float()</b> to convert the array of Strings.
   * 
   * ( end auto-generated )
   * 
   * @webref data:string_functions
   * @param what
   *          the string to be split
   * @param delim
   *          list of individual characters that will be used as separators
   * @see PApplet#split(String, String)
   * @see PApplet#join(String[], String)
   * @see PApplet#trim(String)
   */
  static String[] splitTokens(String what, String delim) {
    StringTokenizer toker = new StringTokenizer(what, delim);
    String pieces[] = new String[toker.countTokens()];

    int index = 0;
    while (toker.hasMoreTokens()) {
      pieces[index++] = toker.nextToken();
    }
    return pieces;
  }

  /**
   * ( begin auto-generated from split.xml )
   * 
   * The split() function breaks a string into pieces using a character or
   * string as the divider. The <b>delim</b> parameter specifies the character
   * or characters that mark the boundaries between each piece. A String[] array
   * is returned that contains each of the pieces. <br/>
   * <br/>
   * If the result is a set of numbers, you can convert the String[] array to to
   * a float[] or int[] array using the datatype conversion functions
   * <b>int()</b> and <b>float()</b> (see example above). <br/>
   * <br/>
   * The <b>splitTokens()</b> function works in a similar fashion, except that
   * it splits using a range of characters instead of a specific character or
   * sequence. <!-- /><br />
   * This function uses regular expressions to determine how the <b>delim</b>
   * parameter divides the <b>str</b> parameter. Therefore, if you use
   * characters such parentheses and brackets that are used with regular
   * expressions as a part of the <b>delim</b> parameter, you'll need to put two
   * blackslashes (\\\\) in front of the character (see example above). You can
   * read more about <a
   * href="http://en.wikipedia.org/wiki/Regular_expression">regular
   * expressions</a> and <a
   * href="http://en.wikipedia.org/wiki/Escape_character">escape characters</a>
   * on Wikipedia. -->
   * 
   * ( end auto-generated )
   * 
   * @webref data:string_functions
   * @usage web_application
   * @param what
   *          string to be split
   * @param delim
   *          the character or String used to separate the data
   */
  static String[] split(String what, char delim) {
    // do this so that the exception occurs inside the user's
    // program, rather than appearing to be a bug inside split()
    if (what == null)
      return null;
    //return split(what, String.valueOf(delim));  // huh

    char chars[] = what.toCharArray();
    int splitCount = 0; //1;
    for (int i = 0; i < chars.length; i++) {
      if (chars[i] == delim)
        splitCount++;
    }
    // make sure that there is something in the input string
    //if (chars.length > 0) {
    // if the last char is a delimeter, get rid of it..
    //if (chars[chars.length-1] == delim) splitCount--;
    // on second thought, i don't agree with this, will disable
    //}
    if (splitCount == 0) {
      String splits[] = new String[1];
      splits[0] = new String(what);
      return splits;
    }
    //int pieceCount = splitCount + 1;
    String splits[] = new String[splitCount + 1];
    int splitIndex = 0;
    int startIndex = 0;
    for (int i = 0; i < chars.length; i++) {
      if (chars[i] == delim) {
        splits[splitIndex++] = new String(chars, startIndex, i - startIndex);
        startIndex = i + 1;
      }
    }
    //if (startIndex != chars.length) {
    splits[splitIndex] = new String(chars, startIndex, chars.length
        - startIndex);
    //}
    return splits;
  }

  static protected HashMap<String, Pattern> matchPatterns;

  static Pattern matchPattern(String regexp) {
    Pattern p = null;
    if (matchPatterns == null) {
      matchPatterns = new HashMap<String, Pattern>();
    } else {
      p = matchPatterns.get(regexp);
    }
    if (p == null) {
      if (matchPatterns.size() == 10) {
        // Just clear out the match patterns here if more than 10 are being
        // used. It's not terribly efficient, but changes that you have >10
        // different match patterns are very slim, unless you're doing
        // something really tricky (like custom match() methods), in which
        // case match() won't be efficient anyway. (And you should just be
        // using your own Java code.) The alternative is using a queue here,
        // but that's a silly amount of work for negligible benefit.
        matchPatterns.clear();
      }
      p = Pattern.compile(regexp, Pattern.MULTILINE | Pattern.DOTALL);
      matchPatterns.put(regexp, p);
    }
    return p;
  }

  /**
   * ( begin auto-generated from match.xml )
   * 
   * The match() function is used to apply a regular expression to a piece of
   * text, and return matching groups (elements found inside parentheses) as a
   * String array. No match will return null. If no groups are specified in the
   * regexp, but the sequence matches, an array of length one (with the matched
   * text as the first element of the array) will be returned.<br />
   * <br />
   * To use the function, first check to see if the result is null. If the
   * result is null, then the sequence did not match. If the sequence did match,
   * an array is returned. If there are groups (specified by sets of
   * parentheses) in the regexp, then the contents of each will be returned in
   * the array. Element [0] of a regexp match returns the entire matching
   * string, and the match groups start at element [1] (the first group is [1],
   * the second [2], and so on).<br />
   * <br />
   * The syntax can be found in the reference for Java's <a
   * href="http://download.oracle.com/javase/6/docs/api/">Pattern</a> class. For
   * regular expression syntax, read the <a
   * href="http://download.oracle.com/javase/tutorial/essential/regex/">Java
   * Tutorial</a> on the topic.
   * 
   * ( end auto-generated )
   * 
   * @webref data:string_functions
   * @param what
   *          the String to be searched
   * @param regexp
   *          the regexp to be used for matching
   * @see PApplet#matchAll(String, String)
   * @see PApplet#split(String, String)
   * @see PApplet#splitTokens(String, String)
   * @see PApplet#join(String[], String)
   * @see PApplet#trim(String)
   */
  static String[] match(String what, String regexp) {
    Pattern p = matchPattern(regexp);
    Matcher m = p.matcher(what);
    if (m.find()) {
      int count = m.groupCount() + 1;
      String[] groups = new String[count];
      for (int i = 0; i < count; i++) {
        groups[i] = m.group(i);
      }
      return groups;
    }
    return null;
  }

  /**
   * Parse a String to an int, and provide an alternate value that should be
   * used when the number is invalid.
   */
  static final int parseInt(String what, int otherwise) {
    try {
      int offset = what.indexOf('.');
      if (offset == -1) {
        return Integer.parseInt(what);
      } else {
        return Integer.parseInt(what.substring(0, offset));
      }
    } catch (NumberFormatException e) {
    }
    return otherwise;
  }

  // . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

  /**
   * Make an array of int elements from an array of String objects. If the
   * String can't be parsed as a number, it will be set to zero.
   * 
   * String s[] = { "1", "300", "44" }; int numbers[] = parseInt(s);
   * 
   * numbers will contain { 1, 300, 44 }
   */
  static int[] parseInt(String what[]) {
    return parseInt(what, 0);
  }

  /**
   * Make an array of int elements from an array of String objects. If the
   * String can't be parsed as a number, its entry in the array will be set to
   * the value of the "missing" parameter.
   * 
   * String s[] = { "1", "300", "apple", "44" }; int numbers[] = parseInt(s,
   * 9999);
   * 
   * numbers will contain { 1, 300, 9999, 44 }
   */
  static private int[] parseInt(String what[], int missing) {
    int output[] = new int[what.length];
    for (int i = 0; i < what.length; i++) {
      try {
        output[i] = Integer.parseInt(what[i]);
      } catch (NumberFormatException e) {
        output[i] = missing;
      }
    }
    return output;
  }

  // . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

  /*
   * static final private float parseFloat(boolean what) { return what ? 1 : 0;
   * }
   */

  static final float parseFloat(String what) {
    return parseFloat(what, Float.NaN);
  }

  static final float parseFloat(String what, float otherwise) {
    try {
      return new Float(what).floatValue();
    } catch (NumberFormatException e) {
    }

    return otherwise;
  }

  // . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

  /*
   * static final private float[] parseFloat(boolean what[]) { float floaties[]
   * = new float[what.length]; for (int i = 0; i < what.length; i++) {
   * floaties[i] = what[i] ? 1 : 0; } return floaties; }
   * 
   * static final private float[] parseFloat(char what[]) { float floaties[] =
   * new float[what.length]; for (int i = 0; i < what.length; i++) { floaties[i]
   * = (char) what[i]; } return floaties; }
   */

  static final float[] parseFloat(String what[]) {
    return parseFloat(what, Float.NaN);
  }

  static final private float[] parseFloat(String what[], float missing) {
    float output[] = new float[what.length];
    for (int i = 0; i < what.length; i++) {
      try {
        output[i] = new Float(what[i]).floatValue();
      } catch (NumberFormatException e) {
        output[i] = missing;
      }
    }
    return output;
  }

  // . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

  /**
   * Integer number formatter.
   */
  static private NumberFormat int_nf;

  static private int int_nf_digits;

  static private boolean int_nf_commas;

  /**
   * ( begin auto-generated from nf.xml )
   * 
   * Utility function for formatting numbers into strings. There are two
   * versions, one for formatting floats and one for formatting ints. The values
   * for the <b>digits</b>, <b>left</b>, and <b>right</b> parameters should
   * always be positive integers.<br />
   * <br />
   * As shown in the above example, <b>nf()</b> is used to add zeros to the left
   * and/or right of a number. This is typically for aligning a list of numbers.
   * To <em>remove</em> digits from a floating-point number, use the
   * <b>int()</b>, <b>ceil()</b>, <b>floor()</b>, or <b>round()</b> functions.
   * 
   * ( end auto-generated )
   * 
   * @webref data:string_functions
   * @param num
   *          the number(s) to format
   * @param digits
   *          number of digits to pad with zero
   * @see PApplet#nfs(float, int, int)
   * @see PApplet#nfp(float, int, int)
   * @see PApplet#nfc(float, int)
   */
  static private String nf(int num, int digits) {
    if ((int_nf != null) && (int_nf_digits == digits) && !int_nf_commas) {
      return int_nf.format(num);
    }

    int_nf = NumberFormat.getInstance();
    int_nf.setGroupingUsed(false); // no commas
    int_nf_commas = false;
    int_nf.setMinimumIntegerDigits(digits);
    int_nf_digits = digits;
    return int_nf.format(num);
  }

  /**
   * nfc() or "number format with commas". This is an unfortunate misnomer
   * because in locales where a comma is not the separator for numbers, it won't
   * actually be outputting a comma, it'll use whatever makes sense for the
   * locale.
   */
  static String nfc(int num) {
    if ((int_nf != null) && (int_nf_digits == 0) && int_nf_commas) {
      return int_nf.format(num);
    }

    int_nf = NumberFormat.getInstance();
    int_nf.setGroupingUsed(true);
    int_nf_commas = true;
    int_nf.setMinimumIntegerDigits(0);
    int_nf_digits = 0;
    return int_nf.format(num);
  }

  /**
   * number format signed (or space) Formats a number but leaves a blank space
   * in the front when it's positive so that it can be properly aligned with
   * numbers that have a negative sign in front of them.
   */

  static private NumberFormat float_nf;

  static private int float_nf_left, float_nf_right;

  static private boolean float_nf_commas;

  /**
   * @param num
   *          [] the number(s) to format
   * @param left
   *          number of digits to the left of the decimal point
   * @param right
   *          number of digits to the right of the decimal point
   */
  static private String nf(float num, int left, int right) {
    if ((float_nf != null) && (float_nf_left == left)
        && (float_nf_right == right) && !float_nf_commas) {
      return float_nf.format(num);
    }

    float_nf = NumberFormat.getInstance();
    float_nf.setGroupingUsed(false);
    float_nf_commas = false;

    if (left != 0)
      float_nf.setMinimumIntegerDigits(left);
    if (right != 0) {
      float_nf.setMinimumFractionDigits(right);
      float_nf.setMaximumFractionDigits(right);
    }
    float_nf_left = left;
    float_nf_right = right;
    return float_nf.format(num);
  }

  static String nfs(float num, int left, int right) {
    return (num < 0) ? nf(num, left, right) : (' ' + nf(num, left, right));
  }

  /**
   * @param digits
   *          the number of digits (maximum 8)
   */
  static final String hex(int what, int digits) {
    String stuff = Integer.toHexString(what).toUpperCase();
    if (digits > 8) {
      digits = 8;
    }

    int length = stuff.length();
    if (length > digits) {
      return stuff.substring(length - digits);

    } else if (length < digits) {
      return "00000000".substring(8 - (digits - length)) + stuff;
    }
    return stuff;
  }

  /**
   * ( begin auto-generated from unhex.xml )
   * 
   * Converts a String representation of a hexadecimal number to its equivalent
   * integer value.
   * 
   * ( end auto-generated )
   * 
   * @webref data:conversion
   * @param what
   *          String to convert to an integer
   * @see PApplet#hex(int, int)
   * @see PApplet#binary(byte)
   * @see PApplet#unbinary(String)
   */
  static final int unhex(String what) {
    // has to parse as a Long so that it'll work for numbers bigger than 2^31
    return (int) (Long.parseLong(what, 16));
  }

  //

  /**
   * ( begin auto-generated from color.xml )
   * 
   * Creates colors for storing in variables of the <b>color</b> datatype. The
   * parameters are interpreted as RGB or HSB values depending on the current
   * <b>colorMode()</b>. The default mode is RGB values from 0 to 255 and
   * therefore, the function call <b>color(255, 204, 0)</b> will return a bright
   * yellow color. More about how colors are stored can be found in the
   * reference for the <a href="color_datatype.html">color</a> datatype.
   * 
   * ( end auto-generated )
   * 
   * @webref color:creating_reading
   * @param gray
   *          number specifying value between white and black
   * @see PApplet#colorMode(int)
   */
  public final int color(int gray) {
    if (g == null) {
      if (gray > 255)
        gray = 255;
      else if (gray < 0)
        gray = 0;
      return 0xff000000 | (gray << 16) | (gray << 8) | gray;
    }
    return g.color(gray);
  }

  public final int color(float x, float y, float z) {
    if (g == null) {
      if (x > 255)
        x = 255;
      else if (x < 0)
        x = 0;
      if (y > 255)
        y = 255;
      else if (y < 0)
        y = 0;
      if (z > 255)
        z = 255;
      else if (z < 0)
        z = 0;

      return 0xff000000 | ((int) x << 16) | ((int) y << 8) | (int) z;
    }
    return g.color(x, y, z);
  }

  /**
   * Set this sketch to communicate its state back to the PDE.
   * <p/>
   * This uses the stderr stream to write positions of the window (so that it
   * will be saved by the PDE for the next run) and notify on quit. See more
   * notes in the Worker class.
   */
  private void setupExternalMessages() {

    frame.addComponentListener(new ComponentAdapter() {
      public void componentMoved(ComponentEvent e) {
        Point where = ((Frame) e.getSource()).getLocation();
        System.err.println(PApplet.EXTERNAL_MOVE + " " + where.x + " "
            + where.y);
        System.err.flush(); // doesn't seem to help or hurt
      }
    });

    frame.addWindowListener(new WindowAdapter() {
      public void windowClosing(WindowEvent e) {
//          System.err.println(PApplet.EXTERNAL_QUIT);
//          System.err.flush();  // important
//          System.exit(0);
        exit(); // don't quit, need to just shut everything down (0133)
      }
    });
  }

  /**
   * ( begin auto-generated from ellipse.xml )
   * 
   * Draws an ellipse (oval) in the display window. An ellipse with an equal
   * <b>width</b> and <b>height</b> is a circle. The first two parameters set
   * the location, the third sets the width, and the fourth sets the height. The
   * origin may be changed with the <b>ellipseMode()</b> function.
   * 
   * ( end auto-generated )
   * 
   * @webref shape:2d_primitives
   * @param a
   *          x-coordinate of the ellipse
   * @param b
   *          y-coordinate of the ellipse
   * @param c
   *          width of the ellipse
   * @param d
   *          height of the ellipse
   * @see PApplet#ellipseMode(int)
   */
  public void ellipse(float a, float b, float c, float d) {
    if (recorder != null)
      recorder.ellipse(a, b, c, d);
    g.ellipse(a, b, c, d);
  }

  /**
   * ( begin auto-generated from pushStyle.xml )
   * 
   * The <b>pushStyle()</b> function saves the current style settings and
   * <b>popStyle()</b> restores the prior settings. Note that these functions
   * are always used together. They allow you to change the style settings and
   * later return to what you had. When a new style is started with
   * <b>pushStyle()</b>, it builds on the current style information. The
   * <b>pushStyle()</b> and <b>popStyle()</b> functions can be embedded to
   * provide more control (see the second example above for a demonstration.) <br />
   * <br />
   * The style information controlled by the following functions are included in
   * the style: fill(), stroke(), tint(), strokeWeight(), strokeCap(),
   * strokeJoin(), imageMode(), rectMode(), ellipseMode(), shapeMode(),
   * colorMode(), textAlign(), textFont(), textMode(), textSize(),
   * textLeading(), emissive(), specular(), shininess(), ambient()
   * 
   * ( end auto-generated )
   * 
   * @webref structure
   * @see PGraphics#popStyle()
   */
  public void pushStyle() {
    if (recorder != null)
      recorder.pushStyle();
    g.pushStyle();
  }

  /**
   * ( begin auto-generated from popStyle.xml )
   * 
   * The <b>pushStyle()</b> function saves the current style settings and
   * <b>popStyle()</b> restores the prior settings; these functions are always
   * used together. They allow you to change the style settings and later return
   * to what you had. When a new style is started with <b>pushStyle()</b>, it
   * builds on the current style information. The <b>pushStyle()</b> and
   * <b>popStyle()</b> functions can be embedded to provide more control (see
   * the second example above for a demonstration.)
   * 
   * ( end auto-generated )
   * 
   * @webref structure
   * @see PGraphics#pushStyle()
   */
  public void popStyle() {
    if (recorder != null)
      recorder.popStyle();
    g.popStyle();
  }

  /**
   * ( begin auto-generated from noStroke.xml )
   * 
   * Disables drawing the stroke (outline). If both <b>noStroke()</b> and
   * <b>noFill()</b> are called, nothing will be drawn to the screen.
   * 
   * ( end auto-generated )
   * 
   * @webref color:setting
   * @see PGraphics#stroke(float, float, float, float)
   */
  public void noStroke() {
    if (recorder != null)
      recorder.noStroke();
    g.noStroke();
  }

  public void stroke(float x, float y, float z, float alpha) {
    if (recorder != null)
      recorder.stroke(x, y, z, alpha);
    g.stroke(x, y, z, alpha);
  }

  /**
   * ( begin auto-generated from noFill.xml )
   * 
   * Disables filling geometry. If both <b>noStroke()</b> and <b>noFill()</b>
   * are called, nothing will be drawn to the screen.
   * 
   * ( end auto-generated )
   * 
   * @webref color:setting
   * @usage web_application
   * @see PGraphics#fill(float, float, float, float)
   */
  public void noFill() {
    if (recorder != null)
      recorder.noFill();
    g.noFill();
  }

  public void fill(float x, float y, float z) {
    if (recorder != null)
      recorder.fill(x, y, z);
    g.fill(x, y, z);
  }

  /**
   * @param max
   *          range for all color elements
   */
  public void colorMode(int mode, float max) {
    if (recorder != null)
      recorder.colorMode(mode, max);
    g.colorMode(mode, max);
  }

  /**
   * Return true if this renderer should be drawn to the screen. Defaults to
   * returning true, since nearly all renderers are on-screen beasts. But can be
   * overridden for subclasses like PDF so that a window doesn't open up. <br/>
   * <br/>
   * A better name? showFrame, displayable, isVisible, visible, shouldDisplay,
   * what to call this?
   */
  private boolean displayable() {
    return g.displayable();
  }

  public void setSize(Dimension size) {
    this.size = size;
  }

  public void setSize(int w, int h) {
    this.size = new Dimension(w, h);
  }

  public Dimension getSize() {
    return size;
  }

//////////////////////////////////////////////////////////////

  /**
   * Main method for the primary animation thread.
   * 
   * <A HREF="http://java.sun.com/products/jfc/tsc/articles/painting/">Painting
   * in AWT and Swing</A>
   */
  public void run() { // not good to make this synchronized, locks things up
    long beforeTime = System.nanoTime();
    long overSleepTime = 0L;

    int noDelays = 0;
    // Number of frames with a delay of 0 ms before the
    // animation thread yields to other running threads.
    final int NO_DELAYS_PER_YIELD = 15;

    /*
     * // this has to be called after the exception is thrown, // otherwise the
     * supporting libs won't have a valid context to draw to Object methodArgs[]
     * = new Object[] { new Integer(width), new Integer(height) };
     * sizeMethods.handle(methodArgs);
     */

    while ((Thread.currentThread() == thread) && !finished) {
      while (paused) {
//        println("paused...");
        try {
          Thread.sleep(100L);
        } catch (InterruptedException e) {
          //ignore?
        }
      }

      // Don't resize the renderer from the EDT (i.e. from a ComponentEvent),
      // otherwise it may attempt a resize mid-render.
      if (resizeRequest) {
        resizeRenderer(resizeWidth, resizeHeight);
        resizeRequest = false;
      }

      // render a single frame
      handleDraw();

      if (frameCount == 1) {
        // Call the request focus event once the image is sure to be on
        // screen and the component is valid. The OpenGL renderer will
        // request focus for its canvas inside beginDraw().
        // http://java.sun.com/j2se/1.4.2/docs/api/java/awt/doc-files/FocusSpec.html
        // Disabling for 0185, because it causes an assertion failure on OS X
        // http://code.google.com/p/processing/issues/detail?id=258
        //        requestFocus();

        // Changing to this version for 0187
        // http://code.google.com/p/processing/issues/detail?id=279
        // requestFocusInWindow();
      }

      // wait for update & paint to happen before drawing next frame
      // this is necessary since the drawing is sometimes in a
      // separate thread, meaning that the next frame will start
      // before the update/paint is completed

      long afterTime = System.nanoTime();
      long timeDiff = afterTime - beforeTime;
      //System.out.println("time diff is " + timeDiff);
      long sleepTime = (frameRatePeriod - timeDiff) - overSleepTime;

      if (sleepTime > 0) { // some time left in this cycle
        try {
//          Thread.sleep(sleepTime / 1000000L);  // nanoseconds -> milliseconds
          Thread.sleep(sleepTime / 1000000L, (int) (sleepTime % 1000000L));
          noDelays = 0; // Got some sleep, not delaying anymore
        } catch (InterruptedException ex) {
        }

        overSleepTime = (System.nanoTime() - afterTime) - sleepTime;
        //System.out.println("  oversleep is " + overSleepTime);

      } else { // sleepTime <= 0; the frame took longer than the period
//        excess -= sleepTime;  // store excess time value
        overSleepTime = 0L;

        if (noDelays > NO_DELAYS_PER_YIELD) {
          Thread.yield(); // give another thread a chance to run
          noDelays = 0;
        }
      }

      beforeTime = System.nanoTime();
    }

    dispose(); // call to shutdown libs?

    // If the user called the exit() function, the window should close,
    // rather than the sketch just halting.
    if (exitCalled) {
      exitActual();
    }
  }

}
