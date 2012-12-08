package com.googlecode.gwtgae2011.client.cell;

import com.google.gwt.cell.client.AbstractCell;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;
import com.googlecode.gwtgae2011.client.NameTokens;

/**
 * A custom cell that links to the specified URL.
 */
public class LinkCell extends AbstractCell<Long> {

  @Override
  public void render(Context context, Long id, SafeHtmlBuilder sb) {

    // Always do a null check on the value. Cell widgets can pass null to cells
    // if the underlying data contains a null, or if the data arrives out of order.
    if (id == null) {
      return;
    }

    // Append some HTML that sets the text color.
    sb.appendHtmlConstant("<a href=\"#" + NameTokens.SKETCH + ";id=" + id.toString()
        + "\">view</a>");
  }

}

