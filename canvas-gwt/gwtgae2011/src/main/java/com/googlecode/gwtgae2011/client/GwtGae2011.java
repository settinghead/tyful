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

package com.googlecode.gwtgae2011.client;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.GWT;

import com.gwtplatform.mvp.client.DelayedBindRegistry;

/**
 * GWT-GAE demo for GoogleIO 2011, entry point.
 */
public class GwtGae2011 implements EntryPoint {
  public final GwtGae2011Ginjector ginjector = GWT.create(GwtGae2011Ginjector.class);
  
  public void onModuleLoad() {
    // Wire the request factory nd the event bus
    ginjector.getRequestFactory().initialize(ginjector.getEventBus());

    DelayedBindRegistry.bind(ginjector);
    ginjector.getPlaceManager().revealCurrentPlace();
  }
}
