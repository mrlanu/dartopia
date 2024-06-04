package xyz.qruto.java_server.controllers;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.UserEntity;
import xyz.qruto.java_server.models.requests.LoginRequest;
import xyz.qruto.java_server.models.requests.SignupRequest;
import xyz.qruto.java_server.services.AuthService;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest loginRequest) {
        return ResponseEntity.ok(authService.login(
                loginRequest.getUsername(),
                loginRequest.getPassword()));
    }

    @PostMapping("/signup")
    public ResponseEntity<UserEntity> signup(@Valid @RequestBody SignupRequest signUpRequest) {
        UserEntity user = authService.signup(signUpRequest);
        return ResponseEntity.ok(user);
    }
}
