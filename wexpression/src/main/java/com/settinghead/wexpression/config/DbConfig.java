package com.settinghead.wexpression.config;

import java.util.Properties;

import javax.inject.Inject;
import javax.sql.DataSource;

import org.apache.tomcat.dbcp.dbcp.BasicDataSource;
import org.apache.tomcat.dbcp.dbcp.BasicDataSourceFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.context.annotation.ImportResource;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseFactory;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseType;
import org.springframework.jdbc.datasource.init.DatabasePopulator;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.orm.hibernate3.HibernateTransactionManager;
import org.springframework.orm.hibernate3.annotation.AnnotationSessionFactoryBean;
import org.springframework.social.connect.jdbc.JdbcUsersConnectionRepository;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
public class DbConfig {

    @Autowired
    private PropertySourcesPlaceholderConfigurer propertySourcePlaceholderConfigurer;
    
    @Bean
    public PropertySourcesPlaceholderConfigurer propertySourcePlaceholderConfigurer(){
    	return new PropertySourcesPlaceholderConfigurer();
    }
    
	// internal helpers

	private DatabasePopulator databasePopulator() {
		ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
		populator.addScript(new ClassPathResource(
				"JdbcUsersConnectionRepository.sql",
				JdbcUsersConnectionRepository.class));
		return populator;
	}
	
	
	@Bean(destroyMethod = "close")
	public DataSource dataSource() {
		BasicDataSource source = new BasicDataSource();
		source.setDriverClassName("com.mysql.jdbc.Driver");
		source.setUrl("jdbc:mysql://localhost:3306/wexpression?characterEncoding=UTF-8");
		source.setUsername("root");
		source.setPassword("0");
		return source;	
	}
    
	@Autowired
	private DataSource dataSource;
 
	@Bean
	public AnnotationSessionFactoryBean sessionFactory() {
		AnnotationSessionFactoryBean sessionFactory = new AnnotationSessionFactoryBean();
		sessionFactory.setDataSource(dataSource);
		sessionFactory
				.setPackagesToScan(new String[] { "com.settinghead.wexpression" });
		Properties prop = new Properties();
		prop.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
		prop.setProperty("hibernate.hbm2ddl.auto", "create");
//		prop.setProperty("configLocation", "classpath:hibernate.cfg.xml");
		prop.setProperty("hibernate.connection.password", "0");
		prop.setProperty("hibernate.connection.username","root");
		prop.setProperty("hibernate.connection.driver_class", "com.mysql.jdbc.Driver");
		prop.setProperty("hibernate.connection.url", "jdbc:mysql://localhost:3306/wexpression?characterEncoding=UTF-8");
		prop.setProperty("hibernate.connection.defaultNChar", "true");
		
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
