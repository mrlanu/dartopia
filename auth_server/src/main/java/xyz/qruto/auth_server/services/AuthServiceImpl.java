package xyz.qruto.auth_server.services;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import xyz.qruto.auth_server.config.jwt.JwtUtils;
import xyz.qruto.auth_server.entities.Role;
import xyz.qruto.auth_server.entities.Roles;
import xyz.qruto.auth_server.entities.UserEntity;
import xyz.qruto.auth_server.errors.UserErrorException;
import xyz.qruto.auth_server.models.UserDetailsImpl;
import xyz.qruto.auth_server.models.requests.SignupRequest;
import xyz.qruto.auth_server.models.responses.JwtResponse;
import xyz.qruto.auth_server.repositories.RoleRepository;
import xyz.qruto.auth_server.repositories.UserRepository;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class AuthServiceImpl implements AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtUtils jwtUtils;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder encoder;
    private final RefreshTokenService refreshTokenService;

    public AuthServiceImpl(AuthenticationManager authenticationManager,
                           JwtUtils jwtUtils, UserRepository userRepository,
                           RoleRepository roleRepository,
                           PasswordEncoder encoder,
                           RefreshTokenService refreshTokenService) {
        this.authenticationManager = authenticationManager;
        this.jwtUtils = jwtUtils;
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.encoder = encoder;
        this.refreshTokenService = refreshTokenService;
    }

    public JwtResponse login(String username, String password) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(username, password));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        return buildJwtResponse(authentication);
    }

    @Override
    public JwtResponse refresh(String refreshToken) {
        var consumed = refreshTokenService.consumeRefreshToken(refreshToken);
        UserEntity user = userRepository.findById(consumed.getUserId())
                .orElseThrow(() -> new org.springframework.web.server.ResponseStatusException(
                        org.springframework.http.HttpStatus.UNAUTHORIZED, "User not found"));

        UserDetailsImpl userDetails = UserDetailsImpl.build(user);
        Authentication authentication = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);
        return buildJwtResponse(authentication);
    }

    @Override
    public void logout(String refreshToken) {
        refreshTokenService.revokeRefreshToken(refreshToken);
    }

    private JwtResponse buildJwtResponse(Authentication authentication) {
        String jwt = jwtUtils.generateJwtToken(authentication);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        String refreshToken = refreshTokenService.createRefreshToken(userDetails.getId());

        List<String> roles = userDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());

        return JwtResponse.builder()
                .token(jwt)
                .refreshToken(refreshToken)
                .type("Bearer")
                .id(userDetails.getId())
                .name(userDetails.getUsername())
                .email(userDetails.getEmail())
                .roles(roles)
                .build();
    }

    @Override
    @Transactional
    public UserEntity signup(SignupRequest signUpRequest) {
        if (userRepository.existsByName(signUpRequest.getName())) {
            throw new UserErrorException("Username is already taken!");
        }

        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            throw new UserErrorException("Email is already in use!");
        }

        UserEntity user = new UserEntity(signUpRequest.getName(),
                signUpRequest.getEmail(),
                encoder.encode(signUpRequest.getPassword()));

        Set<String> strRoles = signUpRequest.getRoles();
        Set<Role> roles = assignRoles(strRoles);
        user.setRoles(roles);
        return userRepository.save(user);
    }

    private Set<Role> assignRoles(Set<String> strRoles) {
        Set<Role> roles = new HashSet<>();
        if (strRoles == null) {
            Role userRole = roleRepository.findByName(Roles.ROLE_USER)
                    .orElseThrow(AuthServiceImpl::getRuntimeException);
            roles.add(userRole);
        } else {
            strRoles.forEach(role -> {
                switch (role) {
                    case "admin":
                        Role adminRole = roleRepository.findByName(Roles.ROLE_ADMIN)
                                .orElseThrow(AuthServiceImpl::getRuntimeException);
                        roles.add(adminRole);

                        break;
                    case "mod":
                        Role modRole = roleRepository.findByName(Roles.ROLE_MODERATOR)
                                .orElseThrow(AuthServiceImpl::getRuntimeException);
                        roles.add(modRole);

                        break;
                    default:
                        Role userRole = roleRepository.findByName(Roles.ROLE_USER)
                                .orElseThrow(AuthServiceImpl::getRuntimeException);
                        roles.add(userRole);
                }
            });
        }
        return roles;
    }

    private static RuntimeException getRuntimeException() {
        return new RuntimeException("Role is not found.");
    }
}
