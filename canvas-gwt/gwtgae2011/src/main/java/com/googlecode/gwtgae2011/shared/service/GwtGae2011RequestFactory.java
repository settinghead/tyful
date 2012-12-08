package com.googlecode.gwtgae2011.shared.service;

import java.util.List;

import com.google.gwt.requestfactory.shared.Request;
import com.google.gwt.requestfactory.shared.RequestContext;
import com.google.gwt.requestfactory.shared.RequestFactory;
import com.google.gwt.requestfactory.shared.Service;
import com.googlecode.gwtgae2011.server.locator.DaoServiceLocator;
import com.googlecode.gwtgae2011.server.service.SketchDao;
import com.googlecode.gwtgae2011.shared.proxy.SketchProxy;
import com.googlecode.gwtgae2011.shared.proxy.StrokeProxy;

public interface GwtGae2011RequestFactory extends RequestFactory {

  /**
   * Service stub for static methods in Sketch
   */
  @Service(value = SketchDao.class, locator = DaoServiceLocator.class)
  interface SketchRequest extends RequestContext
  {
    Request<SketchProxy> save(SketchProxy editable);

    Request<SketchProxy> addStroke(SketchProxy sketchProxy, StrokeProxy stroke);

    Request<SketchProxy> fetch(Long id);

    Request<List<SketchProxy>> fetchRange(Integer start, Integer length);

    Request<Integer> getCount();
  }

  SketchRequest sketchRequest();
}
