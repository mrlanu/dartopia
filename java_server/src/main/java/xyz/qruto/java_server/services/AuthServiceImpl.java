package xyz.qruto.java_server.services;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import xyz.qruto.java_server.config.jwt.JwtUtils;
import xyz.qruto.java_server.entities.*;
import xyz.qruto.java_server.errors.UserErrorException;
import xyz.qruto.java_server.models.Nations;
import xyz.qruto.java_server.models.SettlementKind;
import xyz.qruto.java_server.models.UserDetailsImpl;
import xyz.qruto.java_server.models.requests.SignupRequest;
import xyz.qruto.java_server.models.responses.JwtResponse;
import xyz.qruto.java_server.repositories.RoleRepository;
import xyz.qruto.java_server.repositories.SettlementRepository;
import xyz.qruto.java_server.repositories.StatisticsRepository;
import xyz.qruto.java_server.repositories.UserRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AuthServiceImpl implements AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtUtils jwtUtils;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder encoder;
    private final SettlementRepository settlementRepository;
    private final WorldService worldService;
    private final StatisticsRepository statisticsRepository;

    public AuthServiceImpl(AuthenticationManager authenticationManager,
                           JwtUtils jwtUtils, UserRepository userRepository,
                           RoleRepository roleRepository,
                           PasswordEncoder encoder,
                           SettlementRepository settlementRepository,
                           WorldService worldService,
                           StatisticsRepository statisticsRepository) {
        this.authenticationManager = authenticationManager;
        this.jwtUtils = jwtUtils;
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.encoder = encoder;
        this.settlementRepository = settlementRepository;
        this.worldService = worldService;
        this.statisticsRepository = statisticsRepository;
    }

    public JwtResponse login(String username, String password) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(username, password));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        List<String> roles = userDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());

        return JwtResponse.builder()
                .token(jwt)
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
        var newUser = userRepository.save(user);
        foundFirstSettlement(newUser.getId());
        createStatistics(newUser);
        return newUser;
    }

    private void createStatistics(UserEntity newUser) {
        StatisticsEntity statistics = StatisticsEntity.builder()
                .playerName(newUser.getName())
                .playerId(newUser.getId())
                .population(0)
                .allianceName("")
                .attackPoints(0)
                .defensePoints(0)
                .build();
        statisticsRepository.save(statistics);
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

    private void foundFirstSettlement(String userId) {
        var emptyTile = worldService.findEmptyTile();
        var settlementEntity = SettlementEntity.builder()
                .userId(userId)
                .name("New Settlement")
                .nation(Nations.gaul)
                .kind(SettlementKind.six)
                .x(emptyTile.getCorX())
                .y(emptyTile.getCorY())
                .storage(Arrays.asList(BigDecimal.valueOf(500), BigDecimal.valueOf(500),
                        BigDecimal.valueOf(500), BigDecimal.valueOf(500)))
                .buildings(Arrays.asList(
                        //lumber
                        Arrays.asList(0, 0, 0, 0),
                        Arrays.asList(1, 0, 0, 0),
                        Arrays.asList(2, 0, 1, 0),
                        Arrays.asList(3, 0, 0, 0),
                        //clay
                        Arrays.asList(4, 1, 0, 0),
                        Arrays.asList(5, 1, 0, 0),
                        Arrays.asList(6, 1, 1, 0),
                        Arrays.asList(7, 1, 0, 0),
                        //iron
                        Arrays.asList(8, 2, 0, 0),
                        Arrays.asList(9, 2, 0, 0),
                        Arrays.asList(10, 2, 1, 0),
                        Arrays.asList(11, 2, 0, 0),
                        //crop
                        Arrays.asList(12, 3, 0, 0),
                        Arrays.asList(13, 3, 0, 0),
                        Arrays.asList(14, 3, 0, 0),
                        Arrays.asList(15, 3, 1, 0),
                        Arrays.asList(16, 3, 0, 0),
                        Arrays.asList(17, 3, 1, 0),
                        //main
                        Arrays.asList(18, 4, 1, 0)
                        ))
                .army(Arrays.asList(0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
                .availableUnits(new ArrayList<>())
                .constructionTasks(new ArrayList<>())
                .combatUnitQueue(new ArrayList<>())
                .movements(new ArrayList<>())
                .lastModified(LocalDateTime.now())
                .lastSpawnedAnimals(LocalDateTime.now())
                .build();
        var newSettlementEntity = settlementRepository.save(settlementEntity);
        updateTile(emptyTile, newSettlementEntity);
    }

    private void updateTile(MapTile emptyTile, SettlementEntity newSettlementEntity) {
        emptyTile.setOwnerId(newSettlementEntity.getId());
        emptyTile.setEmpty(false);
        emptyTile.setTileNumber(SettlementKind.six.getCode());
        emptyTile.setName("Settlement");
        worldService.save(emptyTile);
    }
}
