package xyz.qruto.java_server.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.services.SettlementService;

@RestController
@RequestMapping("/api/settlements")
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

    @GetMapping("/{settlementId}")
    public ResponseEntity<SettlementEntity> getSettlement(@PathVariable String settlementId) {
        var settlement = settlementService.getMockSettlement(settlementId);
        return ResponseEntity.ok(settlement);
    }

}
