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

import java.util.Properties;

import javax.inject.Inject;
import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseFactory;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseType;
import org.springframework.jdbc.datasource.init.DatabasePopulator;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.orm.hibernate3.HibernateTransactionManager;
import org.springframework.orm.hibernate3.annotation.AnnotationSessionFactoryBean;
import org.springframework.social.connect.jdbc.JdbcUsersConnectionRepository;
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
@EnableTransactionManagement
public class MainConfig {
	@Inject
	private DataSource dataSource;

	@Bean(destroyMethod = "shutdown")
	public DataSource dataSource() {
		EmbeddedDatabaseFactory factory = new EmbeddedDatabaseFactory();
		factory.setDatabaseName("wexpression");
		factory.setDatabaseType(EmbeddedDatabaseType.H2);
		factory.setDatabasePopulator(databasePopulator());
		return factory.getDatabase();
	}

	// internal helpers

	private DatabasePopulator databasePopulator() {
		ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
		populator.addScript(new ClassPathResource(
				"JdbcUsersConnectionRepository.sql",
				JdbcUsersConnectionRepository.class));
		return populator;
	}

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

	@Bean
	public AnnotationSessionFactoryBean sessionFactory() {
		AnnotationSessionFactoryBean sessionFactory = new AnnotationSessionFactoryBean();
		sessionFactory.setDataSource(dataSource);
		sessionFactory
				.setPackagesToScan(new String[] { "com.settinghead.wexpression" });
		Properties prop = new Properties();
		prop.setProperty("hibernate.dialect", "org.hibernate.dialect.H2Dialect");
		prop.setProperty("hibernate.hbm2ddl.auto", "create");
		sessionFactory.setHibernateProperties(prop);
		return sessionFactory;
	}

	@Bean
	public HibernateTransactionManager transactionManager() {
		HibernateTransactionManager manager = new HibernateTransactionManager();
		manager.setSessionFactory(sessionFactory().getObject());
		return manager;
	}

}
