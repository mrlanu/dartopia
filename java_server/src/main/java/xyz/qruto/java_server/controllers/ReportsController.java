package xyz.qruto.java_server.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.models.UserDetailsImpl;
import xyz.qruto.java_server.models.responses.MilitaryReportResponse;
import xyz.qruto.java_server.models.responses.UnreadAmountAndBriefs;
import xyz.qruto.java_server.services.ReportService;

@RestController
@RequestMapping("/reports")
public class ReportsController {

    private final ReportService reportService;

    public ReportsController(ReportService reportService) {
        this.reportService = reportService;
    }

    @GetMapping
    public ResponseEntity<UnreadAmountAndBriefs> getReports(UsernamePasswordAuthenticationToken token) {
        UnreadAmountAndBriefs response = reportService.createReportsBrief(((UserDetailsImpl)token.getPrincipal()).getId());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{reportId}")
    public ResponseEntity<MilitaryReportResponse> getReport(@PathVariable String reportId,
                                                            UsernamePasswordAuthenticationToken token) {
        MilitaryReportResponse report = reportService.fetchReportById(reportId, ((UserDetailsImpl)token.getPrincipal()).getId());
        return ResponseEntity.ok(report);
    }

    @DeleteMapping("/{reportId}")
    public void deleteReport(@PathVariable String reportId, UsernamePasswordAuthenticationToken token) {
        reportService.deleteById(reportId, ((UserDetailsImpl)token.getPrincipal()).getId());
    }
}
