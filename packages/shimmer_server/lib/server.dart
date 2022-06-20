// Server takes input from clients
// Every server tick, server sends (full) update to all clients?

import 'package:shimmer_shared/entity.dart';
import 'package:shimmer_shared/network.dart';

class ClientConnection {
  List<ClientUpdate> fromServer = [];
  List<InputRequest> fromClient = [];
}

typedef ClientId = String;

class ServerNetwork {
  Map<String, ClientConnection> clients = {};

  ClientConnection lookupClient(ClientId clientId) {
    var client = clients[clientId];
    if (client == null) {
      client = ClientConnection();
      clients[clientId] = client;
    }
    return client;
  }

  InputRequest? takeClientInput(ClientId clientId) {
    return null;
  }

  // void sendUpdateToClient(ClientId clientId, ClientUpdate update) {}
}

class ServerPlayer {
  ServerPlayer(this.clientId, this.vision);

  final ClientId clientId;
  final VisionMask vision;

  bool acceptingInput() => true;

  // NetClientState perPlayerState() => NetClientState();

  void applyInput(InputRequest input) {}
}

class World {
  List<Entity> gameObjects = [];

  World();

  void tickObjects(double dt) {
    // Ask all objects to update.
    for (var obj in gameObjects) {
      // Server objects should work off of ticks rather than ms?
      obj.update(dt);
    }
  }
}

// This is written assuming the Server can never get behind.
// Unclear if that's a correct assumption?
// If we need to be defensive against the server stalling that will mean we need
// to hold a buffer of inputs from the client and apply them in time order
// which doesn't seem ideal?  What happens if that buffer overflows?
class ShimmerServer {
// Has a state of the world
// Has a list of client connections
// Has a list of client states.

  DateTime startTime;
  int msPerTick = 250;
  int currentTick = 0;

  ServerNetwork net = ServerNetwork();
  List<ServerPlayer> players = [];
  World world = World();

  ShimmerServer() : startTime = DateTime.now();

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

  void tick() {
    currentTick++;
    processClientInput();
    world.tickObjects(msPerTick / 1000);
    // Tell all the clients about what we did.
    // broadcastCurrentStateToClients();
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

  List<EntityProto> visibleGameObjects(VisionMask vision) {
    return world.gameObjects
        .where((e) => e.visibleTo(vision))
        .map((e) => e.toProto())
        .toList();
  }

  // void broadcastCurrentStateToClients() {
  //   // Get the per-team visibility mask.
  //   // Generate current gamestate with visbility mask.
  //   // Broadcast state to all clients on team.
  //   // What is the per-client state (e.g. not shared with teammates?)
  //   for (var player in players) {
  //     var update = NetClientUpdate(
  //       global: NetGlobalState(startTime),
  //       visible: NetVisibleState(visibleGameObjects(player.vision)),
  //       private: player.perPlayerState(),
  //     );
  //     net.sendUpdateToClient(player.clientId, update);
  //   }
  // }
}

// Things I would like in an event system.
// broadast.
// typed event delivery
// event types which deliver even when not listened initially.

// Has the gameplay logic, including starting the game, etc.
class Shimmer {
  // Should this be event driven?  e.g. onStart?

  // States
  // Waiting for clients
  // Countdown until start.
  // Various events driven from time.

  // OnClientConnected

}

// Hack for now.
ShimmerServer sharedServer = ShimmerServer();
