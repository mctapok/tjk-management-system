package controller;

import dto.request.JwtRequest;
import dto.response.JwtResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import service.AuthService;

@RestController
@AllArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping(value = "api/v1/login")
    public ResponseEntity<?> login(@RequestBody JwtRequest jwtRequest){
        String token = authService.generateAuthToken(jwtRequest);
        return ResponseEntity.ok(new JwtResponse(token));
    }
}
