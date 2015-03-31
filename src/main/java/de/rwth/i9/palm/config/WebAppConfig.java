package de.rwth.i9.palm.config;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.core.env.Environment;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver;

@Configuration
@EnableWebMvc
@ComponentScan( { "de.rwth.i9.palm" } )
@PropertySource( "classpath:application.properties" )
@Lazy( true )
public class WebAppConfig extends WebMvcConfigurerAdapter
{

	@Autowired
	private Environment env;

	/* freemarker */

	@Bean
	public FreeMarkerViewResolver setupFreeMarkerViewResolver()
	{
		FreeMarkerViewResolver freeMarkerViewResolver = new FreeMarkerViewResolver();
		freeMarkerViewResolver.setCache( false );
		freeMarkerViewResolver.setContentType( "text/html;charset=UTF-8" );
		freeMarkerViewResolver.setSuffix( ".ftl" );
		freeMarkerViewResolver.setExposeSessionAttributes( true );
		freeMarkerViewResolver.setExposeSpringMacroHelpers( true );
		freeMarkerViewResolver.setAllowSessionOverride( true );
		freeMarkerViewResolver.setRequestContextAttribute( "rc" );

		return freeMarkerViewResolver;
	}

	@Bean
	public FreeMarkerConfigurer setupFreeMarkerConfigurer()
	{
		FreeMarkerConfigurer freeMarkerConfigurer = new FreeMarkerConfigurer();
		freeMarkerConfigurer.setTemplateLoaderPaths( "/WEB-INF/ftl/", "/WEB-INF/ftl/dataset", "/WEB-INF/ftl/visualization", "/WEB-INF/ftl/sparqlview", "/WEB-INF/ftl/dialog" );

		Properties prop = new Properties();
		prop.put( "default_encoding", "UTF-8" );
		prop.put( "auto_import", "macros/layoutMacros.ftl as layout, macros/contentMacros.ftl as content, spring.ftl as spring" );

		freeMarkerConfigurer.setFreemarkerSettings( prop );

		Map<String, Object> freemakerVariables = new HashMap<String, Object>();
		freemakerVariables.put( "foo", "foo" );

		freeMarkerConfigurer.setFreemarkerVariables( freemakerVariables );
		return freeMarkerConfigurer;
	}

	// @Bean
	// <bean id="freemarkerConfiguration"
	// class="freemarker.template.Configuration" />

	/* resource */

	// Maps resources path to webapp/resources
	public void addResourceHandlers( ResourceHandlerRegistry registry )
	{
		registry.addResourceHandler( "/resources/**" ).addResourceLocations( "/resources/" );
	}

	// Provides internationalization of messages
	@Bean
	public ResourceBundleMessageSource messageSource()
	{
		ResourceBundleMessageSource source = new ResourceBundleMessageSource();
		source.setBasename( "messages" );
		return source;
	}

	/* fileupload */

	@Bean
	public CommonsMultipartResolver commonsMultipartResolver()
	{
		CommonsMultipartResolver commonsMultipartResolver = new CommonsMultipartResolver();
		commonsMultipartResolver.setMaxUploadSize( 10000000 );
		return commonsMultipartResolver;
	}
}
