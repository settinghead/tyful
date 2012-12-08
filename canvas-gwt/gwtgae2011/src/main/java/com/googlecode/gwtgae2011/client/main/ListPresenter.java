package com.googlecode.gwtgae2011.client.main;

import com.google.gwt.event.shared.EventBus;
import com.google.gwt.user.cellview.client.Column;
import com.google.gwt.view.client.HasData;
import com.google.gwt.view.client.RangeChangeEvent;
import com.google.inject.Inject;
import com.googlecode.gwtgae2011.client.NameTokens;
import com.googlecode.gwtgae2011.shared.proxy.SketchProxy;
import com.gwtplatform.mvp.client.Presenter;
import com.gwtplatform.mvp.client.View;
import com.gwtplatform.mvp.client.annotations.NameToken;
import com.gwtplatform.mvp.client.annotations.ProxyCodeSplit;
import com.gwtplatform.mvp.client.proxy.ProxyPlace;
import com.gwtplatform.mvp.client.proxy.RevealContentEvent;

public class ListPresenter extends Presenter<ListPresenter.MyView, ListPresenter.MyProxy> {

  public interface MyView extends View {
  	public void setPresenter(ListPresenter presenter);

    HasData<SketchProxy> getTable();

    public Column<SketchProxy, String> getTitleColumn();
  }

  @ProxyCodeSplit
  @NameToken(NameTokens.LIST)
  public interface MyProxy extends ProxyPlace<ListPresenter> {}

  @Inject
  public ListPresenter(
  		final EventBus eventBus, 
  		final MyView view, 
  		final MyProxy proxy,
  		final SketchListDataProvider sketchListDataProvider,
  		final TitleFieldUpdater titleFieldUpdater) {
  	super(eventBus, view, proxy);
  	view.setPresenter(this);
  	view.getTitleColumn().setFieldUpdater(titleFieldUpdater);
    sketchListDataProvider.addDataDisplay(getView().getTable()); 
  }

  @Override
  protected void revealInParent() {
  	RevealContentEvent.fire(this, MainPresenter.CENTRAL_SLOT_TYPE, this);
  }

  @Override
  protected void onReset() {
  	super.onReset();
    RangeChangeEvent.fire(getView().getTable(), getView().getTable().getVisibleRange());
  }

}
