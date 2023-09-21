import 'package:flutter/material.dart';
import 'package:server/server.dart';

void main() {
  runApp(const ServerApp());
}

class ServerApp extends StatelessWidget {
  const ServerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Server',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ServerWindow(),
    );
  }
}
