package com.settinghead.wexpression.wordlist;

import org.springframework.core.task.TaskExecutor;

public class FacebookWordListTaskExecutor {

	private class MessagePrinterTask implements Runnable {

		private String message;

		public MessagePrinterTask(String message) {
			this.message = message;
		}

		public void run() {
			System.out.println(message);
		}

	}

	private TaskExecutor taskExecutor;

	public FacebookWordListTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}

	public void printMessages() {
		final Facebook facebook = (Facebook) ctx.getJobDetail().getJobDataMap()
				.get("facebook");
		final Integer userId = (Integer) ctx.getJobDetail().getJobDataMap()
				.get("userId");
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

		wordListRepository.saveWordList(list);
	}
	
	public String avoidNull(String s) {
		return s == null ? "" : s;
	}
}