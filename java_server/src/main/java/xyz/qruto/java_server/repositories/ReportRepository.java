package xyz.qruto.java_server.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import xyz.qruto.java_server.entities.ReportEntity;

import java.util.List;

public interface ReportRepository extends MongoRepository<ReportEntity, String> {
    @Query("{ 'reportOwners': { $elemMatch: { 'playerId': ?0 } } }")
    List<ReportEntity> findByPlayerIdInReportOwners(String playerId);
}
