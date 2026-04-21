package com.gavrilov_di.tjk_management_system.service;

import com.gavrilov_di.tjk_management_system.dto.request.JwtRequest;
import com.gavrilov_di.tjk_management_system.exception.AppError;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    private final JwtService jwtService;
    private final UserService userService;
    private final AuthenticationManager authenticationManager;

    public String generateAuthToken(JwtRequest jwtRequest) {
        log.info("Попытка входа: {}", jwtRequest.getEmail());
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(jwtRequest.getEmail(), jwtRequest.getPassword())
            );
        } catch (BadCredentialsException e){
            log.error("Ошибка аутентификации: {}", e.getMessage());
           throw new AppError(HttpStatus.UNAUTHORIZED.value(), "Неправильный логин или пароль");
        }
        log.info("Аутентификация успешна: {}", jwtRequest.getEmail());
        UserDetails userDetails = userService.loadUserByUsername(jwtRequest.getEmail());
        return jwtService.generateToken(userDetails);
    }
}
