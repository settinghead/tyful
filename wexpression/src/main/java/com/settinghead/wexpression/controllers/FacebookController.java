package com.settinghead.wexpression.controllers;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URL;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.social.facebook.api.Album;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.settinghead.wexpression.controllers.TemplateController.UploadTemplateResponder;
import com.settinghead.wexpression.data.FacebookPostRepository;
import com.settinghead.wexpression.data.template.Template;

@Controller
@RequestMapping("/facebook/**")
public class FacebookController {

	private final Facebook facebook;

	@Inject
	public FacebookController(Facebook facebook) {
		this.facebook = facebook;
	}

	@RequestMapping(value = "/publish_photo", method = RequestMethod.POST, produces = {
		      MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
  public UploadPhotoResponder handleFormUpload(
  		HttpServletRequest request, HttpServletResponse response) throws IOException {
		InputStream inputStream = request.getInputStream();
          byte[] photoBytes = IOUtils.toByteArray(inputStream);
          File file = new File("/tmp/"+UUID.randomUUID()+".png");
          FileUtils.writeByteArrayToFile(file, photoBytes);
          
          //find or create album "wexpression"
         String albumId = null;
         List<Album> albums = facebook.mediaOperations().getAlbums();
         for(Album a:albums)
        	 if(a.getName().equals("wexpression")){
        		 albumId = a.getId();
        		 break;
        	 }
         
         if(albumId == null)
        	 albumId = facebook.mediaOperations().createAlbum("wexpression", "typograph");
         FileSystemResource res = new FileSystemResource(file);
         
         String photoId = facebook.mediaOperations().postPhoto(albumId, res);
         UploadPhotoResponder responder = new UploadPhotoResponder();
         responder.id = photoId;
         return responder;
  }
	
	public static class UploadPhotoResponder{
		public String id;
	}
}
