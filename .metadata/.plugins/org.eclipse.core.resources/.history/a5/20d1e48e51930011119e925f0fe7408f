/**
 * 
 */
package com.settinghead.wenwentu.service.extraction;

import com.settinghead.wenwentu.service.model.WebArticle;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.net.URI;

/**
 * @author settinghead
 * 
 */
public abstract class ArticleExtractor {

	private WebArticle article;

	public ArticleExtractor(WebArticle article) {
		this.article = article;
	}

	/**
	 * method that performs the extraction task
	 */
	protected abstract void extractInternal();

	public final void extract() {
		if (!article.getExtractorSignatures().contains(
				this.getClass().getSimpleName())) {
			extractInternal();
			article.setPendingChangeFlag(true);
			article.getExtractorSignatures().add(
					this.getClass().getSimpleName());
		}
	}

	protected WebArticle getArticle() {
		return article;
	}

	public static void main(String[] args) {
		try {
			ArticleExtractor[] extractors = new ArticleExtractor[args.length - 1];
			WebArticle article = new WebArticle(
					new URI(args[args.length - 1]).toURL());
			if (args.length > 0) {
				for (int i = 0; i < args.length - 1; i++) {
					extractors[i] = getExtractor(args[i], article);
					extractors[i].extract();
				}
			}
			System.out.println(article.toJsonString());
		} catch (Exception e) {
			System.out.println("{\"error\":\"" + e.getMessage() + "\"}");
		}
	}

	@SuppressWarnings("unchecked")
	public static ArticleExtractor getExtractor(String extractorName,
			WebArticle article) throws ClassNotFoundException,
			SecurityException, NoSuchMethodException, IllegalArgumentException,
			InstantiationException, IllegalAccessException,
			InvocationTargetException {
		String packageName = ArticleExtractor.class.getPackage().getName();
		// camel form
		extractorName = extractorName.substring(0, 1).toUpperCase()
				+ extractorName.substring(1).toLowerCase();
		String extractorClassName = packageName + "." + extractorName
				+ "Extractor";
		Class<ArticleExtractor> extractorClass = (Class<ArticleExtractor>) Class
				.forName(extractorClassName);
		Constructor<ArticleExtractor> ct = extractorClass
				.getConstructor(WebArticle.class);
		return ct.newInstance(article);
	}

	public static void extract(WebArticle article, String extractionFilters) {
		String[] extractors = extractionFilters.split(" ");
		// extractors = new String[] { "alchemyapi" };
		for (int i = 0; i < extractors.length; i++)
			if (!article.getExtractorSignatures().contains(extractors[i]))
				try {
					ArticleExtractor.getExtractor(extractors[i], article)
							.extract();
				} catch (Exception e) {
					e.printStackTrace();
				}

	}
}
