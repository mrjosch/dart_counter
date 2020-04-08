
import 'dart:convert';

import 'package:dart_counter/networking/artefacts/ConfigChange.dart';
import 'package:dart_counter/networking/artefacts/Container.dart';
import 'package:dart_counter/networking/artefacts/GameJoin.dart';
import 'package:dart_counter/networking/artefacts/Packet.dart';
import 'package:dart_counter/networking/artefacts/PerformThrow.dart';
import 'package:dart_counter/networking/artefacts/ServerJoin.dart';
import 'package:dart_counter/networking/artefacts/Snapshot.dart';
import 'package:dart_counter/model/Player.dart';
import 'package:dart_counter/model/Throw.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PlayingOnlineService {

  final Client _serverClient = Client.instance;

  /// connect to to playing service
  Future<void> connect() async {
    await _serverClient.connect();
  }

  /// create Packet based on incoming data
  Packet _packetFromWebsocket(json) {
    var container = Container.fromJson(jsonDecode(json));

    switch(container.type) {
      case 'snapshot':
        return container.payload as Snapshot;
      default:
        return null;
    }
  }

  /// incoming packet stream
  Stream<Packet> get packets {
    return _serverClient.channel.stream.map(_packetFromWebsocket);
  }


  void createGame() {
    _serverClient.send('createGame', null);
  }

  void joinServer(String userId) {
    _serverClient.send('serverJoin', ServerJoin(userId));
  }

  void joinGame(String gameId) {
    _serverClient.send('gameJoin', GameJoin(gameId));
    //_serverClient.send('startGame', null);
  }


  void toggleMode() {
    _serverClient.send('configChange', ConfigChange('toggleMode', null));
  }

  void setSize(int size) {
    _serverClient.send('configChange', ConfigChange('setSize', size));
  }

  void toggleType() {
    _serverClient.send('configChange', ConfigChange('toggleType', null));
  }

  void setStartingPoints(int startingPoints) {
    _serverClient.send('configChange', ConfigChange('setStartingPoints', startingPoints));
  }

  bool addPlayer(Player player) {
    // TODO
  }

  void removePlayer(int index) {
    // TODO
  }

  void startGame() {
    _serverClient.send('startGame', null);
  }

  void performThrow(Throw t) {
    _serverClient.send('performThrow', PerformThrow(t));
  }

  void undoThrow() {
    _serverClient.send('undoThrow', null);
  }

}

class Client {

  WebSocketChannel channel;

  Client._();

  static final Client instance = Client._();

  Future<void> connect() async {
    channel = IOWebSocketChannel.connect('ws://192.168.178.108:8002/');
  }

  void send(String type, Packet packet) {
    Container container = Container(type, packet);
    _send(jsonEncode(container));
  }

  void _send(String json) {
    print('Sent: $json');
    channel.sink.add(json);
  }

  void close() {
    channel.sink.close();
  }

}
