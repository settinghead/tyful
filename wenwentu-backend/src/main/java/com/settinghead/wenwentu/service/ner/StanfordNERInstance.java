/**
 * 
 */
package com.settinghead.wenwentu.service.ner;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Vector;


import edu.stanford.nlp.ie.AbstractSequenceClassifier;
import edu.stanford.nlp.ie.crf.CRFClassifier;
import edu.stanford.nlp.ling.CoreAnnotations.AnswerAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.NamedEntityTagAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.TextAnnotation;
import edu.stanford.nlp.sequences.SeqClassifierFlags;
import edu.stanford.nlp.util.CoreMap;
import edu.stanford.nlp.util.StringUtils;

/**
 * @author settinghead
 * 
 */
public class StanfordNERInstance implements NERInstance {

	public StanfordNERInstance() {
		init();
	}

	private static CRFClassifier<CoreMap> ner = null;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.threethumbsup.ner.NERInstance#getNamedEntities(java.lang.String)
	 */
	public Collection<String> getNamedEntities(String source) {
		return getNamedEntitiesFromText(source, this.ner);
	}

	protected static Collection<String> getNamedEntitiesFromText(
			final String text, AbstractSequenceClassifier<CoreMap> ner) {
		HashSet<String> entities = new HashSet<String>();

		final String background = SeqClassifierFlags.DEFAULT_BACKGROUND_SYMBOL;
		String prevTag = background;
		getNamedEntityClassifier();
		List<List<CoreMap>> out;
		out = ner.classify(text);
		for (List<CoreMap> sentence : out) {
			StringBuilder currentNE = new StringBuilder();
			for (Iterator<CoreMap> wordIter = sentence.iterator(); wordIter
					.hasNext();) {
				CoreMap wi = wordIter.next();

				String tag = StringUtils.getNotNullString(wi
						.get(AnswerAnnotation.class));

				String current = StringUtils.getNotNullString(wi
						.get(NamedEntityTagAnnotation.class));
				

				String t = StringUtils.getNotNullString(wi
						.get(TextAnnotation.class));
				if (!tag.equals(prevTag)) {

					if (!prevTag.equals(background) && !tag.equals(background)) {
						// start of a named entity
						currentNE.append(current);
					} else if (!prevTag.equals(background)) {
						// end of a named entity

						entities.add(currentNE.toString());
						currentNE = new StringBuilder();

					} else if (!tag.equals(background)) {
						currentNE.append(current);

					}
				} else {
					if (!tag.equals(background))
						currentNE.append(' ').append(current);
				}

				if (!tag.equals(background) && !wordIter.hasNext()) {

					prevTag = background;
				} else {
					prevTag = tag;
				}

			}
		}

		return entities;
	}

	@SuppressWarnings("unchecked")
	protected static synchronized CRFClassifier<CoreMap> getNamedEntityClassifier() {

		if (ner == null) {

			// first time use; initialize
			String serializedClassifier = "../stanford-ner/classifiers/conll.4class.distsim.crf.ser.gz";
			ner = CRFClassifier.getClassifierNoExceptions(serializedClassifier);
		}

		return ner;
	}

	public static void init() {
		getNamedEntityClassifier();
	}

}
