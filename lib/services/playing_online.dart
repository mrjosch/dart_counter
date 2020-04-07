
import 'dart:convert';

import 'package:dart_counter/artefacts/ConfigChange.dart';
import 'package:dart_counter/artefacts/Container.dart';
import 'package:dart_counter/artefacts/GameJoin.dart';
import 'package:dart_counter/artefacts/Packet.dart';
import 'package:dart_counter/artefacts/PerformThrow.dart';
import 'package:dart_counter/artefacts/ServerJoin.dart';
import 'package:dart_counter/artefacts/Snapshot.dart';
import 'package:dart_counter/model/game/Player.dart';
import 'package:dart_counter/model/game/Throw.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PlayingOnlineService {

  final Client _client = Client.instance;

  /// connect to to playing service
  Future<void> connect() async {
    await _client.connect();
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
    return _client.channel.stream.map(_packetFromWebsocket);
  }


  void createGame() {
    _client.send('createGame', null);
  }

  void joinServer(String userId) {
    _client.send('serverJoin', ServerJoin(userId));
  }

  void joinGame(String gameId) {
    _client.send('gameJoin', GameJoin(gameId));
    //_client.send('startGame', null);
  }


  void toggleMode() {
    _client.send('configChange', ConfigChange('toggleMode', null));
  }

  void setSize(int size) {
    _client.send('configChange', ConfigChange('setSize', size));
  }

  void toggleType() {
    _client.send('configChange', ConfigChange('toggleType', null));
  }

  void setStartingPoints(int startingPoints) {
    _client.send('configChange', ConfigChange('setStartingPoints', startingPoints));
  }

  bool addPlayer(Player player) {
    // TODO
  }

  void removePlayer(int index) {
    // TODO
  }

  void startGame() {
    _client.send('startGame', null);
  }

  void performThrow(Throw t) {
    _client.send('performThrow', PerformThrow(t));
  }

  void undoThrow() {
    _client.send('undoThrow', null);
  }

}

class Client {

  //WebSocket webSocket;

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

