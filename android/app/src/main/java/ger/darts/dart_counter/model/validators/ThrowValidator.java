package ger.darts.dart_counter.model.validators;


public class ThrowValidator {

    // INTERFACE
    public static boolean isValidThrow(int pointsScored, int pointsLeft) {
        return pointsScored <= pointsLeft && pointsScored >= 0 && pointsScored <= 180 && pointsScored != 179 && pointsScored != 178 && pointsScored != 176 && pointsScored != 175 && pointsScored != 173 && pointsScored != 172 && pointsScored != 169 && pointsScored != 166 && pointsScored != 163;
    }

    public static boolean isValidFinish(int points) {
        return points > 1 && points < 170 && points != 169 && points != 168 && points != 166 && points != 165 && points != 163 && points != 162 && points != 159;
    }

}
