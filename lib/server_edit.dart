// each server has:
// host
// port
// userdata (name, email)
// settings

import 'package:flutter/material.dart';

class ServerEdit extends StatefulWidget {
  @override
  _ServerEditState createState() => _ServerEditState();
}

class _ServerEditState extends State<ServerEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Edit'),
      ),
      body: Text("server edit"),
      // Column
        // hostname
        // port
        // button OK
    );
  }
}
