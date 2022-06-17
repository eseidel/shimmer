// Server takes input from clients

// Every server tick, server sends (full) update to all clients.

// Should ideally be same as client?
import 'package:flame/components.dart';

class World {}

class NetworkAction {}

enum NetActionType {
  moveTo,
}

class NetClientInput {
  const NetClientInput(this.action, this.position);

  // action is probably a string?
  final NetActionType action;
  final Vector2 position;
}

class NetAction {
  const NetAction(this.actionType, this.startTick);

  final NetActionType actionType;
  final int startTick;
}

class NetGameObject {
  const NetGameObject(this.id, this.position, this.action);
  final String id;
  final Vector2 position;
  final NetAction action;
}

class NetClientState {
  // current ability timeouts?
}

class NetClientUpdate {
  const NetClientUpdate(this.gameObjects, this.privateState);

  // Should this split by visibility?
  // e.g. "global info", "team info", "private info"?

  // Visible object states?
  // minion positions and action and startime
  // player positions and action and startime
  final List<NetGameObject> gameObjects;

  // Per client specific state (like active abilies?)
  final NetClientState privateState;
}

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

class Server {
// Has a state of the world
// Has a list of client connections
// Has a list of client states.

  ServerNetwork net = ServerNetwork();
  Iterable<ServerPlayer> players = [];

  void processClientInput() {
    // Take a client input and process it
    // e.g. Move to point, or ability 1 with mouse position X.
    // Is MoveToPoint just an ability?
    // Presumably auto-attack timers are handled both server/client side?

    for (var player in players) {
      if (player.acceptingInput()) {
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

// Ticks every serverTickDelta.
  void tick() {
    processClientInput();
    tickObjects();
    // Tell all the clients about what we did.
    broadcastCurrentStateToClients();
  }

  List<NetGameObject> gameStateWithVision(VisionMask vision) {
    return [];
  }

  void broadcastCurrentStateToClients() {
    // Get the per-team visibility mask.
    // Generate current gamestate with visbility mask.
    // Broadcast state to all clients on team.
    // What is the per-client state (e.g. not shared with teammates?)
    for (var player in players) {
      var update = NetClientUpdate(
          gameStateWithVision(player.vision), player.perPlayerState());
      net.sendUpdateToClient(player.clientId, update);
    }
  }
}
