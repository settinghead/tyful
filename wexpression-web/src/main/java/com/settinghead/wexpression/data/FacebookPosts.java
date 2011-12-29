/**
 * 
 */
package com.settinghead.wexpression.data;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.faces.bean.ManagedBean;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.Post;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author settinghead
 * 
 */

// @ManagedBean
@Repository
public class FacebookPosts {


	// //
	// @Resource(mappedName = "java:jboss/infinispan/web")
	// private org.infinispan.manager.CacheContainer container;
	// private Cache<String, List<Post>> cache;
	//
	// @PostConstruct
	// public void start() {
	// this.cache = this.container.getCache();
	// }

	// @Transactional

	@Cacheable(value = "fbPostsCache", key = "#fbId")
	public List<Post> getPosts(String fbId, int limit, Facebook facebook) {
		List<Post> posts;

		System.err
				.println("Retrieving posts from Facebook Graph API for user ID "
						+ fbId);
		posts = facebook.feedOperations().getPosts(fbId, 0, limit);

		return posts;
	}
}
