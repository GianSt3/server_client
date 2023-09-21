import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:server/src/data/server.dart';

class ServerWindow extends StatefulWidget {
  const ServerWindow({super.key});

  @override
  State<ServerWindow> createState() => _ServerWindowState();
}

class _ServerWindowState extends State<ServerWindow> {
  late Server server;
  List<String> serverLogs = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    server = Server(onData: onData, onError: onError);
  }

  onData(Uint8List data) {
    DateTime time = DateTime.now();
    serverLogs
        .add("${time.hour}h${time.minute} : ${String.fromCharCodes(data)}");
    setState(() {});
  }

  onError(dynamic error) {
    if (kDebugMode) {
      print(error);
    }
  }

  @override
  void dispose() {
    server.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Server",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: server.running ? Colors.green : Colors.red,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          server.running ? 'ON' : 'OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    child: Text(server.running
                        ? 'Stop the server'
                        : 'Start the server'),
                    onPressed: () async {
                      if (server.running) {
                        await server.stop();
                        serverLogs.clear();
                      } else {
                        await server.start();
                      }
                      setState(() {});
                    },
                  ),
                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.black12,
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: serverLogs.map((String log) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(log),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 80,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Broadcast message:',
                        style: TextStyle(
                          fontSize: 8,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                MaterialButton(
                  onPressed: () {
                    controller.text = "";
                  },
                  minWidth: 30,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: const Icon(Icons.clear),
                ),
                const SizedBox(
                  width: 15,
                ),
                MaterialButton(
                  onPressed: () {
                    server.broadCast(controller.text);
                    controller.text = "";
                  },
                  minWidth: 30,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: const Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
