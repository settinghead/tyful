package com.settinghead.wenwentu.service.model;

import java.io.IOException;
import java.io.StringReader;
import java.util.Arrays;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.apache.lucene.index.TermFreqVector;


/**
 * 
 * @author Xiyang Chen
 * 
 */
public class TermCountTable extends ScoreTable<TermItem> implements
		java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2907133036433712385L;
	private static final int ARTICLE_SUMMARY_LENGTH = 80;
	private static final int INITIAL_SUMMARY_BOOST = 20;
	private static final int END_SUMMARY_BOOST = 1;
	private double totalTermCount = 0;

	public TermCountTable truncate(int maxLimit) {
		TermCountTable newTft = new TermCountTable();
		int size = Math.min(maxLimit, size());
		Iterator<TermItem> iterator = this.iterator();
		int i = 0;
		while (iterator.hasNext() && i < size) {
			newTft.add(iterator.next());
			i++;
		}
		return newTft;
	}

	/**
	 * Returns (frequency:term) pairs for the top N distinct terms (aka words),
	 * sorted descending by frequency (and ascending by term, if tied).
	 * <p>
	 * Example XQuery:
	 * 
	 * <pre>
	 * declare namespace util = "java:org.apache.lucene.index.memory.AnalyzerUtil";
	 * declare namespace analyzer = "java:org.apache.lucene.index.memory.PatternAnalyzer";
	 * 
	 * for $pair in util:get-most-frequent-terms(
	 *    analyzer:EXTENDED_ANALYZER(), doc("samples/shakespeare/othello.xml"), 10)
	 * return &lt;word word="{substring-after($pair, ':')}" frequency="{substring-before($pair, ':')}"/>
	 * </pre>
	 * 
	 * @param analyzer
	 *            the analyzer to use for splitting text into terms (aka words)
	 * @param text
	 *            the text to analyze
	 * @param limit
	 *            the maximum number of pairs to return; zero indicates
	 *            "as many as possible".
	 * @return an array of (frequency:term) pairs in the form of (freq0:term0,
	 *         freq1:term1, ..., freqN:termN). Each pair is a single string
	 *         separated by a ':' delimiter.
	 */
	@SuppressWarnings("unchecked")
	public static TermCountTable getMostFrequentTerms(final Analyzer analyzer,
			final String text, int limit) {
		if (analyzer == null)
			throw new IllegalArgumentException("analyzer must not be null");
		if (text == null)
			throw new IllegalArgumentException("text must not be null");
		if (limit <= 0)
			limit = Integer.MAX_VALUE;

		// compute frequencies of distinct terms
		HashMap<String, Double> map = new HashMap<String, Double>();
		TokenStream stream = analyzer.tokenStream("", new StringReader(text));
		CharTermAttribute token = stream.addAttribute(CharTermAttribute.class);

		int termCount = 0;
		try {
			while (stream.incrementToken()) {
				String term = new String(token.buffer(), 0, token.length());
				Double freq = map.get(term);
				if (freq == null) {
					freq = new Double(getBoostByPosition(termCount,
							text.length() / 6));
					map.put(term, freq);
				} else {
					map.put(term,
							freq.doubleValue()
									+ getBoostByPosition(termCount,
											text.length() / 6));
				}

				termCount++;
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		} finally {
			try {
				stream.close();
			} catch (IOException e2) {
				throw new RuntimeException(e2);
			}
		}

		// sort by frequency, text
		Map.Entry<String, Double>[] entries = new Map.Entry[map.size()];
		map.entrySet().toArray(entries);
		Arrays.sort(entries, new Comparator<Map.Entry<String, Double>>() {
			public int compare(final Map.Entry<String, Double> e1,
					final Map.Entry<String, Double> e2) {
				int f1 = e1.getValue().intValue();
				int f2 = e2.getValue().intValue();
				if (f2 - f1 != 0)
					return f2 - f1;
				String s1 = e1.getKey();
				String s2 = e2.getKey();
				return s1.compareTo(s2);
			}
		});

		// return top N entries
		int size = Math.min(limit, entries.length);
		TermCountTable table = new TermCountTable();
		// String[] pairs = new String[size];
		for (int i = 0; i < size; i++) {
			// pairs[i] = entries[i].getValue() + ":" + entries[i].getKey();
			table.addScore(entries[i].getKey(), entries[i].getValue()
					.doubleValue());
		}
		return table;
	}

	private static double getBoostByPosition(final int termCount,
			final int lengthOfArticle) {
		if (termCount < ARTICLE_SUMMARY_LENGTH) {
			return INITIAL_SUMMARY_BOOST
					- (INITIAL_SUMMARY_BOOST - END_SUMMARY_BOOST)
					/ (ARTICLE_SUMMARY_LENGTH - termCount);
		} else {
			// arccotangent(x) = arctangent(1/x)+pi
			// c.f.
			// http://en.wikipedia.org/wiki/File:Arctangent_Arccotangent.svg
			return (Math
					.atan((1 / (double) (termCount - ARTICLE_SUMMARY_LENGTH))) + Math.PI)
					/ (Math.PI / 2);
		}
	}

	@Override
	public void addScore(String key, final double value) {
		key = key.toLowerCase().trim();
		super.addScore(key, value, new TermItem(key, value));
		totalTermCount += value;
	}

	@Override
	public void replaceGreaterScore(String key, final double value) {
		key = key.toLowerCase().trim();
		super.replaceGreaterScore(key, value, new TermItem(key, value));
		totalTermCount += value;
	}

	@Override
	public TermCountTable getTop(final int n) {
		TermCountTable result = new TermCountTable();
		getTop(result, n);
		return result;
	}

	public TermCountTable getOverlappingTerms(final TermFreqVector tfvDoc) {
		TermCountTable result = new TermCountTable();
		for (TermItem term : this) {
			int index = tfvDoc.indexOf(term.getKey());
			if (index >= 0) {
				result.addScore(term.getKey(),
						tfvDoc.getTermFrequencies()[index] * term.getScore()
								/ getTotalTermCount());
			}
		}
		return result;
	}

	private double getTotalTermCount() {
		return totalTermCount;
	}

	@Override
	public boolean addAll(final Collection<? extends TermItem> c) {
		boolean changed = false;
		for (TermItem t : c) {
			this.addScore(t.getKey(), t.getScore());
			changed = true;
		}
		return changed;
	}

	public String toWeightedQueryString(final String[] fieldNames) {
		StringBuilder sb = new StringBuilder();
		Iterator<TermItem> iterator = iterator();
		while (iterator.hasNext()) {
			TermItem item = iterator.next();
			sb.append("(");
			for (int i = 0; i < fieldNames.length; i++) {
				sb.append('"').append(fieldNames[i]).append('"').append(":")
						.append(item.getKey());
				if (i < fieldNames.length - 1)
					sb.append(" OR ");
			}
			sb.append(")^" + Float.toString((float) item.getScore()) + " ");
		}
		// remove trailing space
		sb.deleteCharAt(sb.length() - 1);
		return sb.toString();
	}

	@Override
	public void clear() {
		super.clear();
		this.totalTermCount = 0;
	}

	public String toCSV(String linePrefix) {
		Iterator<TermItem> iterator = this.iterator();
		StringBuilder sb = new StringBuilder();
		while (iterator.hasNext()) {
			TermItem next = iterator.next();
			sb.append(linePrefix).append(next.getKey()).append(',').append(' ')
					.append(next.getScore()).append('\r').append('\n');
		}
		return sb.toString();
	}
}
