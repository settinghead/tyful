/**
 * 
 */
package com.settinghead.wexpression.data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import org.springframework.transaction.annotation.Transactional;

import cue.lang.Counter;

/**
 * @author settinghead
 * 
 */
@Entity
@Transactional
public class WordList implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 493220206236620029L;
	private String id;
	private List<Word> list;

	public WordList() {
	}

	public WordList(Counter<String> allWords) {
		ArrayList<Word> l = new ArrayList<Word>();
		for (String word : allWords.keySet())
			l.add(new Word(word, allWords.getCount(word)));
		setList(l);
	}

	@Id
	// @GenericGenerator(name = "generator", strategy = "guid", parameters = {})
	@GeneratedValue
	// (generator = "generator")
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @param list
	 *            the list to set
	 */
	public void setList(List<Word> list) {
		this.list = list;
	}

	/**
	 * @return the list
	 */
	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	public List<Word> getList() {
		return list;
	}
}
