package com.googlecode.gwtgae2011.shared;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.google.gwt.requestfactory.shared.RequestContext;
import com.googlecode.gwtgae2011.shared.proxy.PointProxy;
import com.googlecode.gwtgae2011.shared.proxy.StrokeProxy;
import com.googlecode.objectify.annotation.Serialized;

/**
 * A stroke is a series of points connected via a curve.
 */
public class Stroke implements Serializable {
  private static final long serialVersionUID = 1L;

  @Serialized
  private List<Point> points;

  public Stroke() {
    points = new ArrayList<Point>();
  }
  
  private Stroke(List<PointProxy> pointProxies) {
    this.points = new ArrayList<Point>(pointProxies.size());
    for( PointProxy pointProxy : pointProxies) {
      add(Point.fromProxy(pointProxy));
    }
  }
  
  public Integer size() {
    return points.size();
  }

  public void add(Point vector) {
    points.add(vector);
  }

  public Point get(int i) {
    return points.get(i);
  }

  public List<Point> getPoints() {
    return points;
  }

  public void setPoints(List<Point> points) {
    this.points = points;
  }

  public StrokeProxy toProxy(RequestContext context) {
    StrokeProxy result = context.create(StrokeProxy.class);
    List<PointProxy> pointProxies = new ArrayList<PointProxy>(points.size());
    for (Point point : points) {
      pointProxies.add(point.toProxy(context));
    }
    result.setPoints(pointProxies);
    return result;
  }

  public static Stroke fromProxy(StrokeProxy strokeProxy) {
    return new Stroke(strokeProxy.getPoints());
  }
}
