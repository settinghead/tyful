/*
 * Copyright 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.settinghead.wexpression.web;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import java.util.Scanner;
import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.facebook.api.Comment;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.Post;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.settinghead.wexpression.data.FacebookPosts;

import wordcram.WordCramImage;

/**
 * Simple little @Controller that invokes Facebook and renders the result. The
 * injected {@link Facebook} reference is configured with the required
 * authorization credentials for the current user behind the scenes.
 * 
 * @author Keith Donald
 */
@Controller
public class WordListController {

	private final Facebook facebook;
	static String extraStopWords = "";
	private FacebookPosts fbPosts;
	private ConnectionRepository connectionRepository;

	@Inject
	public void setFbPosts(FacebookPosts fbPosts) {
		this.fbPosts = fbPosts;
	}

	static {
		try {
			// TODO: change
			extraStopWords = new Scanner(
					new File(
							"/Users/settinghead/wexpression/wexpression-web/"
									+ "src/main/java/com/settinghead/wexpression/web/stopwords.txt"))
					.useDelimiter("\\Z").next().replace("\r\n", " ")
					.replace('\n', ' ').replace('\r', ' ');
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@Inject
	public WordListController(Facebook facebook, FacebookPosts fbPosts,
			ConnectionRepository connectionRepository)
			throws IOException {
		this.facebook = facebook;
		this.setFbPosts(fbPosts);

		this.connectionRepository = connectionRepository;
	}

	public String avoidNull(String s) {
		return s == null ? "" : s;
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model, HttpServletResponse response)
			throws IOException {
		String userId = facebook.userOperations().getUserProfile().getId();
		System.out.println("Current user ID: " + userId);
		List<Post> posts = fbPosts.getPosts(userId, 400, facebook);

		// System.out.println(posts.get(0).getMessage());
		// List<Reference> friends = facebook.friendOperations().getFriends();
		model.addAttribute("posts", posts);
		StringBuilder sb = new StringBuilder();
		for (Post post : posts) {
			if (post.getFrom().getId().equals(userId)) {

				// System.out.println(post.getType() + ": msg: "
				// + post.getMessage() + "; name: " + post.getName()
				// + "; desc: " + post.getDescription() + "; caption: "
				// + post.getCaption());

				switch (post.getType()) {
				case VIDEO:
					sb.append(avoidNull(post.getName())).append(". ")
							.append(avoidNull(post.getMessage())).append(". ");
					break;
				default:
					sb.append(avoidNull(post.getDescription())).append(". ")
							.append(avoidNull(post.getMessage())).append(". ")
					// .append(avoidNull(post.getCaption())).append(". ")
					// .append(avoidNull(post.getName())).append(". ")
					;
					break;
					
				}
			}

			if (post.getComments() != null)
				for (Comment comment : post.getComments()) {
					if (comment.getFrom().getId().equals(userId))
						sb.append(comment.getMessage()).append(". ");
				}
		}

		return "home";
	}
}