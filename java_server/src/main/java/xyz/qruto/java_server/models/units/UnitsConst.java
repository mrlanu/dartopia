package xyz.qruto.java_server.models.units;

import java.util.Arrays;
import java.util.List;

public class UnitsConst {
    public static final List<List<Unit>> UNITS = List.of(
            Arrays.asList( //ROMANS
                    new Unit(UnitKind.UNIT, "Legionnaire",40, 35, 50, 6,
                            Arrays.asList(120, 100, 150, 30), 1, 2000, 50, true, 7800, ""),
                    new Unit(UnitKind.UNIT, "Praetorian", 30, 65, 35, 5,
                            Arrays.asList(100, 130, 160, 70), 1, 2200, 20, true, 8400, ""),
                    new Unit(UnitKind.UNIT, "Imperian", 70, 40, 25, 7,
                            Arrays.asList(150, 160, 210, 80), 1, 2400, 50, true, 9000, ""),
                    new Unit(UnitKind.SPY, "Equites Legati", 0, 20, 10, 16,
                            Arrays.asList(140, 160, 20, 40), 2, 1700, 0, false, 6900, ""),
                    new Unit(UnitKind.UNIT, "Equites Imperatoris", 120, 65, 50, 14,
                            Arrays.asList(550, 440, 320, 100), 3, 3300, 100, false, 11700, ""),
                    new Unit(UnitKind.UNIT, "Equites Caesaris", 180, 80, 105, 10,
                            Arrays.asList(550, 640, 800, 180), 4, 4400, 70, false, 15000, ""),
                    new Unit(UnitKind.RAM, "Battering ram", 60, 30, 75, 4,
                            Arrays.asList(900, 360, 500, 70), 3, 4600, 0, true, 15600, ""),
                    new Unit(UnitKind.CAT, "Fire Catapult", 75, 60, 10, 3,
                            Arrays.asList(950, 1350, 600, 90), 6, 9000, 0, true, 28800, ""),
                    new Unit(UnitKind.ADMIN, "Senator", 50, 40, 30, 4,
                            Arrays.asList(30750, 27200, 45000, 37500), 5, 90700, 0, true, 24475, ""),
                    new Unit(UnitKind.SETTLER, "Settler", 0, 80, 80, 5,
                            Arrays.asList(4600, 4200, 5800, 4400), 1, 26900, 3000, true, 0, "")
            ),
            Arrays.asList(//TEUTONS
                    new Unit(UnitKind.UNIT, "Maceman",40, 20, 5, 7,
                            Arrays.asList(95, 75, 40, 40), 1, 900, 60, true, 4500, ""),
                    new Unit(UnitKind.UNIT, "Spearman", 10, 35, 60, 7,
                            Arrays.asList(145, 70, 85, 40), 1, 1400, 40, true, 6300, ""),
                    new Unit(UnitKind.UNIT, "Axeman", 60, 30, 30, 6,
                            Arrays.asList(130, 120, 170, 70), 1, 1500, 50, true, 6300, ""),
                    new Unit(UnitKind.SPY, "Scout", 0, 10, 5, 9,
                            Arrays.asList(160, 100, 50, 50), 1, 1400, 0, false, 6000, ""),
                    new Unit(UnitKind.UNIT, "Paladin", 55, 100, 40, 10,
                            Arrays.asList(370, 270, 290, 75), 2, 3000, 110, false, 10800, ""),
                    new Unit(UnitKind.UNIT, "Teutonic Knight", 150, 50, 75, 9,
                            Arrays.asList(450, 515, 480, 80), 3, 3700, 80, false, 12900, ""),

                    new Unit(UnitKind.RAM, "Ram", 65, 30, 80, 4,
                            Arrays.asList(1000, 300, 350, 70), 3, 4200, 0, true, 14400, ""),
                    new Unit(UnitKind.CAT, "Catapult", 50, 60, 10, 3,
                            Arrays.asList(900, 1200, 600, 60), 6, 9000, 0, true, 28800, ""),
                    new Unit(UnitKind.ADMIN, "Chief", 40, 60, 40, 4,
                            Arrays.asList(35500, 26600, 25000, 27200), 4, 70500, 0, true, 19425, ""),
                    new Unit(UnitKind.SETTLER, "Settler", 10, 80, 80, 5,
                            Arrays.asList(5800, 4400, 4600, 5200), 1, 31000, 3000, true, 0, "")
            ),
            /*
        {a:10, di:80, dc:80, v:5, c:[ 5800, 4400, 4600, 5200], u:1, t:31000, p:3000,i:!!1, rt:0, k: 't'},*/
            Arrays.asList( //GAULS
                    new Unit(UnitKind.UNIT, "Phalanx",15, 40, 50, 7,
                            Arrays.asList(100, 130, 55, 30), 1, 1300, 35, true, 5700, ""),
                    new Unit(UnitKind.UNIT, "Swordsman", 65, 35, 20, 6,
                            Arrays.asList(140, 150, 185, 60), 1, 1800, 45, true, 7200, ""),
                    new Unit(UnitKind.SPY, "Pathfinder", 0, 20, 10, 17,
                            Arrays.asList(170, 150, 20, 40), 2, 1700, 0, false, 6900, ""),
                    new Unit(UnitKind.UNIT, "Theutates Thunder", 90, 25, 40, 19,
                            Arrays.asList(350, 450, 230, 60), 2, 3100, 75, false, 11100, ""),
                    new Unit(UnitKind.UNIT, "Druidrider", 45, 115, 55, 16,
                            Arrays.asList(360, 330, 280, 120), 2, 3200, 35, false, 11400, ""),
                    new Unit(UnitKind.UNIT, "Haeduan", 140, 50, 165, 13,
                            Arrays.asList(500, 620, 675, 170), 3, 3900, 65, false, 13500, ""),
                    new Unit(UnitKind.RAM, "Ram", 50, 30, 105, 4,
                            Arrays.asList(950, 555, 330, 75), 3, 5000, 0, true, 16800, ""),
                    new Unit(UnitKind.CAT, "Trebuchet", 70, 45, 10, 3,
                            Arrays.asList(960, 1450, 630, 90), 6, 9000, 0, true, 28800, ""),
                    new Unit(UnitKind.ADMIN, "Chieftain", 40, 50, 50, 5,
                            Arrays.asList(30750, 45400, 31000, 37500), 4, 90700, 0, true, 24475, ""),
                    new Unit(UnitKind.SETTLER, "Settler", 0, 80, 80, 5,
                            Arrays.asList(4400, 5600, 4200, 3900), 1, 22700, 3000, true, 0, "")
                            ),
            Arrays.asList( //NATURE
                    new Unit(UnitKind.UNIT, "Rat",10, 25, 20, 20,
                            Arrays.asList(0, 0, 0, 0), 1, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Spider", 20, 35, 40, 20,
                            Arrays.asList(0, 0, 0, 0), 1, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Serpent", 60, 40, 60, 20,
                            Arrays.asList(0, 0, 0, 0), 1, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Bat", 80, 66, 50, 20,
                            Arrays.asList(0, 0, 0, 0), 1, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Boar", 50, 70, 33, 20,
                            Arrays.asList(0, 0, 0, 0), 2, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Wolf", 100, 80, 70, 20,
                            Arrays.asList(0, 0, 0, 0), 2, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Bear", 250, 140, 200, 20,
                            Arrays.asList(0, 0, 0, 0), 3, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Crocodile", 450, 380, 240, 20,
                            Arrays.asList(0, 0, 0, 0), 3, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Tiger", 200, 170, 250, 20,
                            Arrays.asList(0, 0, 0, 0), 3, 0, 0, true, 0, ""),
                    new Unit(UnitKind.UNIT, "Elephant", 600, 440, 520, 20,
                            Arrays.asList(0, 0, 0, 0), 5, 0, 0, true, 0, "")
            )
    );
}
