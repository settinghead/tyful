package com.googlecode.gwtgae2011.client.main;

import java.util.List;

import com.google.gwt.requestfactory.shared.Receiver;
import com.google.gwt.view.client.AsyncDataProvider;
import com.google.gwt.view.client.HasData;
import com.google.gwt.view.client.Range;
import com.google.inject.Inject;
import com.google.inject.Provider;
import com.googlecode.gwtgae2011.shared.proxy.SketchProxy;
import com.googlecode.gwtgae2011.shared.service.GwtGae2011RequestFactory.SketchRequest;

public class SketchListDataProvider extends AsyncDataProvider<SketchProxy>
{
  private Provider<SketchRequest> sketchRequestProvider;

  @Inject
  public SketchListDataProvider(Provider<SketchRequest> sketchRequestProvider)
  {
    this.sketchRequestProvider = sketchRequestProvider;
  }

  @Override
  protected void onRangeChanged(HasData<SketchProxy> display)
  {
    final Range range = display.getVisibleRange();
    sketchRequestProvider.get().fetchRange(range.getStart(), range.getLength())
        .fire(new Receiver<List<SketchProxy>>() {
      @Override
      public void onSuccess(List<SketchProxy> sketchProxies) {
        updateRowData(range.getStart(), sketchProxies);
      }
    });
    sketchRequestProvider.get().getCount().fire(new Receiver<Integer>() {
      @Override
      public void onSuccess(Integer count) {
        updateRowCount(count, true);
      }
    });

  }
}