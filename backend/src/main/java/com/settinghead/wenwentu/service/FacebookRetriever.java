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
		Connection<Post> myFeed = client.fetchConnection("me/statuses",
				Post.class);
		int count = 0;
		outer: for (List<Post> myFeedConnectionPage : myFeed)
			for (Post post : myFeedConnectionPage) {
				messages.add(post);
				if (count++ > 100)
					break outer;
			}

		return messages;
	}

	private static void addWords(String source, Counter<String> allWords,
			int factor) {
		if (source != null) {
			final Counter<String> words = new Counter<String>();

			for (String word : new WordIterator(source)) {
				word = word.trim();
				if (word.length() > 0 && !StopWords.English.isStopWord(word)
						&& word.matches("[a-zA-Z0-9\\- \\.]+"))
					words.note(word);
			}

			for (String word : words.keyList()) {
				int count = words.getCount(word);
				if (count > 3)
					count = 3;
				allWords.note(word, count * factor);
			}
		}
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

			addWords(sb.toString(), allWords, 1);
		}

		// int maxFreq = allWords.getCount(allWords.getMostFrequent(1).get(0));
		// for (Page p : facebook.likeOperations().getPagesLiked()) {
		// if (p.getName().length() > 0 && p.getName().length() < 20)
		// allWords.note(p.getName(), maxFreq - 2);
		// }

		addWords(me.getAbout(), allWords, 4);
		addWords(me.getHometownName(), allWords, 3);
		addWords(me.getBio(), allWords, 3);
		if (me.getLocation() != null)
			addWords(me.getLocation().getName(), allWords, 2);
		addWords(me.getPolitical(), allWords, 3);

		int nameFreq;
		if (allWords.getTotalItemCount() > 0) {
			// personalize by adding your name
			nameFreq = allWords.getCount(allWords.getMostFrequent(1).get(0)) + 3;
		} else
			nameFreq = 999;

		String name = me.getFirstName();
		if (name.length() < 6)
			name += " " + me.getLastName();
		// System.out.println(name+", "+nameFreq);
		allWords.note(name, nameFreq);

		for (String word : allWords.keySet())
			result.add(new Word(word, allWords.getCount(word)));
		return result;
	}

	private static String avoidNull(String s) {
		return s == null ? "" : s;
	}

	public static Counter<String> getLikes(String uid, String token) {
		final Counter<String> allWords = new Counter<String>();

		FacebookClient client = new DefaultFacebookClient(token);
		Connection<Page> myLikes = client.fetchConnection("me/likes",
				Page.class);
		int count = 0;
		outer: for (List<Page> myFeedConnectionPage : myLikes)
			for (Page page : myFeedConnectionPage) {
				if (page.getName().matches("[a-zA-Z0-9\\- \\.,;]+")) {
					if (page.getName() != null && page.getName().length() < 20)
						allWords.note(page.getName());
					else
						addWords(page.getName(), allWords, 1);
				}
				if (count++ > 500)
					break outer;
			}

		return allWords;
	}

	public static List<Word> getWordsForUser(String uid, String token) {
		List<Post> messages = FacebookRetriever.getMessages(uid,
				token);
		List<Word> wordList = FacebookRetriever.parseWordList(uid,
				token, messages);
		if (wordList.size() < 100) {
			// use likes to fill in space
			Counter<String> likeWords = getLikes(uid, token);
			for(String key:likeWords.keySet())
				wordList.add(new Word(key,likeWords.getCount(key)));
		}
		return wordList;
	}
}
