package com.settinghead.wexpression.controllers;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.settinghead.wexpression.data.template.Template;
import com.settinghead.wexpression.data.template.TemplateRepository;

@Controller
@RequestMapping("/templates/**")
public class TemplateController {
	
	@Autowired
	private TemplateRepository templateRepository;
	
	@RequestMapping(value="/all", method=RequestMethod.GET)
	public String all(ModelMap model){
		model.addAttribute("templates", templateRepository.getAllTemplates());
		return "templates/list";
	}
	
	@RequestMapping(value="/{templateId}/preview", method=RequestMethod.GET)
	public void preview(
			@PathVariable("templateId") 
			String templateId, OutputStream outputStream) throws IOException{
		Template template = templateRepository.getTemplate(templateId);
		byte[] pBytes = template.getPreviewPNG();
		outputStream.write(pBytes);
		outputStream.close();
	}
	
	@RequestMapping(value = "/u", method = RequestMethod.POST, produces = {
		      MediaType.APPLICATION_JSON_VALUE })
	@ResponseBody
    public UploadTemplateResponder handleFormUpload(
    		HttpServletRequest request, HttpServletResponse response) throws IOException {
		InputStream inputStream = request.getInputStream();
            byte[] bytes = IOUtils.toByteArray(inputStream);
            
            Template t = new Template();
            t.setData(bytes);
            templateRepository.saveTemplate(t);
            
            // store the bytes somewhere
            UploadTemplateResponder r = new UploadTemplateResponder();
            r.id = t.getId();
            System.out.println("Template saved. ID: "+ r.id + ", size: " + bytes.length);
            return r;
    }
	
	public static class UploadTemplateResponder{
		public String id;
	}
	
}
