package com.googlecode.gwtgae2011.client.main;

import com.google.gwt.cell.client.FieldUpdater;
import com.google.inject.Inject;
import com.google.inject.Provider;
import com.googlecode.gwtgae2011.shared.proxy.SketchProxy;
import com.googlecode.gwtgae2011.shared.service.GwtGae2011RequestFactory.SketchRequest;


/**
 * Updater for the editable list name column. Must be in presenter because
 * needs to fire requests.
 */
public class TitleFieldUpdater implements FieldUpdater<SketchProxy, String>
{
  private Provider<SketchRequest> sketchRequestProvider;

  @Inject
  public TitleFieldUpdater(Provider<SketchRequest> sketchRequestProvider)
  {
    this.sketchRequestProvider = sketchRequestProvider;
  }

  @Override
  public void update(int index, SketchProxy sketchProxy, final String newTitle)
  {
    SketchRequest sketchRequest = sketchRequestProvider.get();
    SketchProxy editable = sketchRequest.edit(sketchProxy);
    editable.setTitle(newTitle);
    sketchRequest.save(editable).fire();
  }
}  