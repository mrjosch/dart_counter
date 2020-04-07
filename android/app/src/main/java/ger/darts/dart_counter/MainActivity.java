package ger.darts.dart_counter;

import android.content.Context;
import android.os.Bundle;
import android.view.WindowManager;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;

import ger.darts.dart_counter.model.Player;
import ger.darts.dart_counter.model.Throw;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {

    public static String MAIN_CHANNEL = "darts:talk";

    private MethodChannel main_channel;

    private ArrayList<MethodChannel> playerChannels;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        main_channel = new MethodChannel(getFlutterView(), MAIN_CHANNEL);
        setContentView(getFlutterView());

        main_channel.setMethodCallHandler(
                (call, result) -> {
                    String method = call.method;
                    switch (method) {
                        case "openPreGame":
                            onCreatePreGame();
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }


    private void onCreatePreGame() {
        main_channel.setMethodCallHandler(
                (call, result) -> {
                    String method = call.method;
                    switch (method) {
                        case "startGame":
                            HashMap<String, Object> args = (HashMap<String, Object>) call.arguments;
                            HashMap<String, String> config = (HashMap<String, String>) args.get("config");
                            ArrayList<String> players = (ArrayList<String>) args.get("players");
                            Controller.createGame(config, players);

                            playerChannels = new ArrayList<>();
                            for (int i = 0; i < players.size() ; i++) {
                                playerChannels.add(new MethodChannel(getFlutterView(), MAIN_CHANNEL+":"+i));
                            }

                            onCreateInGame();
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }


    private void onCreateInGame() {
        main_channel.setMethodCallHandler(
                (call, result) -> {
                    String method = call.method;

                    switch (method) {
                        case "getCurrentPoints":
                            result.success(String.valueOf(Controller.game.getCurrentTurn().getPointsLeft()));
                            break;
                        case "getDescription":
                            result.success(Controller.game.getDescription());
                            break;
                        case "getPlayerData":
                            int index = Integer.valueOf((String)call.arguments);

                            Player player = Controller.game.getPlayers().get(index);
                            HashMap<String, String> map = new HashMap<>();
                            map.put("name", String.valueOf(player.getName()));
                            map.put("pointsLeft", String.valueOf(player.getPointsLeft()));
                            map.put("dartsThrown", String.valueOf(player.getDartsThrown()));
                            map.put("checkoutPercentage", String.valueOf(player.getCheckOutPercentage()));
                            map.put("average", String.valueOf(player.getAverage()));
                            map.put("pointsLastThrow", String.valueOf(player.getLastThrow()));
                            map.put("legsWon", String.valueOf(player.getWonLegs()));
                            map.put("setsWon", String.valueOf(player.getWonSets()));
                            map.put("turn", String.valueOf(Controller.game.getCurrentTurn().equals(player)));
                            result.success(map);
                            break;
                        case "onCommit":
                            ArrayList<String> data = (ArrayList<String>) call.arguments;
                            int points = Integer.valueOf(data.get(0));
                            int dartsOnDouble = Integer.valueOf(data.get(1));
                            int dartsThrown = Integer.valueOf(data.get(2));

                            Throw t = new Throw(points, dartsThrown, dartsOnDouble, Controller.game.getCurrentTurn());
                            Controller.game.prepareThrow(t);
                            Controller.game.performThrow();

                            if(Controller.game.getWinner() == null) {
                                for (int i = 0; i < Controller.game.getPlayers().size(); i++) {
                                    playerChannels.get(i).invokeMethod("refresh", null);
                                }
                            } else {
                                main_channel.invokeMethod("finishGame", null);
                                onCreatePostGame();
                            }
                            break;
                        case "onUndo":
                            Controller.game.undoLastThrow();
                            for (int i = 0; i < Controller.game.getPlayers().size(); i++) {
                                playerChannels.get(i).invokeMethod("refresh", null);
                            }
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    private void onCreatePostGame() {
        main_channel.setMethodCallHandler(
                (call, result) -> {
                    String method = call.method;
                    switch (method) {
                        case "openPreGame":
                            onCreatePreGame();
                            break;
                    }
                });
    }

    @Override
    public FlutterView createFlutterView(Context context) {
        Controller.route = "LOGO";

        WindowManager.LayoutParams matchParent = new WindowManager.LayoutParams(-1, -1);
        FlutterNativeView nativeView = this.createFlutterNativeView();
        FlutterView flutterView = new FlutterView(this, null, nativeView);
        flutterView.setInitialRoute(Controller.route);
        flutterView.setLayoutParams(matchParent);



        return flutterView;
    }

}
