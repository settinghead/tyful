package com.settinghead.wenwentu.service.extraction.util;

/**
 * 
 * @author settinghead
 * 
 */
public class ExtractionHelpers {

	/**
	 * 
	 * @param keywords
	 * @return
	 */
	public static String[] splitKeywords(String keywords) {
		if (keywords == null || keywords.length() == 0)
			return new String[0];
		String[] keywordsArray = keywords.split(",");
		for (int i = 0; i < keywordsArray.length; i++)
			keywordsArray[i] = keywordsArray[i].trim().toLowerCase();
		return keywordsArray;
	}

	/** The string used to separator packages */
	public static final String PACKAGE_SEPARATOR = ".";

	/**
	 * Get the package name of the specified class.
	 * 
	 * @param classname
	 *            Class name.
	 * @return Package name or "" if the classname is in the <i>default</i>
	 *         package.
	 * 
	 * @throws EmptyStringException
	 *             Classname is an empty string.
	 */
	public static String getPackageName(Class _class) {
		final String classname = _class.getName();
		if (classname.length() == 0)
			System.out.println("Empty String Exception");

		int index = classname.lastIndexOf(PACKAGE_SEPARATOR);
		if (index != -1)
			return classname.substring(0, index);
		return "";
	}
}
