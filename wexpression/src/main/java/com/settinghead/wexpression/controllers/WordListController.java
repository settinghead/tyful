package com.settinghead.wexpression.controllers;

import java.nio.charset.Charset;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.Post;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.settinghead.wexpression.data.FacebookPostRepository;
import com.settinghead.wexpression.data.WordList;
import com.settinghead.wexpression.data.WordListRepository;

import cue.lang.Counter;
import cue.lang.WordIterator;
import cue.lang.stop.StopWords;

@Controller
@RequestMapping("/wordlists/**")
public class WordListController {
	private WordListRepository wordListRepository;

	@Autowired
	public void setWordListRepository(WordListRepository repo) {
		this.wordListRepository = repo;
	}
	
	@RequestMapping(value = "/{wordListId}", method = RequestMethod.GET, produces = {
		      MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public WordList getWordList(@PathVariable String wordListId) {
		return this.wordListRepository.getWordList(wordListId);
	}
	

	private final Facebook facebook;


	@Inject
	public WordListController(Facebook facebook) {
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

//			// get comments by self
//			if (post.getComments() != null)
//				for (Comment comment : post.getComments()) {
//					if (comment.getFrom().getId().equals(userId))
//						sb.append(comment.getMessage()).append(". ");
//				}

			final Counter<String> words = new Counter<String>();

			StopWords.English.readStopWords(HomeController.class
					.getResourceAsStream("stopwords_1000.txt"), Charset
					.defaultCharset());

			for (String word : new WordIterator(sb.toString())) {
				word = word.trim();
				if (word.length() > 0 && !StopWords.English.isStopWord(word))
					words.note(word);
			}

			for (String word : words.keyList()) {
				int count = words.getCount(word);
				if (count > 5)
					count = 5;
				allWords.note(word, count);
			}
		}

//		int maxFreq = allWords.getCount(allWords.getMostFrequent(1).get(0));
//		for (Page p : facebook.likeOperations().getPagesLiked()) {
//			if (p.getName().length() > 0 && p.getName().length() < 20)
//				allWords.note(p.getName(), maxFreq - 2);
//		}

		// personalize by adding your name
		int nameFreq = allWords.getCount(allWords.getMostFrequent(1).get(0)) + 3;
		String name = facebook.userOperations().getUserProfile().getFirstName();
		// System.out.println(name+", "+nameFreq);
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
