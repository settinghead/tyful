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

import com.gwtplatform.mvp.client.gin.AbstractPresenterModule;
import com.googlecode.gwtgae2011.client.main.ListPresenter;
import com.googlecode.gwtgae2011.client.main.ListView;

public class MainModule extends AbstractPresenterModule {
  @Override
  protected void configure() {
    // Presenters
    bindPresenter(MainPresenter.class, MainPresenter.MyView.class,
        MainView.class, MainPresenter.MyProxy.class);
    bindPresenter(SketchPresenter.class, SketchPresenter.MyView.class,
        SketchView.class, SketchPresenter.MyProxy.class);
	bindPresenter(ListPresenter.class, ListPresenter.MyView.class, ListView.class, ListPresenter.MyProxy.class);
  }
}
