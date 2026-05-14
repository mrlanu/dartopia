package xyz.qruto.java_server.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import xyz.qruto.java_server.entities.MapTile;
import xyz.qruto.java_server.models.responses.TileDetails;
import xyz.qruto.java_server.models.responses.WorldChunkResponse;
import xyz.qruto.java_server.models.responses.WorldMetaResponse;
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

    @GetMapping("/meta")
    public ResponseEntity<WorldMetaResponse> getMeta() {
        return ResponseEntity.ok(worldService.getWorldMeta());
    }

    @GetMapping("/chunks")
    public ResponseEntity<WorldChunkResponse> getChunk(@RequestParam int cx, @RequestParam int cy) {
        return ResponseEntity.ok(worldService.getChunk(cx, cy));
    }

    @GetMapping()
    public List<MapTile> getPartOfMap(@RequestParam int fromX,
                                      @RequestParam int fromY,
                                      @RequestParam int toX,
                                      @RequestParam int toY) {
        return worldService.getAllByCorXBetweenAndCorYBetween(fromX, toX, fromY, toY);
    }

    @GetMapping("/tiles")
    public ResponseEntity<TileDetails> getTileByCoordinates(@RequestParam int myX,
                                                            @RequestParam int myY,
                                                            @RequestParam int x,
                                                            @RequestParam int y) {
        var tileDetails = worldService.getTileByCoordinates(myX, myY, x, y);
        return ResponseEntity.ok(tileDetails);
    }
}
