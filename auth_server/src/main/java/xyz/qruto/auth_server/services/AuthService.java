package xyz.qruto.auth_server.services;

import xyz.qruto.auth_server.entities.UserEntity;
import xyz.qruto.auth_server.models.requests.SignupRequest;
import xyz.qruto.auth_server.models.responses.JwtResponse;

public interface AuthService {
    JwtResponse login(String username, String password);

    JwtResponse refresh(String refreshToken);

    void logout(String refreshToken);

    UserEntity signup(SignupRequest signUpRequest);
}
