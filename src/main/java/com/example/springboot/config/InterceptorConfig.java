package com.example.springboot.config;

import com.example.springboot.config.interceptor.JwtInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;

import java.nio.file.Files;
import java.nio.file.Path;

@Configuration
public class InterceptorConfig extends WebMvcConfigurationSupport {

    private static final String[] FRONTEND_ROUTES = {
            "/",
            "/index.html",
            "/login",
            "/register",
            "/404",
            "/front/**",
            "/back/**",
            "/assets/**",
            "/favicon.ico"
    };

    @Override
    protected void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("/web/login","/web/register")
                .excludePathPatterns("/web/download/**")
                .excludePathPatterns(FRONTEND_ROUTES);
        super.addInterceptors(registry);
    }

    @Override
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path dist = frontendDist();
        registry.addResourceHandler("/assets/**")
                .addResourceLocations(dist.resolve("assets").toUri().toString());
        registry.addResourceHandler("/index.html", "/favicon.ico")
                .addResourceLocations(dist.toUri().toString());
        super.addResourceHandlers(registry);
    }

    @Override
    protected void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("forward:/index.html");
        registry.addViewController("/login").setViewName("forward:/index.html");
        registry.addViewController("/register").setViewName("forward:/index.html");
        registry.addViewController("/404").setViewName("forward:/index.html");
        registry.addViewController("/front/**").setViewName("forward:/index.html");
        registry.addViewController("/back/**").setViewName("forward:/index.html");
        super.addViewControllers(registry);
    }

    private Path frontendDist() {
        Path workingDir = Path.of(System.getProperty("user.dir")).toAbsolutePath().normalize();
        for (Path current = workingDir; current != null; current = current.getParent()) {
            Path candidate = current.resolve("vue").resolve("dist").normalize();
            if (Files.isDirectory(candidate)) {
                return candidate;
            }
        }
        return workingDir.resolve("vue").resolve("dist").normalize();
    }

    @Bean
    public JwtInterceptor jwtInterceptor() {
        return new JwtInterceptor();
    }

}
