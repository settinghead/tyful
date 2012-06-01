package com.settinghead.wenwentu.service.task;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.List;

import com.restfb.BinaryAttachment;
import com.restfb.Connection;
import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Parameter;
import com.restfb.types.Album;
import com.restfb.types.FacebookType;

public class FbUploadTask extends Task {
	private static final Object INTRO_STR = "I created my Groffle typography artwork for my Facebook profile at http://www.groffle.me .";
	private String userId;
	private String fbToken;
	private String fbUid;
	private String imagePath;
	private String title;
	private String templateId;
	
	@Override
	public String getKey() {
		return "fbu_"+getUserId()+"_"+getTemplateId();
	}

	@Override
	public String perform() {
		FacebookClient client = new DefaultFacebookClient(this.getFbToken());
		File file = new File(this.getImagePath());

		// find or create album "wexpression"
		String albumId = null;

		Connection<Album> myAlbums = client.fetchConnection("me/albums",
				Album.class);
		outer: for (List<Album> albums : myAlbums) {
			for (Album album : albums) {
				if (album.getName().startsWith("Groffle")) {
					albumId = album.getId();
					break outer;
				}
			}
		}

		if (albumId == null)
		// create album
		{
			FacebookType albumconnection = client
					.publish(
							"me/albums",
							Album.class,
							Parameter.with("name", "Groffle"),
							Parameter
									.with("description",
											INTRO_STR));
			albumId = albumconnection.getId();
		}
		FacebookType publishPhotoResponse = null;
		try {
			String title = this.getTitle();
			if(title==null || title.equals("null")) title = "";
			publishPhotoResponse = client
					.publish(albumId + "/photos", FacebookType.class,
							BinaryAttachment.with("cat.png",
									new FileInputStream(file)), Parameter.with(
									"message", title+" "+INTRO_STR));
		} catch (FileNotFoundException e) {
			logger.warning(e.getMessage());
		}
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
	 * @param templateId the templateId to set
	 */
	public void setTemplateId(String templateId) {
		this.templateId = templateId;
	}

}
