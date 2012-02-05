package com.settinghead.wexpression.data;

import java.io.Serializable;
import java.util.ArrayList;

import javax.persistence.Entity;
import javax.persistence.Id;

import org.springframework.transaction.annotation.Transactional;

import com.settinghead.wexpression.services.Friend;

@Entity
@Transactional
public class FriendList extends ArrayList<Friend> implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8014498111719816089L;

	@Id
//	@GeneratedValue
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	private String id;
}
