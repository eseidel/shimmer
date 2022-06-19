import 'package:flame/extensions.dart';
import 'package:shimmer_client/main.dart';
import 'package:shimmer_shared/network.dart';
import 'package:shimmer_shared/geometry.dart';

import 'package:grpc/grpc.dart';
import 'package:shimmer_shared/src/generated/helloworld.pbgrpc.dart';

// Deals with actually sending things over the network from the client.
class NetworkClient {
  final String host;
  final int port;

  NetworkClient(this.host, this.port);

  void sendInput(NetClientInput input) async {
    final channel = ClientChannel(
      'localhost',
      port: 50051,
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        codecRegistry:
            CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );
    final stub = GreeterClient(channel);

    final name = 'world';

    try {
      final response = await stub.sayHello(
        HelloRequest()..name = name,
        options: CallOptions(compression: const GzipCodec()),
      );
      print('Greeter client received: ${response.message}');
    } catch (e) {
      print('Caught error: $e');
    }
    await channel.shutdown();
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
  Client(String host, int port)
      : net = NetworkClient(host, port),
        serverStartTime = DateTime.now();

  NetMessageHeader header() => const NetMessageHeader("foo");

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
      header: client.header(),
      action: NetActionType.moveTo,
      position: netCoords,
      msSinceStart: client.msSinceStart(),
    );
    client.net.sendInput(input);
  }
}
