package com.settinghead.wexpression.data;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.Post;
import org.springframework.stereotype.Repository;

@Repository
public class WordListRepo {
	@Cacheable(value = "wordListCache", key = "#listId")
	public List<Post> getLists(String listId) {
		//TODO
		return null;
	}
}
