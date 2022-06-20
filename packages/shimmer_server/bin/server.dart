import 'package:grpc/grpc.dart';
import 'package:shimmer_server/services/input.dart';

Future<void> main(List<String> args) async {
  List<Service> services = [
    InputService(),
  ];

  final server = Server(
    services,
    const <Interceptor>[],
    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: 50051);
  print('Server listening on port ${server.port}...');
}
