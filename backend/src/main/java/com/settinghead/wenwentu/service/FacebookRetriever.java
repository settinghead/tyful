package com.settinghead.wenwentu.service;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.SortedSet;

import com.restfb.Connection;
import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.types.Page;
import com.restfb.types.Post;
import com.restfb.types.User;
import com.settinghead.wenwentu.service.model.Word;

import cue.lang.Counter;
import cue.lang.WordIterator;
import cue.lang.stop.StopWords;

public class FacebookRetriever {

	static {
		StopWords.English.readStopWords(FacebookRetriever.class
				.getResourceAsStream("/stopwords_1000.txt"), Charset
				.defaultCharset());
	}

	public static List<Post> getMessages(String uid, String token) {
		ArrayList<Post> messages = new ArrayList<Post>();

		FacebookClient client = new DefaultFacebookClient(token);
		Connection<Post> myFeed = client
				.fetchConnection("me/posts", Post.class);
		int count = 0;
		outer: for (List<Post> myFeedConnectionPage : myFeed)
			for (Post post : myFeedConnectionPage) {
				messages.add(post);
				if (count++ > 100)
					break outer;
			}

		return messages;
	}

	public static List<Word> parseWordList(String uid, String token,
			List<Post> posts) {
		FacebookClient facebookClient = new DefaultFacebookClient(token);
		User me = facebookClient.fetchObject("me", User.class);

		ArrayList<Word> result = new ArrayList<Word>();
		final Counter<String> allWords = new Counter<String>();

		for (Post post : posts) {
			StringBuilder sb = new StringBuilder();

			if (post.getFrom().getId().equals(uid)) {
				sb.append(avoidNull(post.getMessage())).append(". ");

			}

			// // get comments by self
			// if (post.getComments() != null)
			// for (Comment comment : post.getComments()) {
			// if (comment.getFrom().getId().equals(userId))
			// sb.append(comment.getMessage()).append(". ");
			// }

			final Counter<String> words = new Counter<String>();

			for (String word : new WordIterator(sb.toString())) {
				word = word.trim();
				if (word.length() > 0 && !StopWords.English.isStopWord(word)
						&& word.matches("[a-zA-z0-9\\-]*"))
					words.note(word);
			}

			for (String word : words.keyList()) {
				int count = words.getCount(word);
				if (count > 3)
					count = 3;
				allWords.note(word, count);
			}
		}

		// int maxFreq = allWords.getCount(allWords.getMostFrequent(1).get(0));
		// for (Page p : facebook.likeOperations().getPagesLiked()) {
		// if (p.getName().length() > 0 && p.getName().length() < 20)
		// allWords.note(p.getName(), maxFreq - 2);
		// }

		if (allWords.getTotalItemCount() > 0) {
			// personalize by adding your name
			int nameFreq = allWords
					.getCount(allWords.getMostFrequent(1).get(0)) + 3;
			String name = me.getFirstName();
			// System.out.println(name+", "+nameFreq);
			allWords.note(name, nameFreq);
			for (String word : allWords.keySet())
				result.add(new Word(word, allWords.getCount(word)));
		}
		return result;
	}

	private static String avoidNull(String s) {
		return s == null ? "" : s;
	}

	public static Collection<? extends Word> getLikes(String uid, String token) {
		FacebookClient client = new DefaultFacebookClient(token);
		ArrayList<Word> result = new ArrayList<Word>();
		Connection<Page> myLikes = client.fetchConnection("me/likes",
				Page.class);
		int count = 0;
		outer: for (List<Page> myFeedConnectionPage : myLikes)
			for (Page page : myFeedConnectionPage) {
				result.add(new Word(page.getName(), 1));
				if (count++ > 500)
					break outer;
			}

		return result;
	}
}
