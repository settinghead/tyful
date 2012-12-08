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

import javax.inject.Inject;

import com.google.gwt.event.shared.EventBus;
import com.google.gwt.event.shared.GwtEvent.Type;
import com.gwtplatform.mvp.client.Presenter;
import com.gwtplatform.mvp.client.View;
import com.gwtplatform.mvp.client.annotations.ContentSlot;
import com.gwtplatform.mvp.client.annotations.ProxyStandard;
import com.gwtplatform.mvp.client.proxy.Proxy;
import com.gwtplatform.mvp.client.proxy.RevealContentHandler;
import com.gwtplatform.mvp.client.proxy.RevealRootLayoutContentEvent;

/**
 * The main presenter is meant to hold both the navigation bar and the central content.
 */
public class MainPresenter extends Presenter<MainPresenter.MyView, MainPresenter.MyProxy> {

  @ProxyStandard
  public interface MyProxy extends Proxy<MainPresenter> { }

  public interface MyView extends View { }

  @ContentSlot
  public static final Type<RevealContentHandler<?>> CENTRAL_SLOT_TYPE = new Type<RevealContentHandler<?>>();

  @Inject
  public MainPresenter(EventBus eventBus, MyView view, MyProxy proxy) {
    super(eventBus, view, proxy);
  }
  
  @Override
  protected void revealInParent() {
    RevealRootLayoutContentEvent.fire(this, this);
  }

}
