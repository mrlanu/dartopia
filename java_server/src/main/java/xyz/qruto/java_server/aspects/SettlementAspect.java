package xyz.qruto.java_server.aspects;

import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;
import xyz.qruto.java_server.entities.SettlementEntity;

import java.time.LocalDateTime;

@Aspect
@Component
public class SettlementAspect {

    @Before("execution(* xyz.qruto.java_server.repositories.SettlementRepository.save(..)) && args(settlement)")
    public void beforeSave(SettlementEntity settlement) {
        // Custom behavior before saving the settlement
        System.out.printf("Settlement id - %s updated to %s%n", settlement.getId(), settlement.getLastModified());
        System.out.println("Current time is: " + LocalDateTime.now());
    }

    /*@AfterReturning(pointcut = "execution(* xyz.qruto.java_server.repositories.SettlementRepository.save(..))", returning = "result")
    public void afterSave(Object result) {
        // Custom behavior after saving the settlement
        System.out.println("Custom behavior after saving settlement: " + result);
    }*/
}
