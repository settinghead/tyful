package com.settinghead.tyful.service.task;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;
import java.util.Random;

import com.restfb.BinaryAttachment;
import com.restfb.Connection;
import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Parameter;
import com.restfb.types.Album;
import com.restfb.types.FacebookType;

public class FbUploadTask extends Task {
	private static final String[] INTRO_STR = new String[] {
			" - Another tyful masterpiece (http://tyful.me)",
			" - Art for the ages (http://tyful.me)" };
	private String userId;
	private String fbToken;
	private String fbUid;
	private String imagePath;
	private String title;
	private String templateId;

	@Override
	public String getKey() {
		return "fbu_" + getUserId() + "_" + getTemplateId();
	}

	@Override
	public String perform() throws Exception {
		FacebookClient client = new DefaultFacebookClient(this.getFbToken());
		File file = new File(this.getImagePath());

		// find or create album "tyful"
		String albumId = null;

		Connection<Album> myAlbums = client.fetchConnection("me/albums",
				Album.class);
		outer: for (List<Album> albums : myAlbums) {
			for (Album album : albums) {
				if (album.getName().startsWith("Tyful")) {
					albumId = album.getId();
					break outer;
				}
			}
		}

		if (albumId == null)
		// create album
		{
			FacebookType albumconnection = client.publish(
					"me/albums",
					Album.class,
					Parameter.with("name", "Tyful"),
					Parameter.with("description",
							INTRO_STR[new Random().nextInt(INTRO_STR.length)]));
			albumId = albumconnection.getId();
		}
		FacebookType publishPhotoResponse = null;
		String title = this.getTitle();
		if (title == null || title.equals("null"))
			title = "";
		publishPhotoResponse = client.publish(albumId + "/photos",
				FacebookType.class,
				BinaryAttachment.with("cat.png", new FileInputStream(file)),
				Parameter.with("message", title + " " + INTRO_STR[new Random().nextInt(INTRO_STR.length)]));

		// open graph action

		// HttpClient ogClient = new HttpClient();
		// PostMethod post = new PostMethod("http://jakarata.apache.org/");
		// NameValuePair[] data = {
		// new NameValuePair("access_token", this.getFbToken()),
		// new NameValuePair("tyful_artwork", this.get)
		// };
		// post.setRequestBody(data);
		// // execute method and handle any error responses.
		// ...
		// InputStream in = post.getResponseBodyAsStream();
		// // handle response.

		return publishPhotoResponse.getId();
	}

	@Override
	public int getExpiration() {
		return 3600;
	}

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId
	 *            the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the fbToken
	 */
	public String getFbToken() {
		return fbToken;
	}

	/**
	 * @param fbToken
	 *            the fbToken to set
	 */
	public void setFbToken(String fbToken) {
		this.fbToken = fbToken;
	}

	/**
	 * @return the fbUid
	 */
	public String getFbUid() {
		return fbUid;
	}

	/**
	 * @param fbUid
	 *            the fbUid to set
	 */
	public void setFbUid(String fbUid) {
		this.fbUid = fbUid;
	}

	/**
	 * @return the imagePath
	 */
	public String getImagePath() {
		return imagePath;
	}

	/**
	 * @param imagePath
	 *            the imagePath to set
	 */
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title
	 *            the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * @return the templateId
	 */
	public String getTemplateId() {
		return templateId;
	}

	/**
	 * @param templateId
	 *            the templateId to set
	 */
	public void setTemplateId(String templateId) {
		this.templateId = templateId;
	}

}