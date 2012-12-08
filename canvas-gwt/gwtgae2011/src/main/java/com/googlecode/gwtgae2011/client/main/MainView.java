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

import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.LayoutPanel;
import com.google.gwt.user.client.ui.Widget;
import com.google.inject.Inject;
import com.gwtplatform.mvp.client.ViewImpl;

/**
 * The main view is a simple screen split horizontally. The top bar is meant to contain a 
 * navigation bar, whereas the bottom part is meant to display the central content.
 */
public class MainView extends ViewImpl implements MainPresenter.MyView {

  private final Widget widget;

  public interface Binder extends UiBinder<Widget, MainView> { }
  
  @UiField
  public LayoutPanel center;

  @Inject
  public MainView(final Binder binder) {
    widget = binder.createAndBindUi(this);
  }
  
  @Override
  public Widget asWidget() {
    return widget;
  }

  @Override
  public void setInSlot(Object slot, Widget content) {
    if(slot == MainPresenter.CENTRAL_SLOT_TYPE) {
      center.clear();
      center.add(content);
    } else {
      super.setInSlot(slot, content);
    }
  }
}
