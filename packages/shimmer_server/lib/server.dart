// Server takes input from clients
// Every server tick, server sends (full) update to all clients?

import 'package:shimmer_shared/network.dart';

class World {}

class ClientConnection {
  List<NetClientUpdate> fromServer = [];
  List<NetClientInput> fromClient = [];
}

class ClientId {}

enum VisionMask {
  red,
  blue,
  all,
}

class ServerNetwork {
  List<ClientConnection> clients = [];

  NetClientInput? takeClientInput(ClientId clientId) {
    return null;
  }

  void sendUpdateToClient(ClientId clientId, NetClientUpdate update) {}
}

class ServerPlayer {
  ServerPlayer(this.clientId, this.vision);

  final ClientId clientId;
  final VisionMask vision;

  bool acceptingInput() => true;

  NetClientState perPlayerState() => NetClientState();

  void applyInput(NetClientInput input) {}
}

// This is written assuming the Server can never get behind.
// Unclear if that's a correct assumption?
// If we need to be defensive against the server stalling that will mean we need
// to hold a buffer of inputs from the client and apply them in time order
// which doesn't seem ideal?  What happens if that buffer overflows?
class Server {
// Has a state of the world
// Has a list of client connections
// Has a list of client states.

  DateTime startTime;
  int msPerTick = 250;
  int currentTick = 0;

  ServerNetwork net = ServerNetwork();
  Iterable<ServerPlayer> players = [];

  Server() : startTime = DateTime.now();

  void processClientInput() {
    // Take a client input and process it
    // e.g. Move to point, or ability 1 with mouse position X.
    // Is MoveToPoint just an ability?
    // Presumably auto-attack timers are handled both server/client side?

    for (var player in players) {
      if (player.acceptingInput()) {
        // This always assumes that the input is valid for this tick.
        var input = net.takeClientInput(player.clientId);
        if (input != null) {
          player.applyInput(input);
        }
      }
    }
  }

  void tickObjects() {
    // Ask all objects to update.
    // Tell flame to tick?
  }

  // Hack for now, Server does not expect to be allowed to get behind.
  void tickIfNeeded(DateTime now) {
    assert(now.isAfter(startTime));
    var timeSinceStart = now.difference(startTime);
    var tickTarget = timeSinceStart.inMilliseconds / msPerTick;
    while (currentTick < tickTarget) {
      tick();
    }
  }

  void tick() {
    currentTick++;
    processClientInput();
    tickObjects();
    // Tell all the clients about what we did.
    broadcastCurrentStateToClients();
  }

  List<NetGameObject> visibleGameObjects(VisionMask vision) {
    return [];
  }

  void broadcastCurrentStateToClients() {
    // Get the per-team visibility mask.
    // Generate current gamestate with visbility mask.
    // Broadcast state to all clients on team.
    // What is the per-client state (e.g. not shared with teammates?)
    for (var player in players) {
      var update = NetClientUpdate(
        global: NetGlobalState(startTime),
        visible: NetVisibleState(visibleGameObjects(player.vision)),
        private: player.perPlayerState(),
      );
      net.sendUpdateToClient(player.clientId, update);
    }
  }
}
