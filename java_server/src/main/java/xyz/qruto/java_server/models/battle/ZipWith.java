package xyz.qruto.java_server.models.battle;

@FunctionalInterface
public interface ZipWith<A, B, C, R> {
    R apply(A a, B b, C c);
}
