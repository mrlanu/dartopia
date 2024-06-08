package xyz.qruto.java_server.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.UserDetailsImpl;
import xyz.qruto.java_server.models.responses.ShortSettlementInfo;
import xyz.qruto.java_server.services.SettlementService;

import java.util.List;

@RestController
@RequestMapping("/settlements")
public class SettlementsController {


    private final SettlementService settlementService;

    public SettlementsController(SettlementService settlementService) {
        this.settlementService = settlementService;
    }

    @PostMapping()
    public ResponseEntity<SettlementEntity> createSettlement() {
        var settlementEntity = settlementService.createMockSettlement();
        return ResponseEntity.ok(settlementEntity);
    }

    @GetMapping()
    public ResponseEntity<List<ShortSettlementInfo>> getSettlementsShortByUserId(UsernamePasswordAuthenticationToken token) {
        List<ShortSettlementInfo> result =
                settlementService.getAllSettlementsByUserId(((UserDetailsImpl)token.getPrincipal()).getId());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/{settlementId}")
    public ResponseEntity<SettlementEntity> getSettlementById(@PathVariable String settlementId) {
        var settlement = settlementService.getSettlementById(settlementId);
        return ResponseEntity.ok(settlement);
    }

}
