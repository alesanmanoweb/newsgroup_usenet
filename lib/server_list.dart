import 'package:flutter/material.dart';

class ServerList extends StatefulWidget {
  @override
  _ServerListState createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server List'),
      ),
      body: Text("server list"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/server_edit');
        },
        tooltip: 'Add new server',
        child: Icon(Icons.add),
      ),
    );
  }
}
