package xyz.qruto.java_server.utils;

import xyz.qruto.java_server.entities.Settings;
import xyz.qruto.java_server.models.units.Unit;
import xyz.qruto.java_server.models.units.UnitsConst;

import java.time.LocalDateTime;
import java.util.List;

public class ArrivalTimeCalculator {

    public static LocalDateTime getArrivalTime(int toX, int toY, int fromX, int fromY,
                                               List<Integer> units, Settings settings) {
        double distance = getDistance(toX, toY, fromX, fromY);
        double speed = getSlowestSpeed(units) * settings.getTroopsSpeedX();
        double hours = distance / speed;
        int seconds = (int) Math.round(hours * 3600);
        return LocalDateTime.now().plusSeconds(seconds);
    }

    private static int getSlowestSpeed(List<Integer> units) {
        int speed = Integer.MAX_VALUE;
        for (int i = 0; i < units.size(); i++) {
            Unit unit = UnitsConst.UNITS.get(2).get(i);
            if (units.get(i) > 0 && unit.getVelocity() < speed) {
                speed = unit.getVelocity();
            }
        }
        return speed;
    }

    private static double getDistance(int toX, int toY, int fromX, int fromY) {
        double legX = Math.pow(toX - fromX, 2);
        double legY = Math.pow(toY - fromY, 2);
        return Math.sqrt(legX + legY);
    }
}
