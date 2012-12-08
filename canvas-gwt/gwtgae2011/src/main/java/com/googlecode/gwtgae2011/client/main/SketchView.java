package com.googlecode.gwtgae2011.client.main;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import com.google.gwt.canvas.client.Canvas;
import com.google.gwt.canvas.dom.client.Context2d;
import com.google.gwt.core.client.Scheduler;
import com.google.gwt.core.client.Scheduler.ScheduledCommand;
import com.google.gwt.dom.client.Touch;
import com.google.gwt.event.dom.client.GestureStartEvent;
import com.google.gwt.event.dom.client.GestureStartHandler;
import com.google.gwt.event.dom.client.MouseDownEvent;
import com.google.gwt.event.dom.client.MouseDownHandler;
import com.google.gwt.event.dom.client.MouseEvent;
import com.google.gwt.event.dom.client.MouseMoveEvent;
import com.google.gwt.event.dom.client.MouseMoveHandler;
import com.google.gwt.event.dom.client.MouseUpEvent;
import com.google.gwt.event.dom.client.MouseUpHandler;
import com.google.gwt.event.dom.client.TouchEndEvent;
import com.google.gwt.event.dom.client.TouchEndHandler;
import com.google.gwt.event.dom.client.TouchEvent;
import com.google.gwt.event.dom.client.TouchMoveEvent;
import com.google.gwt.event.dom.client.TouchMoveHandler;
import com.google.gwt.event.dom.client.TouchStartEvent;
import com.google.gwt.event.dom.client.TouchStartHandler;
import com.google.gwt.event.logical.shared.ValueChangeEvent;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.uibinder.client.UiHandler;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Element;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.LayoutPanel;
import com.google.gwt.user.client.ui.TextBox;
import com.google.gwt.user.client.ui.Widget;
import com.googlecode.gwtgae2011.shared.Point;
import com.googlecode.gwtgae2011.shared.Stroke;
import com.gwtplatform.mvp.client.ViewImpl;

/**
 * This view shows a drawing made by the user.
 */
