package xyz.qruto.java_server.services;

import xyz.qruto.java_server.entities.UserEntity;
import xyz.qruto.java_server.models.requests.SignupRequest;
import xyz.qruto.java_server.models.responses.JwtResponse;

public interface AuthService {
    JwtResponse login(String username, String password);
    UserEntity signup(SignupRequest signUpRequest);
}
