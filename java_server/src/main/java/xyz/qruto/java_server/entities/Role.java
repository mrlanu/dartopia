package xyz.qruto.java_server.entities;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@NoArgsConstructor
@Data
@Document("roles")
public class Role {
    @Id
    private String id;
    private Roles name;
}
