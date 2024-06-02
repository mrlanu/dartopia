package xyz.qruto.java_server.services;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.locks.ReentrantLock;

@Service
public class AutomationServiceImpl implements AutomationService {

    private final ReentrantLock lock = new ReentrantLock();

    @Override
    @Async
    public void startAutomation() {
        try {
            lock.lock();
            for (int i = 0; i < 10; i++) {
                try {
                    Thread.sleep(1000);
                    System.out.println("Automation is Running - " + i + "sec");
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
            System.out.println("Automation is Finished");
        }finally {
            lock.unlock();
        }
    }

    @Override
    public String taskB() {
        return "TASK B IS RUNNING on " + Thread.currentThread().getName();
    }

    @Override
    public boolean isLocked(){
        return lock.isLocked();
    }
}
