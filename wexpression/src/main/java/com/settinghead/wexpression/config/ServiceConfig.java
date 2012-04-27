package com.settinghead.wexpression.config;

import org.springframework.amqp.core.AmqpAdmin;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.connection.CachingConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitAdmin;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

@Configuration
public class ServiceConfig {
	@Bean
	public CachingConnectionFactory rabbitConnectionFactory() {
		CachingConnectionFactory cf = new CachingConnectionFactory("localhost");
		return cf;
	}

	@Bean
	public AmqpAdmin amqpAdmin() {
		return new RabbitAdmin(rabbitConnectionFactory());
	}

	@Bean
	public RabbitTemplate rabbitTemplate() {
		return new RabbitTemplate(rabbitConnectionFactory());
	}

	@Bean
	public Queue myQueue() {
		return new Queue("myqueue");
	}

	@Bean
	public ThreadPoolTaskExecutor taskExecutor() {
		ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
		executor.setCorePoolSize(5);
		executor.setMaxPoolSize(50);
		executor.setQueueCapacity(25);
		return executor;
	}

	// @Inject
	// private JobDetailBean facebookWordListJob;
	// @Inject
	// private SimpleTriggerBean caffinatedTrigger;
	// @Bean
	// public JobDetailBean facebookWordListJob() {
	//
	// JobDetailBean b = new JobDetailBean();
	// b.setJobClass(FacebookWordListJob.class);
	// Map<String, String> jobData = new HashMap<String, String>();
	// jobData.put("timeout", "60");
	// b.setJobDataAsMap(jobData);
	// return b;
	// }
	//
	// @Bean
	// public SimpleTriggerBean caffinatedTrigger(){
	// SimpleTriggerBean t = new SimpleTriggerBean();
	// t.setJobDetail(facebookWordListJob);
	// t.setStartDelay(0);
	// t.setRepeatInterval(500);
	//
	// return t;
	// }

	// @Bean public SchedulerFactoryBean schedulerFactory(){
	// SchedulerFactoryBean bean = new SchedulerFactoryBean();
	// return bean;
	// }
}