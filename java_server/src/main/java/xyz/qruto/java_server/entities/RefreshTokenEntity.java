package xyz.qruto.java_server.entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document("refresh_tokens")
public class RefreshTokenEntity {

    @Id
    private String token;

    @Indexed
    private String userId;

    private Instant expiresAt;

    private boolean revoked;
}
