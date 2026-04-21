package com.gavrilov_di.tjk_management_system.controller;

import com.gavrilov_di.tjk_management_system.dto.request.JwtRequest;
import com.gavrilov_di.tjk_management_system.dto.response.JwtResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.gavrilov_di.tjk_management_system.service.AuthService;

@RestController
@Slf4j
@AllArgsConstructor
@RequestMapping(value = "/api/v1/auth")
public class AuthController {
    private final AuthService authService;

    @PostMapping(value = "/login")
    public ResponseEntity<?> login(@RequestBody JwtRequest jwtRequest){
        log.info("Login attempt: {}", jwtRequest.getEmail());
        String token = authService.generateAuthToken(jwtRequest);
        return ResponseEntity.ok(new JwtResponse(token));
    }
}
