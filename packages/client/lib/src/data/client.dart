import 'dart:io';
import 'dart:typed_data';

typedef DynamicCallback = Function(dynamic data);
typedef Uint8ListCallback = Function(Uint8List data);

class Client {
  String hostname;
  int port;
  Uint8ListCallback onData;
  DynamicCallback onError;

  Client({
    required this.onError,
    required this.onData,
    required this.hostname,
    this.port = 4040,
  });

  bool connected = false;

  late Socket socket;

  connect() async {
    try {
      socket = await Socket.connect(hostname, port);
      socket.listen(
        onData,
        onError: onError,
        onDone: disconnect,
        cancelOnError: false,
      );
      connected = true;
    } on Exception catch (exception) {
      onData(Uint8List.fromList("Error : $exception".codeUnits));
    }
  }

  write(String message) {
    //Connect standard in to the socket
    socket.write('$message\n');
  }

  disconnect() {
    socket.destroy();
    connected = false;
  }
}
