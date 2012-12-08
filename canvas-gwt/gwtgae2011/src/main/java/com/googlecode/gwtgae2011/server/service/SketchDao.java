package com.googlecode.gwtgae2011.server.service;

import java.util.List;

import com.google.appengine.api.datastore.EntityNotFoundException;
import com.googlecode.gwtgae2011.server.domain.Sketch;
import com.googlecode.gwtgae2011.shared.Stroke;

/**
 * @author turbomanage
 */
public class SketchDao extends ObjectifyDao<Sketch>
{
  public Sketch save(Sketch sketch)
  {
    put(sketch);
    return sketch;
  }
  
  public Sketch addStroke(Sketch sketch, Stroke stroke) {
    sketch.addStroke(stroke);
    put(sketch);
    return sketch;
  }

  public Sketch fetch(Long id) throws EntityNotFoundException {
    return get(id);
  }
  
  public List<Sketch> fetchRange(Integer start, Integer length) {
    return listAll(start, length); 
  }
  
  public Integer getCount() {
    return countAll();
  }
}