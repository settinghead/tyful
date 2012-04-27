package com.settinghead.wexpression.wordlist;

import java.nio.charset.Charset;
import java.security.Principal;
import java.util.List;

import javax.inject.Inject;
import javax.inject.Provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Async;
import org.springframework.social.connect.Connection;
import org.springframework.social.connect.ConnectionRepository;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.Post;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.social.twitter.api.Twitter;

import com.settinghead.wexpression.HomeController;
import com.settinghead.wexpression.account.Account;
import com.settinghead.wexpression.account.AccountRepository;
import com.settinghead.wexpression.facebook.FacebookPostRepository;

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

	@RequestMapping(value = "/{wordListId}", method = RequestMethod.GET, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public WordList getWordList(@PathVariable String wordListId) {
		return this.wordListRepository.getWordList(wordListId);
	}

	private final Provider<ConnectionRepository> connectionRepositoryProvider;

	@Inject
	private AccountRepository accountRepository;

	@Inject
	public WordListController(
			Provider<ConnectionRepository> connectionRepositoryProvider) {
		this.connectionRepositoryProvider = connectionRepositoryProvider;
	}

	@Inject
	private FacebookPostRepository fbPosts;

	@Inject
	public void setFbPosts(FacebookPostRepository fbPosts) {
		this.fbPosts = fbPosts;
	}

	@Inject
	private ConnectionRepository connectionRepository;

	private Facebook getFacebook() {
		Connection<Facebook> connection = connectionRepository
				.findPrimaryConnection(Facebook.class);
		return connection.getApi();
	}

	private Twitter getTwitter() {
		Connection<Twitter> connection = connectionRepository
				.findPrimaryConnection(Twitter.class);
		return connection.getApi();
	}

	@RequestMapping(value = "/facebook", method = RequestMethod.GET, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public String facebook(Principal currentUser, Model model) {
		generateFacebookList(currentUser);
		return "ok";
	}

	@Async
	private void generateFacebookList(Principal currentUser) {
		final Facebook facebook = getFacebook();
		Account account = accountRepository.findAccountByUsername(currentUser
				.getName());

		final Integer userId = account.getId();
		String userFbId = facebook.userOperations().getUserProfile().getId();
		System.out.println("Current user FB ID: " + userFbId);
		List<Post> posts = fbPosts.getPosts(userFbId, 400, facebook);
		final Counter<String> allWords = new Counter<String>();

		for (Post post : posts) {
			StringBuilder sb = new StringBuilder();

			if (post.getFrom().getId().equals(userFbId)) {

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

			// // get comments by self
			// if (post.getComments() != null)
			// for (Comment comment : post.getComments()) {
			// if (comment.getFrom().getId().equals(userId))
			// sb.append(comment.getMessage()).append(". ");
			// }

			final Counter<String> words = new Counter<String>();

			StopWords.English.readStopWords(WordListController.class
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

		// int maxFreq = allWords.getCount(allWords.getMostFrequent(1).get(0));
		// for (Page p : facebook.likeOperations().getPagesLiked()) {
		// if (p.getName().length() > 0 && p.getName().length() < 20)
		// allWords.note(p.getName(), maxFreq - 2);
		// }

		// personalize by adding your name
		int nameFreq = allWords.getCount(allWords.getMostFrequent(1).get(0)) + 3;
		String name = facebook.userOperations().getUserProfile().getFirstName();
		// System.out.println(name+", "+nameFreq);
		allWords.note(name, nameFreq);
		WordList list = new WordList(userId, allWords);
		//TODO: remove
		try {
			Thread.sleep(20000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		wordListRepository.saveWordList(list);
	}

	@RequestMapping(value = "/", method = RequestMethod.GET, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public String home(Principal currentUser, Model model) {
		Account account = accountRepository.findAccountByUsername(currentUser
				.getName());
		wordListRepository.getListOfListIdsByUserId(account.getId());
		return String.valueOf(account.getId());

	}

	public String avoidNull(String s) {
		return s == null ? "" : s;
	}
}
