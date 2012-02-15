/**
 * 
 */
package com.settinghead.wexpression.data.template.placer;

import com.settinghead.wexpression.data.template.Template;

/**
 * @author settinghead
 *
 */
public class ShapeConfinedPlacer implements WordPlacer {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5448123175499527061L;
	private Template template;
	/**
	 * @param template the template to set
	 */
	public void setTemplate(Template template) {
		this.template = template;
	}
	/**
	 * @return the template
	 */
	public Template getTemplate() {
		return template;
	}
}
