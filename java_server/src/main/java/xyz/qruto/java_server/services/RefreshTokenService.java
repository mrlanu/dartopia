package xyz.qruto.java_server.services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import xyz.qruto.java_server.entities.RefreshTokenEntity;
import xyz.qruto.java_server.repositories.RefreshTokenRepository;

import java.time.Instant;
import java.util.UUID;

@Service
public class RefreshTokenService {

    private final RefreshTokenRepository refreshTokenRepository;

    @Value("${myapp.jwtRefreshExpirationMs:604800000}")
    private long jwtRefreshExpirationMs;

    public RefreshTokenService(RefreshTokenRepository refreshTokenRepository) {
        this.refreshTokenRepository = refreshTokenRepository;
    }

    public String createRefreshToken(String userId) {
        String token = UUID.randomUUID().toString();
        Instant expiresAt = Instant.now().plusMillis(jwtRefreshExpirationMs);
        refreshTokenRepository.save(new RefreshTokenEntity(token, userId, expiresAt, false));
        return token;
    }

    /**
     * Validates the refresh token, marks it revoked (rotation), and returns the entity.
     */
    public RefreshTokenEntity consumeRefreshToken(String token) {
        RefreshTokenEntity entity = refreshTokenRepository.findByTokenAndRevokedFalse(token)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED, "Invalid refresh token"));

        if (entity.getExpiresAt().isBefore(Instant.now())) {
            entity.setRevoked(true);
            refreshTokenRepository.save(entity);
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Refresh token expired");
        }

        entity.setRevoked(true);
        refreshTokenRepository.save(entity);
        return entity;
    }

    public void revokeRefreshToken(String token) {
        refreshTokenRepository.findById(token).ifPresent(entity -> {
            entity.setRevoked(true);
            refreshTokenRepository.save(entity);
        });
    }
}
