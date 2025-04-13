package xyz.qruto.auth_server.controllers;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.auth_server.entities.Role;
import xyz.qruto.auth_server.entities.UserEntity;
import xyz.qruto.auth_server.models.requests.LoginRequest;
import xyz.qruto.auth_server.models.requests.SignupRequest;
import xyz.qruto.auth_server.models.responses.JwtResponse;
import xyz.qruto.auth_server.repositories.RoleRepository;
import xyz.qruto.auth_server.services.AuthService;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;
    private final RoleRepository roleRepository;

    public AuthController(AuthService authService, RoleRepository roleRepository) {
        this.authService = authService;
        this.roleRepository = roleRepository;
    }

    @PostMapping("/roles")
    public Role createRole(@RequestBody Role role) {
        return roleRepository.save(role);
    }

    @PostMapping("/login")
    public ResponseEntity<JwtResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        return ResponseEntity.ok(authService.login(
                loginRequest.getEmail(),
                loginRequest.getPassword()));
    }

    @PostMapping("/signup")
    public ResponseEntity<UserEntity> signup(@Valid @RequestBody SignupRequest signUpRequest) {
        UserEntity user = authService.signup(signUpRequest);
        return ResponseEntity.ok(user);
    }
}
