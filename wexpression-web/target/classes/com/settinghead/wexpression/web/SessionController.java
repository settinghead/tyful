/**
 * 
 */
package com.settinghead.wexpression.web;

import java.io.IOException;
import java.util.List;

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
import org.springframework.web.bind.annotation.RequestParam;

import com.settinghead.wexpression.data.FacebookPosts;

/**
 * @author settinghead
 * 
 */
@Controller
public class SessionController {
	private FacebookPosts fbPosts;

	@Inject
	public SessionController(FacebookPosts fbPosts) {
		this.setFbPosts(fbPosts);
	}

	private void setFbPosts(FacebookPosts fbPosts) {
		this.fbPosts = fbPosts;
	}

	@RequestMapping(value = "/session", method = RequestMethod.GET)
	public String home(@RequestParam String sessionId, Model model,
			HttpServletResponse response) throws IOException {
		System.err.println("session!");
		return "home";
	}

}
