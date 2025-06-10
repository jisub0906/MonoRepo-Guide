package com.example.authservice.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(
    origins = {"http://localhost:3000", "http://localhost:4200", "http://127.0.0.1:3000", "http://127.0.0.1:4200"},
    allowedHeaders = "*",
    methods = {RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE, RequestMethod.OPTIONS},
    allowCredentials = "true"
)
public class AuthController {

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "auth-service");
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");
        
        // 간단한 데모 인증 로직
        if ("admin".equals(username) && "password".equals(password)) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("token", "demo-jwt-token-1234567890");
            
            Map<String, Object> user = new HashMap<>();
            user.put("id", 1);
            user.put("username", username);
            user.put("role", "ADMIN");
            response.put("user", user);
            
            return ResponseEntity.ok(response);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", "Invalid credentials");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> userInfo) {
        String username = userInfo.get("username");
        String email = userInfo.get("email");
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "User registered successfully");
        response.put("userId", 123);
        response.put("username", username);
        response.put("email", email);
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/user")
    public ResponseEntity<Map<String, Object>> getCurrentUser(@RequestHeader(value = "Authorization", required = false) String token) {
        if (token != null && token.startsWith("Bearer ")) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            
            Map<String, Object> user = new HashMap<>();
            user.put("id", 1);
            user.put("username", "admin");
            user.put("email", "admin@example.com");
            user.put("role", "ADMIN");
            response.put("user", user);
            
            return ResponseEntity.ok(response);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", "Unauthorized");
        return ResponseEntity.ok(response);
    }
} 