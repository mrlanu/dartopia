package xyz.qruto.java_server.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.SettlementEntity;
import xyz.qruto.java_server.models.UserDetailsImpl;
import xyz.qruto.java_server.models.requests.ConstructionRequest;
import xyz.qruto.java_server.models.requests.SendTroopsRequest;
import xyz.qruto.java_server.models.requests.TroopsSendContract;
import xyz.qruto.java_server.models.responses.ShortSettlementInfo;
import xyz.qruto.java_server.services.automation.AutomationService;
import xyz.qruto.java_server.services.SettlementService;

import java.time.LocalDateTime;
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
        SettlementEntity settlement = settlementService
                .getSettlementById(settlementId, LocalDateTime.now());
        return settlement != null ?
                new ResponseEntity<>(settlement, HttpStatus.OK) :
                new ResponseEntity<>(null, HttpStatus.CONFLICT);
    }

    @PostMapping("/{settlementId}/constructions")
    public ResponseEntity<SettlementEntity> constructBuilding(@PathVariable String settlementId,
                                                              @RequestBody ConstructionRequest request) {
        var result = settlementService.addConstructionTask(settlementId, request);
        return request != null ?
                new ResponseEntity<>(result, HttpStatus.OK) :
                new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
    }

    @PostMapping("/{fromSettlementId}/troops_send_contract")
    public TroopsSendContract updateContract(@PathVariable String fromSettlementId,
                                             @RequestBody TroopsSendContract troopsSendContract) {
        return settlementService.updateContract(fromSettlementId, troopsSendContract);
    }

    @PostMapping("/{fromSettlementId}/send_units")
    public ResponseEntity<String> updateContract(@PathVariable String fromSettlementId,
                                             @RequestBody SendTroopsRequest request) {
        var result = settlementService.sendUnits(fromSettlementId, request);
        return ResponseEntity.ok(result);
    }
}
