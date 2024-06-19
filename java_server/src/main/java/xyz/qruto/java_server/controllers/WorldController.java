package xyz.qruto.java_server.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.models.responses.TileDetails;
import xyz.qruto.java_server.services.WorldService;

import java.util.List;

@RestController
@RequestMapping("/world")
public class WorldController {

    private final WorldService worldService;

    public WorldController(WorldService worldService) {
        this.worldService = worldService;
    }

    @PostMapping("/create")
    public ResponseEntity<String> createWorld() {
        worldService.createWorld();
        return ResponseEntity.ok("World created");
    }

    @GetMapping()
    public List<MapTile> getPartOfMap(@RequestParam int fromX,
                                      @RequestParam int fromY,
                                      @RequestParam int toX,
                                      @RequestParam int toY) {
        return worldService.getAllByCorXBetweenAndCorYBetween(fromX, toX, fromY, toY);
    }

    @GetMapping("/tiles")
    public ResponseEntity<TileDetails> getTileByCoordinates(@RequestParam int x, int y) {
        var tileDetails = worldService.getTileByCoordinates(x, y);
        return ResponseEntity.ok(tileDetails);
    }
}
