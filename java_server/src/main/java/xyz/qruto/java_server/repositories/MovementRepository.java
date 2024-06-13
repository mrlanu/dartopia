package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import xyz.qruto.java_server.entities.Movement;

import java.time.LocalDateTime;
import java.util.List;

public interface MovementRepository extends MongoRepository<Movement, String> {
    @Query("{ 'moving': true, 'when': { '$lte': ?1 }, '$or': [ { 'to.villageId': ?0 }, { 'from.villageId': ?0, 'mission': { '$ne': 'back' } } ] }")
    List<Movement> findMovingToOrFromVillageIdBeforeDate(String villageId, LocalDateTime currentDate);
    List<Movement> findAllByMovingIsTrueAndWhenIsBefore(LocalDateTime currentDate);
}
