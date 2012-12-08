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

package com.googlecode.gwtgae2011.server;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Singleton;

import com.google.appengine.tools.appstats.AppstatsFilter;
import com.google.appengine.tools.appstats.AppstatsServlet;
import com.google.gwt.requestfactory.server.RequestFactoryServlet;
import com.google.inject.servlet.ServletModule;
import com.gwtplatform.dispatch.server.guice.DispatchServiceImpl;
import com.gwtplatform.dispatch.shared.ActionImpl;

/**
 * Guice module used to bind guice-injected servlets and filters with their URL.
 */
public class GwtGae2011ServletModule extends ServletModule {
  @Override
  public void configureServlets() {

    // AppStats filter and servlet
    bind(AppstatsFilter.class).in(Singleton.class);
    bind(AppstatsServlet.class).in(Singleton.class);
    
    Map<String, String> appstatsFilterParams = new HashMap<String, String>();
    appstatsFilterParams.put("logMessage", "Appstats available: /appstats/details?time={ID}");
    filter("/*").through(AppstatsFilter.class, appstatsFilterParams);
    serve("/appstats/*").with(AppstatsServlet.class);

    // RequestFactory servlet
    bind(RequestFactoryServlet.class).in(Singleton.class);
    serve("/gwtRequest").with(RequestFactoryServlet.class);
    
    // GWT-platform commands servlet
    serve("/" + ActionImpl.DEFAULT_SERVICE_NAME + "*").with(DispatchServiceImpl.class);

  }
}
