/**
 * 
 */
package com.settinghead.wexpression.wordlist;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import org.hibernate.annotations.GenericGenerator;
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
	private int userId;

	public WordList() {
	}

	public WordList(int userId, Counter<String> allWords) {
		ArrayList<Word> l = new ArrayList<Word>();
		for (String word : allWords.keySet())
			l.add(new Word(word, allWords.getCount(word)));
		setList(l);
	}

	@Id @GeneratedValue(generator="system-uuid")
	@GenericGenerator(name="system-uuid", strategy = "uuid")
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public int getUserId() {
		return userId;
	}

	public void setUserId(int id) {
		this.userId = id;
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
