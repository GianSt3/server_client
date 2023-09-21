import 'package:client/src/data/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClientWindow extends StatefulWidget {
  const ClientWindow({super.key});

  @override
  State<ClientWindow> createState() => _ClientWindowState();
}

class _ClientWindowState extends State<ClientWindow> {
  late Client client;
  List<String> serverLogs = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    client = Client(
      hostname: "127.0.0.1",
      port: 4040,
      onData: onData,
      onError: onError,
    );
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
  dispose() {
    controller.dispose();
    client.disconnect();
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
                        "Client",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: client.connected ? Colors.green : Colors.red,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          client.connected ? 'Connected' : 'Disconnected',
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
                    child: Text(!client.connected
                        ? 'Connect the client'
                        : 'Disconnect the client'),
                    onPressed: () async {
                      if (client.connected) {
                        await client.disconnect();
                        serverLogs.clear();
                      } else {
                        await client.connect();
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
                        'Message to server:',
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
                    client.write(controller.text);
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
