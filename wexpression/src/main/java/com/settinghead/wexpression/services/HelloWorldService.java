package com.settinghead.wexpression.services;

import org.springframework.flex.remoting.RemotingDestination;
import org.springframework.flex.remoting.RemotingInclude;
import org.springframework.stereotype.Service;

@Service
@RemotingDestination
public class HelloWorldService {
	@RemotingInclude
	public String sayHello(String name) {
		return "howdy, " + name;
	}
}