/*
 * Copyright 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.settinghead.wexpression.facebook;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.MediaType;
import org.springframework.social.facebook.api.Album;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class FacebookPhotosController {

	private final Facebook facebook;

	@Inject
	public FacebookPhotosController(Facebook facebook) {
		this.facebook = facebook;
	}

	@RequestMapping(value="/facebook/albums", method=RequestMethod.GET)
	public String showAlbums(Model model) {
		model.addAttribute("albums", facebook.mediaOperations().getAlbums());
		return "facebook/albums";
	}
	
	@RequestMapping(value="/facebook/album/{albumId}", method=RequestMethod.GET)
	public String showAlbum(@PathVariable("albumId") String albumId, Model model) {
		model.addAttribute("album", facebook.mediaOperations().getAlbum(albumId));
		model.addAttribute("photos", facebook.mediaOperations().getPhotos(albumId));
		return "facebook/album";
	}

	@RequestMapping(value = "/facebook/publish_photo", method = RequestMethod.POST, produces = {
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
