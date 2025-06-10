package com.example.authservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Configuration
public class WSLCorsConfig {

    @Bean
    public CorsFilter wslCorsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        
        // 기본 origins
        List<String> allowedOrigins = new ArrayList<>();
        allowedOrigins.add("http://localhost:3000");
        allowedOrigins.add("http://localhost:4200");
        allowedOrigins.add("http://127.0.0.1:3000");
        allowedOrigins.add("http://127.0.0.1:4200");
        allowedOrigins.add("http://0.0.0.0:3000");
        allowedOrigins.add("http://0.0.0.0:4200");
        
        // 모든 네트워크 인터페이스 IP 추가
        try {
            for (NetworkInterface networkInterface : Collections.list(NetworkInterface.getNetworkInterfaces())) {
                for (InetAddress inetAddress : Collections.list(networkInterface.getInetAddresses())) {
                    String ip = inetAddress.getHostAddress();
                    if (!ip.contains(":") && !ip.equals("127.0.0.1")) { // IPv4만, localhost 제외
                        allowedOrigins.add("http://" + ip + ":3000");
                        allowedOrigins.add("http://" + ip + ":4200");
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("네트워크 인터페이스 조회 실패: " + e.getMessage());
        }
        
        // CORS 설정
        config.setAllowCredentials(true);
        config.setAllowedOriginPatterns(List.of("*")); // 모든 패턴 허용
        config.setAllowedOrigins(allowedOrigins);
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS", "HEAD"));
        config.setAllowedHeaders(List.of("*"));
        config.setExposedHeaders(List.of("*"));
        config.setMaxAge(3600L);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        
        System.out.println("🔧 WSL CORS 설정 완료 - 허용된 Origins: " + allowedOrigins);
        
        return new CorsFilter(source);
    }
} 