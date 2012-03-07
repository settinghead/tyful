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
package com.settinghead.wexpression.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.settinghead.wexpression.data.FacebookFriendListRepository;
import com.settinghead.wexpression.data.FacebookPostRepository;
import com.settinghead.wexpression.data.WordListRepository;

/**
 * Main configuration class for the application. Turns on @Component scanning,
 * loads externalized application.properties, and sets up the database.
 * 
 * @author Keith Donald
 */
@Configuration
@ComponentScan(basePackages = { "com.settinghead.wexpression.controllers",
		"com.settinghead.wexpression" }, excludeFilters = { @Filter(Configuration.class) })
@PropertySource("classpath:com/settinghead/wexpression/config/application.properties")
public class MainConfig {
	

	@Bean
	public FacebookFriendListRepository facebookFriendListRepository() {
		return new FacebookFriendListRepository();
	}

	@Bean
	public WordListRepository wordListRepository() {
		return new WordListRepository();
	}

	@Bean
	public FacebookPostRepository facebookPostRepository() {
		return new FacebookPostRepository();
	}



}