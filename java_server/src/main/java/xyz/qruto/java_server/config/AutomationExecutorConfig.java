package xyz.qruto.java_server.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

@Configuration
public class AutomationExecutorConfig {

    /**
     * Runs due-movement processing off HTTP threads; single-flight coalesces waiters onto one task.
     */
    @Bean(name = "automationTaskExecutor")
    @Qualifier("automationTaskExecutor")
    public ThreadPoolTaskExecutor automationTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(1);
        executor.setMaxPoolSize(1);
        executor.setQueueCapacity(256);
        executor.setThreadNamePrefix("automation-");
        executor.initialize();
        return executor;
    }
}