public class SketchView extends ViewImpl implements SketchPresenter.MyView,
    MouseDownHandler, MouseMoveHandler, MouseUpHandler, TouchMoveHandler, TouchEndHandler, 
    GestureStartHandler, TouchStartHandler {

  private final LayoutPanel widget;

  public interface Binder extends UiBinder<LayoutPanel, SketchView> { }

  private final Scheduler scheduler;
  
  @UiField(provided = true)
  LayoutPanel layoutPanel;
  
  @UiField
  TextBox title;
  
  @UiField
  Label notSupported;

  @UiField(provided = true)
  Canvas canvas;

  private final Context2d context;
  private final Element canvasElement;

  private final List<Stroke> strokes = new ArrayList<Stroke>(); 

  private SketchPresenter presenter;

  private int width;
  private int height;
  
  private ScheduledCommand refreshCommand;

  private Stroke currentStroke;
  
  @Inject
  public SketchView(Scheduler scheduler, Binder binder) {
    this.scheduler = scheduler;
    
    layoutPanel = new MyLayoutPanel();
    
    canvas = Canvas.createIfSupported();
    if (canvas == null) {
      context = null;
      canvasElement = null;
    } else {
      context = canvas.getContext2d();
      canvasElement = canvas.getElement();
      initCanvas();
    }
    widget = binder.createAndBindUi(this);
    notSupported.setVisible(canvas == null);
  }

  @Override
  public Widget asWidget() {
    return widget;
  }

  @Override
  public void setPresenter(SketchPresenter presenter) {
    this.presenter = presenter;
  }

  private void initCanvas() {
    canvas.setWidth("100%");
    canvas.setHeight("100%");
    canvas.addMouseDownHandler(this);
    canvas.addMouseMoveHandler(this);
    canvas.addMouseUpHandler(this);
    canvas.addTouchStartHandler(this);
    canvas.addTouchMoveHandler(this);
    canvas.addTouchEndHandler(this);
    canvas.addGestureStartHandler(this);
  }

  private class MyLayoutPanel extends LayoutPanel {

    @Override
    public void onLoad() {
      super.onLoad();
      scheduler.scheduleDeferred(new ScheduledCommand(){
        @Override
        public void execute() {
          onResize();
        }
      });
    }
    
    @Override    
    public void onResize() {
      if (canvas == null || context == null) {
        return;
      }
      width = canvas.getOffsetWidth();
      height = canvas.getOffsetHeight();
      canvas.setCoordinateSpaceWidth(width);
      canvas.setCoordinateSpaceHeight(height);
      scheduleRefresh();
    }
  }

  @Override
  public void clear() {
    strokes.clear();
    currentStroke = null;
    scheduleRefresh();
  }

  @Override
  public void setTitle(String title) {
    this.title.setText(title);
  }

  private void scheduleRefresh() {
    if (refreshCommand != null) {
      return;
    }
    
    refreshCommand = new ScheduledCommand(){
      @Override
      public void execute() {
        refresh();
        refreshCommand = null;
      }
    };
    scheduler.scheduleDeferred(refreshCommand);
  }
  
  private void refresh() {
    context.clearRect(0, 0, width, height);
    for(Stroke stroke : strokes) {
      drawStroke(stroke);
    }
    drawStroke(currentStroke);
  }

  private void drawStroke(Stroke stroke) {
    if (stroke == null || stroke.size() < 2) {
      return;
    }
    
    context.beginPath();    
    Point p0 = stroke.get(0);
    context.moveTo(xPosToPix(p0.getX()), yPosToPix(p0.getY()));
    for(int i = 1; i < stroke.size(); ++i) {
      Point p = stroke.get(i);
      context.lineTo(xPosToPix(p.getX()), yPosToPix(p.getY()));
    }
    context.stroke();
  }
  
  private double xPosToPix(float xPos) {
    return xPos*width;
  }
  
  private double yPosToPix(float yPos) {
    return yPos*height;
  }

  private float xPixToPos(int xPix) {
    return xPix/(float)width;
  }
  
  private float yPixToPos(int yPix) {
    return yPix/(float)height;
  }
  
  @Override
  public void addStroke(Stroke stroke) {
    strokes.add(stroke);
    drawStroke(stroke);
  }

  @Override
  public void onMouseDown(MouseDownEvent event) {
    DOM.setCapture(canvasElement);
    currentStroke = new Stroke();
    addPointToCurrentStroke(event);
  }

  @Override
  public void onMouseMove(MouseMoveEvent event) {
    if (DOM.getCaptureElement() == canvasElement) {
      addPointToCurrentStroke(event);
    }
  }

  @Override
  public void onMouseUp(MouseUpEvent event) {
    DOM.releaseCapture(canvas.getElement());
    presenter.addNewStroke(currentStroke);
    currentStroke = null;
  }

  @Override
  public void onTouchStart(TouchStartEvent event) {
    currentStroke = new Stroke();
    addPointToCurrentStroke(event);
    
    event.preventDefault();
  }
  
  @Override
  public void onTouchMove(TouchMoveEvent event) {
    event.preventDefault();
    addPointToCurrentStroke(event);
  }

  @Override
  public void onTouchEnd(TouchEndEvent event) {
    event.preventDefault();
    presenter.addNewStroke(currentStroke);
    currentStroke = null;
  }

  @Override
  public void onGestureStart(GestureStartEvent event) {
    event.preventDefault();
  }
  
  private void addPointToCurrentStroke(MouseEvent<?> event) {
    currentStroke.add(new Point(xPixToPos(event.getRelativeX(canvasElement)),
        yPixToPos(event.getRelativeY(canvasElement))));
    drawLastTwoPoints(currentStroke);
  }  

  private void addPointToCurrentStroke(TouchEvent<?> event) {
    if (currentStroke != null && event.getTouches().length() > 0) {
      Touch touch = event.getTouches().get(0);
      currentStroke.add(new Point(xPixToPos(touch.getRelativeX(canvasElement)),
          yPixToPos(touch.getRelativeY(canvasElement))));
      drawLastTwoPoints(currentStroke);
    }
  }  

  private void drawLastTwoPoints(Stroke stroke) {
    int size = stroke.size(); 
    if (size >= 2) {
      Point p0 = stroke.get(size-2);
      Point p1 = stroke.get(size-1);
      context.moveTo(xPosToPix(p0.getX()), yPosToPix(p0.getY()));
      context.lineTo(xPosToPix(p1.getX()), yPosToPix(p1.getY()));
      context.stroke();
    }
  }

  @UiHandler("title")
  void handleValueChange(ValueChangeEvent<String> event) {
    if (presenter != null) {
      presenter.setTitle(event.getValue());
    }
  }
  
}
