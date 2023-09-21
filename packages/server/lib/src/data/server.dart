import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

typedef DynamicCallback = Function(dynamic data);
typedef Uint8ListCallback = Function(Uint8List data);

class Server {
  Uint8ListCallback onData;
  DynamicCallback onError;
  ServerSocket? server;
  String address;
  int port;

  Server(
      {required this.onError,
      required this.onData,
      this.address = "127.0.0.1",
      this.port = 4040});

  bool get running => server != null;
  List<Socket> sockets = [];

  start() async {
    runZonedGuarded(() async {
      server = await ServerSocket.bind(address, port);
      server?.listen(onRequest);
      onData(Uint8List.fromList('Server listening on port $port'.codeUnits));
    }, (e, _) {
      onError(e);
    });
  }

  stop() async {
    await server?.close();
    server = null;
  }

  broadCast(String message) {
    onData(Uint8List.fromList('Broadcasting : $message'.codeUnits));
    for (Socket socket in sockets) {
      socket.write('$message\n');
    }
  }

  onRequest(Socket socket) {
    if (!sockets.contains(socket)) {
      sockets.add(socket);
    }
    socket.listen((Uint8List data) {
      onData(data);
    });
  }
}
