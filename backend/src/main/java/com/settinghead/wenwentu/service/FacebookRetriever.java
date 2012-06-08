package com.settinghead.wenwentu.service;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.restfb.Connection;
import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Parameter;
import com.restfb.types.Page;
import com.restfb.types.Post;
import com.restfb.types.User;
import com.settinghead.wenwentu.service.model.Occurence;
import com.settinghead.wenwentu.service.model.Word;

import cue.lang.Counter;
import cue.lang.WordIterator;
import cue.lang.stop.StopWords;

public class FacebookRetriever {

	static {
		StopWords.English.readStopWords(FacebookRetriever.class
				.getResourceAsStream("/stopwords_1000.txt"), Charset
				.defaultCharset());
		StopWords.English.readStopWords(FacebookRetriever.class
				.getResourceAsStream("/negative.txt"), Charset
				.defaultCharset());
	}

	public List<Post> getMessages(String uid, String token) {
		ArrayList<Post> messages = new ArrayList<Post>();

		FacebookClient client = new DefaultFacebookClient(token);
		Connection<Post> myFeed = client.fetchConnection(uid+"/posts",
				Post.class, Parameter.with("limit", "100"));
		int count = 0;
		outer: for (List<Post> myFeedConnectionPage : myFeed)
			for (Post post : myFeedConnectionPage) {
				messages.add(post);
				if (count++ > 100)
					break outer;
			}

		return messages;
	}

	private void addWords(String source, Counter<String> allWords, int factor,
			Occurence occurence) {
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
				pushToOccurenceMap(word, occurence);
			}
		}
	}

	private void pushToOccurenceMap(String key, Occurence occurence) {
		ArrayList<Occurence> v;
		if ((v = occurMap.get(key)) == null) {
			// first timer; create new arraylist
			occurMap.put(key, v = new ArrayList<Occurence>());
		}

		v.add(occurence);
	}

	private long differenceInDays(Date d1, Date d2) {
		long diff = d1.getTime() - d2.getTime();
		return (diff / (1000 * 60 * 60 * 24)) + 1;
	}

	public List<Word> parseWordList(String uid, String token, List<Post> posts) {
		FacebookClient facebookClient = new DefaultFacebookClient(token);
		User me = facebookClient.fetchObject(uid, User.class);

		ArrayList<Word> result = new ArrayList<Word>();
		final Counter<String> allWords = new Counter<String>();
		// int integralArea = 0;
		if (posts.size() > 0) {

			Date earliest = posts.get(posts.size() - 1).getCreatedTime();
			Date latest = posts.get(0).getCreatedTime();
			long span = differenceInDays(latest, earliest);
			//
			// //calculate day integral
			// for (Post post : posts) {
			// long diff = differenceInDays(post.getCreatedTime(), earliest);
			// assert(diff>=0);
			// integralArea+=diff;
			// }

			for (Post post : posts) {
				StringBuilder sb = new StringBuilder();

				if (!(post.getPrivacy() != null
						&& post.getPrivacy().getValue() != null && post
						.getPrivacy().getValue().equals("SELF"))
						&& post.getFrom().getId().equals(uid)) {
					sb.append(avoidNull(post.getMessage())).append(". ");

				}

				// // get comments by self
				// if (post.getComments() != null)
				// for (Comment comment : post.getComments()) {
				// if (comment.getFrom().getId().equals(userId))
				// sb.append(comment.getMessage()).append(". ");
				// }
				addWords(
						sb.toString(),
						allWords,
						12 + (int) (differenceInDays(post.getCreatedTime(),
								earliest) * 16 / span),
						new Occurence(post.getId(), "post", post.getLink()));
			}
		}

		// int maxFreq = allWords.getCount(allWords.getMostFrequent(1).get(0));
		// for (Page p : facebook.likeOperations().getPagesLiked()) {
		// if (p.getName().length() > 0 && p.getName().length() < 20)
		// allWords.note(p.getName(), maxFreq - 2);
		// }

		addWords(me.getAbout(), allWords, 80, new Occurence(me.getId(),
				"about", me.getLink()));
		addWords(me.getHometownName(), allWords, 60,
				new Occurence(me.getHometownName(), "hometown", me.getLink()));
		addWords(me.getBio(), allWords, 60,
				new Occurence(me.getId(), "bio", me.getLink()));
		if (me.getLocation() != null)
			addWords(me.getLocation().getName(), allWords, 40, new Occurence(me
					.getLocation().getId(), "location", me.getLink()));
		addWords(me.getPolitical(), allWords, 60, new Occurence(me.getId(),
				"political", me.getLink()));

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
			result.add(new Word(word, allWords.getCount(word), occurMap
					.get(word)));
		return result;
	}

	private String avoidNull(String s) {
		return s == null ? "" : s;
	}

	public Counter<String> getLikes(String uid, String token) {
		final Counter<String> allWords = new Counter<String>();

		FacebookClient client = new DefaultFacebookClient(token);
		Connection<Page> myLikes = client.fetchConnection(uid+"/likes",
				Page.class);
		int count = 0;
		outer: for (List<Page> myFeedConnectionPage : myLikes)
			for (Page page : myFeedConnectionPage) {
				if (page.getName().matches("[a-zA-Z0-9\\- \\.,;]+")) {
					if (page.getName() != null && page.getName().length() < 20) {
						allWords.note(page.getName(), 2);
						addWords(page.getName(), allWords, 10, new Occurence(
								page.getId(), "page", page.getLink()));
					} else
						addWords(page.getName(), allWords, 20, new Occurence(
								page.getId(), "page", page.getLink()));
				}
				if (count++ > 500)
					break outer;
			}

		return allWords;
	}

	private HashMap<String, ArrayList<Occurence>> occurMap = new HashMap<String, ArrayList<Occurence>>();

	public List<Word> getWordsForUser(String targetUid, String uid, String token) {
		List<Post> messages = getMessages(targetUid, token);
		List<Word> wordList = parseWordList(targetUid, token, messages);
		if (wordList.size() < 100) {
			// use likes to fill in space
			Counter<String> likeWords = getLikes(targetUid, token);
			for (String key : likeWords.keySet())
				wordList.add(new Word(key, likeWords.getCount(key), occurMap
						.get(key)));
		}
		return wordList;
	}
}
