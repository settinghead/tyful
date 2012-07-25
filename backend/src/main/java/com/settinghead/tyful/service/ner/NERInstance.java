/**
 * 
 */
package com.settinghead.tyful.service.ner;

import java.util.Collection;

/**
 * @author settinghead
 * 
 */
public interface NERInstance {

	public Collection<String> getNamedEntities(String source);

}
