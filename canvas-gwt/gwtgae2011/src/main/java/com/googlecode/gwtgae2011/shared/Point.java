/**
 * Copyright 2011 Google Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package com.googlecode.gwtgae2011.shared;

import java.io.Serializable;

import com.google.gwt.requestfactory.shared.RequestContext;
import com.googlecode.gwtgae2011.shared.proxy.PointProxy;

public class Point implements Serializable {
  private static final long serialVersionUID = 1L;
  
  private float x;
  private float y;
  
  public Point() {
    this(0, 0);
  }
  
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public Point(Point v) {
    this(v.x, v.y);
  }
  
  public Float getX() {
    return x;
  }
  
  public Float getY() {
    return y;
  }
  
  public void setX(Float x) {
    this.x = x;
  }
  
  public void setY(Float y) {
    this.y = y;
  }
  
  public void add(float x, float y) {
    this.x += x;
    this.y += y;
  }
  
  public void add(Point v) {
    add(v.x, v.y);
  }
  
  public void sub(Point v) {
    sub(v.x, v.y);
  }
  
  public void sub(float x, float y) {
    this.x -= x;
    this.y -= y;
  }
  
  public void mult(float x, float y) {
    this.x *= x;
    this.y *= y;
  }
  
  public void mult(Point v) {
    mult(v.x, v.y);
  }
  
  public void mult(float c) {
    mult(c, c);
  }
  
  public double mag() {
    if (x == 0 && y == 0) {
      return 0;
    } else {
      return Math.sqrt(x * x + y * y);
    }
  }
  
  public double magSquared() {
    return x * x + y * y;
  }
  
  public void set(Point v) {
    x = v.x;
    y = v.y;
  }
  
  public static Point sub(Point a, Point b) {
    return new Point(a.x - b.x, a.y - b.y);
  }
  
  public static Point mult(Point v, int c) {
    return new Point(v.x * c, v.y * c);
  }

  public PointProxy toProxy(RequestContext context) {
    PointProxy result = context.create(PointProxy.class);
    result.setX(x);
    result.setY(y);
    return result;
  }
  
  public static Point fromProxy(PointProxy pointProxy) {
    return new Point(pointProxy.getX(), pointProxy.getY());
  }
}