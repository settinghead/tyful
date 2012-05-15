/**
 * 
 */
package com.settinghead.wenwentu.service.extraction;

import maui.main.MauiWrapper;
import weka.core.Attribute;
import weka.core.FastVector;
import weka.core.Instance;
import weka.core.Instances;

import com.settinghead.wenwentu.service.model.WebArticle;

/**
 * @author settinghead
 * 
 */
public class MauiTTUWrapper extends MauiWrapper {

	private static final int NUMBER_OF_KEYWORDS_FOR_URL = 15;
	private static MauiTTUWrapper INSTANCE = null;

	private MauiTTUWrapper() {
		super("../maui/", "mesh", "keyphrextr");
	}

	/**
	 * Main method to extract the main topics from a given text
	 * 
	 * @param text
	 * @param topicsPerDocument
	 * @return
	 * @throws Exception
	 */
	public void extractTopics(WebArticle article) throws Exception {
		String text = "";
		if (article.getTitle() != null)
			text += article.getTitle() + " ";
		if (article.getMetaDescription() != null)
			text += article.getMetaDescription() + " ";
		if (article.getText() != null)
			text += article.getText();

		if (text.length() < 5) {
			throw new Exception("Text is too short!");
		}

		extractionModel.setWikipedia(null);

		FastVector atts = new FastVector(3);
		atts.addElement(new Attribute("filename", (FastVector) null));
		atts.addElement(new Attribute("doc", (FastVector) null));
		atts.addElement(new Attribute("keyphrases", (FastVector) null));
		Instances data = new Instances("keyphrase_training_data", atts, 0);

		double[] newInst = new double[3];

		newInst[0] = (double) data.attribute(0).addStringValue("inputFile");
		newInst[1] = (double) data.attribute(1).addStringValue(text);
		newInst[2] = Instance.missingValue();
		data.add(new Instance(1.0, newInst));

		extractionModel.input(data.instance(0));

		data = data.stringFreeStructure();
		Instance[] topRankedInstances = new Instance[NUMBER_OF_KEYWORDS_FOR_URL];
		Instance inst;

		// Iterating over all extracted keyphrases (inst)
		while ((inst = extractionModel.output()) != null) {

			int index = (int) inst.value(extractionModel.getRankIndex()) - 1;

			if (index < NUMBER_OF_KEYWORDS_FOR_URL) {
				topRankedInstances[index] = inst;
			}
		}

		for (int i = 0; i < NUMBER_OF_KEYWORDS_FOR_URL; i++) {
			if (topRankedInstances[i] != null) {
				double score = topRankedInstances[i].value(extractionModel
						.getProbabilityIndex());
				if (score > 0.4) {
					String topic = topRankedInstances[i]
							.stringValue(extractionModel.getOutputFormIndex());
					article.getKeywords().addScore(topic, score);
				}
			}
		}
		extractionModel.batchFinished();
	}

	public static MauiTTUWrapper getInstance() {
		if (INSTANCE == null)
			INSTANCE = new MauiTTUWrapper();
		return INSTANCE;
	}
}