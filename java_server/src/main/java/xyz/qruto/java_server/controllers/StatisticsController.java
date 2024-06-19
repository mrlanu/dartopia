package xyz.qruto.java_server.controllers;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.models.UserDetailsImpl;
import xyz.qruto.java_server.models.responses.StatisticsResponse;
import xyz.qruto.java_server.services.StatisticsService;

@RestController
@RequestMapping("/statistics")
public class StatisticsController {

    private final StatisticsService statisticsService;

    public StatisticsController(StatisticsService service) {
        this.statisticsService = service;
    }

    @GetMapping
    public StatisticsResponse getStatistics(
            UsernamePasswordAuthenticationToken token,
            @RequestParam(defaultValue = "-1") int page,
            @RequestParam(defaultValue = "population") String sort,
            @RequestParam(defaultValue = "false") boolean ascending,
            @RequestParam(defaultValue = "3") int pageSize) {
        return statisticsService
                .getStatistics(((UserDetailsImpl)token.getPrincipal()).getId(),
                        sort, ascending, pageSize, page);
    }
}
