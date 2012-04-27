package com.settinghead.wexpression.template;

import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/templates/**")
public class TemplateController {
	Logger log = Logger.getLogger(this.getClass().getName());
	@Autowired
	private TemplateRepository templateRepository;

	@RequestMapping(value = "/all", method = RequestMethod.GET)
	public String all(ModelMap model) {
		model.addAttribute("templates", templateRepository.getAllTemplates());
		return "templates/list";
	}

	@RequestMapping(value = "/new", method = RequestMethod.GET)
	public String newTemplate(ModelMap model) {
		model.addAttribute("mode", "newTemplate");
		return "templates/show";
	}
	
	@RequestMapping(value = "/u", method = RequestMethod.POST, produces = { MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
	public UploadTemplateResponder handleFormUpload(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		InputStream inputStream = request.getInputStream();

		Template t = new Template();
		int size = templateRepository.saveTemplate(t, inputStream);

		// store the bytes somewhere
		UploadTemplateResponder r = new UploadTemplateResponder();
		r.id = t.getId();
		System.out.println("Template saved. ID: " + r.id + ", size: " + size);
		return r;
	}

	@RequestMapping(value = "/{id}/", method = RequestMethod.GET)
	public String show(@PathVariable("id") String id, Model model) {
		model.addAttribute("templateId", id);
		return "templates/show";
	}

	@RequestMapping(value = "/{id}/get", method = RequestMethod.GET)
	public void getFile(@PathVariable("id") String id,
			HttpServletResponse response) {
		InputStream is = templateRepository.getTemplateFile(id);

		try {
			// get your file as InputStream
			// copy it to response's OutputStream
			IOUtils.copy(is, response.getOutputStream());
			response.flushBuffer();
		} catch (IOException ex) {
			log.severe("Error writing file to output stream. Filename was '" + id
					+ "'");
			throw new RuntimeException("IOError writing file to output stream");
		}
	}

	@RequestMapping(value = "/{id}/preview", method = RequestMethod.GET)
	public void getPreview(@PathVariable("id") String id,
			HttpServletResponse response) {
		InputStream is = templateRepository.getTemplatePreview(id);

		try {
			// get your file as InputStream
			// copy it to response's OutputStream
			IOUtils.copy(is, response.getOutputStream());
			response.flushBuffer();
		} catch (IOException ex) {
			log.info("Error writing file to output stream. Filename was '" + id
					+ "'");
			throw new RuntimeException("IOError writing file to output stream");
		}
	}

	public static class UploadTemplateResponder {
		public String id;
	}

}
