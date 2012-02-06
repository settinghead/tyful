package com.settinghead.wexpression.controllers;

import java.io.IOException;
import java.io.OutputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.settinghead.wexpression.data.template.Template;
import com.settinghead.wexpression.data.template.TemplateRepository;

@Controller
@RequestMapping("/template")
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
	
	
}
