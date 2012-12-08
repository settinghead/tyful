package com.googlecode.gwtgae2011.client.main;

import java.util.Date;

import com.gwtplatform.mvp.client.ViewImpl;
import com.google.gwt.cell.client.DateCell;
import com.google.gwt.cell.client.EditTextCell;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.cellview.client.CellTable;
import com.google.gwt.user.cellview.client.Column;
import com.google.gwt.user.cellview.client.SimplePager;
import com.google.gwt.user.client.ui.Widget;
import com.google.gwt.view.client.HasData;
import com.google.inject.Inject;
import com.googlecode.gwtgae2011.client.cell.LinkCell;
import com.googlecode.gwtgae2011.shared.proxy.SketchProxy;

public class ListView extends ViewImpl implements ListPresenter.MyView {

  private final Widget widget;

  public interface Binder extends UiBinder<Widget, ListView> { }

  @UiField(provided = true)
  CellTable<SketchProxy> table = new CellTable<SketchProxy>();
  
  @UiField(provided = true)
  SimplePager pager = new SimplePager();
  
  private Column<SketchProxy, String> titleColumn;

  @Inject
  public ListView(final Binder binder) {
    widget = binder.createAndBindUi(this);

    titleColumn = new Column<SketchProxy, String>(new EditTextCell()) {
      @Override
      public String getValue(SketchProxy sketch) {
        return sketch.getTitle();
      }
    };
    table.addColumn(titleColumn, "Title");

    Column<SketchProxy, Date> dateColumn = new Column<SketchProxy, Date>(new DateCell()) {
      @Override
      public Date getValue(SketchProxy sketch) {
        return sketch.getCreationDate();
      }
    };
    table.addColumn(dateColumn, "Created on");

    Column<SketchProxy, Long> linkColumn = new Column<SketchProxy, Long>(new LinkCell()) {
      @Override
      public Long getValue(SketchProxy sketch) {
        return sketch.getId();
      }
    };
    table.addColumn(linkColumn);
    
    pager.setDisplay(table);
  }

  @Override
  public Widget asWidget() {
    return widget;
  }

  @Override
  public HasData<SketchProxy> getTable()
  {
    return table;
  }

  @Override
  public void setPresenter(ListPresenter presenter) {
    // TODO Auto-generated method stub

  }

  @Override
  public Column<SketchProxy, String> getTitleColumn() {
    return titleColumn;
  }

}
