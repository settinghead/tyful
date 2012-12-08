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

package com.googlecode.gwtgae2011.client.main;

import java.util.List;

import javax.inject.Inject;

import com.google.gwt.event.shared.EventBus;
import com.google.gwt.requestfactory.shared.Receiver;
import com.google.inject.Provider;
import com.googlecode.gwtgae2011.client.NameTokens;
import com.googlecode.gwtgae2011.shared.Stroke;
import com.googlecode.gwtgae2011.shared.proxy.SketchProxy;
import com.googlecode.gwtgae2011.shared.proxy.StrokeProxy;
import com.googlecode.gwtgae2011.shared.service.GwtGae2011RequestFactory.SketchRequest;
import com.gwtplatform.mvp.client.Presenter;
import com.gwtplatform.mvp.client.View;
import com.gwtplatform.mvp.client.annotations.NameToken;
import com.gwtplatform.mvp.client.annotations.ProxyStandard;
import com.gwtplatform.mvp.client.proxy.PlaceRequest;
import com.gwtplatform.mvp.client.proxy.ProxyPlace;
import com.gwtplatform.mvp.client.proxy.RevealContentEvent;

/**
 * A presenter that shows a {@link SketchView}.
 */
public class SketchPresenter extends Presenter<SketchPresenter.MyView, SketchPresenter.MyProxy> {

  private final Provider<SketchRequest> sketchRequestProvider;
  
  @Inject
  public SketchPresenter(EventBus eventBus, MyView view, MyProxy proxy,
      Provider<SketchRequest> sketchRequestProvider) {
    super(eventBus, view, proxy);
    view.setPresenter(this);
    this.sketchRequestProvider = sketchRequestProvider;
  }

  @ProxyStandard
  @NameToken(NameTokens.SKETCH)
  public interface MyProxy extends ProxyPlace<SketchPresenter> { }

  private Long id;
  private SketchProxy sketchProxy;
  private boolean fetching;
  
  public interface MyView extends View {
    public void setPresenter(SketchPresenter presenter);
    public void clear();
    public void addStroke(Stroke stroke);
    void setTitle(String title);
  }

  @Override
  protected void revealInParent() {
    RevealContentEvent.fire(this, MainPresenter.CENTRAL_SLOT_TYPE, this);
  }

  @Override
  protected void onReset() {
    super.onReset();
    sketchProxy = null;
    getView().setTitle("Untitled");
    getView().clear();
    fetching = false;
    if (id != null) {
      fetching = true;
      sketchRequestProvider.get().fetch(id).with("strokes").fire(new Receiver<SketchProxy>() {
        @Override
        public void onSuccess(SketchProxy sketchProxy) {
          SketchPresenter.this.sketchProxy = sketchProxy;
          draw(sketchProxy);
          fetching = false;
        }
      });
    }
  }

  private void draw(SketchProxy sketchProxy) {
    getView().setTitle(sketchProxy.getTitle());
    List<StrokeProxy> list = sketchProxy.getStrokes();
    for (StrokeProxy stroke : list) {
      getView().addStroke(Stroke.fromProxy(stroke));
    }
  }

  public void addNewStroke(Stroke stroke) {
    if (fetching) {
      return;
    }
    getView().addStroke(stroke);
    SketchRequest request = sketchRequestProvider.get();
    SketchProxy editable = getEditableProxy(request);
    
    request.addStroke(editable, stroke.toProxy(request)).fire(new Receiver<SketchProxy>() {
      @Override
      public void onSuccess(SketchProxy sketchProxy) {
        SketchPresenter.this.sketchProxy = sketchProxy;
      }
    });
  }

  public void setTitle(final String title) {
    if (title == null || fetching) {
      return;      
    }
    if (sketchProxy == null || !title.equals(sketchProxy.getTitle())) {
      SketchRequest request = sketchRequestProvider.get();
      SketchProxy editable = getEditableProxy(request);
      editable.setTitle(title);
      request.save(editable).fire(new Receiver<SketchProxy>() {
        @Override
        public void onSuccess(SketchProxy sketchProxy) {
          SketchPresenter.this.sketchProxy = sketchProxy;
          getView().setTitle(title);  
        }
      });
    }
  }

  private SketchProxy getEditableProxy(SketchRequest request) {
    if (sketchProxy == null) {
      sketchProxy = request.create(SketchProxy.class);
    }
    return request.edit(sketchProxy); 
  }

  @Override
  public void prepareFromRequest(PlaceRequest request) {
    String idString = request.getParameter("id", "");
    try {
      id = Long.parseLong(idString);
    } catch (NumberFormatException e) {
      id = null;
    }
  }
}
