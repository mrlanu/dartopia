package xyz.qruto.java_server.models.buildings;

public class Time {
    private final double a;
    private final double k;
    private final double b;

    public Time(double a, double k, double b) {
        this.a = a;
        this.k = k;
        this.b = b;
    }

    public Time(double a) {
        this.a = a;
        this.k = 1.16;
        this.b = 1875;
    }

    public int valueOf(int lvl){
       double prev = this.a * Math.pow(this.k, lvl-1) - this.b;
       return (int) prev;
    }
}
