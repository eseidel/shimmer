import 'package:flame/extensions.dart';
import 'package:shimmer_client/main.dart';
import 'package:shimmer_shared/network.dart';
import 'package:shimmer_shared/geometry.dart';

// Deals with actually sending things over the network from the client.
class NetworkClient {
  final Uri endpoint;

  NetworkClient(this.endpoint);

  void sendInput(NetClientInput input) {}

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
  void serverPositionChanged(Position serverPosition);
  void serverRemoved();
  // setActionState
  // remove
}

// Interface from client Game into Player logic
class Player {
  Client client;
  // This doesn't have to be a component, just an interface I can call to move.
  ServerUpdatable component;

  Player(this.client, this.component);

  void moveTo(Vector2 gameCoords) {
    var netCoords = unitSystem.fromGameToNetCoords(gameCoords);
    // Start local (speculative) action.
    // Send action to server.
    var input = NetClientInput(
      action: NetActionType.moveTo,
      position: netCoords,
      msSinceStart: client.msSinceStart(),
    );
    client.net.sendInput(input);
  }
}
