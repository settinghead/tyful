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
package org.springframework.social.quickstart;

import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.facebook.api.Comment;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.Post;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.settinghead.wexpression.data.FacebookPostRepository;
import com.settinghead.wexpression.data.WordList;
import com.settinghead.wexpression.data.WordListRepository;

import cue.lang.Counter;
import cue.lang.WordIterator;
import cue.lang.stop.StopWords;

/**
 * Simple little @Controller that invokes Facebook and renders the result. The
 * injected {@link Facebook} reference is configured with the required
 * authorization credentials for the current user behind the scenes.
 * 
 * @author Keith Donald
 */
@Controller
public class HomeController {

	private final Facebook facebook;

	private WordListRepository wordListRepository;

	@Autowired
	public void setWordListRepository(WordListRepository repo) {
		this.wordListRepository = repo;
	}

	@Inject
	public HomeController(Facebook facebook) {
		this.facebook = facebook;
	}

	private FacebookPostRepository fbPosts;

	@Inject
	public void setFbPosts(FacebookPostRepository fbPosts) {
		this.fbPosts = fbPosts;
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {
		String userId = facebook.userOperations().getUserProfile().getId();
		System.out.println("Current user ID: " + userId);
		List<Post> posts = fbPosts.getPosts(userId, 400, facebook);

		final Counter<String> allWords = new Counter<String>();

		for (Post post : posts) {
			StringBuilder sb = new StringBuilder();

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

			// get comments by self
			if (post.getComments() != null)
				for (Comment comment : post.getComments()) {
					if (comment.getFrom().getId().equals(userId))
						sb.append(comment.getMessage()).append(". ");
				}

			final Counter<String> words = new Counter<String>();
			for (final String word : new WordIterator(sb.toString())) {
				if (!StopWords.English.isStopWord(word))
					words.note(word);
			}

			for (String word : words.keyList()) {
				int count = words.getCount(word);
				if (count > 5)
					count = 5;
				allWords.note(word, count);
			}
		}
		
		//personalize by adding your name
		int nameFreq = allWords.getCount(allWords.getMostFrequent(1).get(0)) + 3;
		String name = facebook.userOperations().getUserProfile().getFirstName();
		//System.out.println(name+", "+nameFreq);
		allWords.note(name, nameFreq);
		WordList list = new WordList(allWords);
		
		wordListRepository.saveWordList(list);
		model.addAttribute("wordListId", list.getId());

		return "home";

	}

	public String avoidNull(String s) {
		return s == null ? "" : s;
	}

}