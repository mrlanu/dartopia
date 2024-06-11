package xyz.qruto.java_server.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.UserDetailsImpl;
import xyz.qruto.java_server.models.responses.ShortSettlementInfo;
import xyz.qruto.java_server.services.automation.AutomationService;
import xyz.qruto.java_server.services.SettlementService;

import java.util.List;

@RestController
@RequestMapping("/settlements")
public class SettlementsController {


    private final AutomationService automationService;
    private final SettlementService settlementService;

    public SettlementsController(AutomationService automationService, SettlementService settlementService) {
        this.automationService = automationService;
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
        if (!automationService.isLocked()) {
            automationService.startAutomation();
            System.out.printf("Automation has been started by settlementId - %s%n",
                    settlementId);
        }
        var settlement = settlementService.getSettlementById(settlementId);
        return settlement != null ?
                new ResponseEntity<>(settlement, HttpStatus.OK) :
                new ResponseEntity<>(null, HttpStatus.CONFLICT);
    }

}
