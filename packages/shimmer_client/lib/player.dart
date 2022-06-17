import 'package:flame/extensions.dart';
import 'package:shimmer_client/main.dart';
import 'package:shimmer_shared/network.dart';
import 'package:shimmer_shared/geometry.dart';

import 'package:http/http.dart' as http;

// Deals with actually sending things over the network from the client.
class NetworkClient {
  final Uri baseEndpoint;

  NetworkClient(this.baseEndpoint);

  void sendInput(NetClientInput input) {
    var endpoint = baseEndpoint.resolve('input');
    http.post(endpoint, body: input.toJson().toString());
  }

  NetClientUpdate? getLatestUpdate() {
    return null;
  }
}

// Holds the client side of server state.
class Client {
  int currentTick = 0;
  NetworkClient net;

  // This should be the server start time.
  DateTime serverStartTime;

  // This is a hack/wrong.
  Client(Uri endpoint)
      : net = NetworkClient(endpoint),
        serverStartTime = DateTime.now();

  int msSinceStart() =>
      DateTime.now().difference(serverStartTime).inMilliseconds;
}

// Abstract interface for server-controlled things.
abstract class ServerUpdatable {
  // Server id for matching?
  // void speculativeStartAction(NetAction action);
  void serverPositionChanged(Position serverPosition);
  void serverRemoved();
  // setActionState
}

// Interface from client Game into Player logic
class Player {
  Client client;
  // This doesn't have to be a component, just an interface I can call to move.
  ServerUpdatable playerComponent;

  Player(this.client, this.playerComponent);

  void moveTo(Vector2 gameCoords) {
    var netCoords = unitSystem.fromGameToNetCoords(gameCoords);
    // Start local (speculative) action.
    // playerComponent.speculativeStartAction();
    // Send action to server.
    var input = NetClientInput(
      action: NetActionType.moveTo,
      position: netCoords,
      msSinceStart: client.msSinceStart(),
    );
    client.net.sendInput(input);
  }
}
