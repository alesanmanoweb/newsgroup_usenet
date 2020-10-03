import 'package:flutter/material.dart';
import 'package:newsgroups_usenet/nntp.dart';

class ServerList extends StatefulWidget {
  @override
  _ServerListState createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  List<NNTPServer> serverList = [];

  // default entry:
  _ServerListState() {
    serverList.add(NNTPServer(
      hostname: 'nntp.aioe.org',
      port: 119,
      username: 'Slayer101',
      useremail: 'a@a.com',
    ));
  }

  Widget _serverCard(NNTPServer server) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/group_list', arguments: {
            'server': server,
          });
        },
        child: Card(
          margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                server.hostname,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: serverList.map((s) => _serverCard(s)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateServerEdit(context);
        },
        tooltip: 'Add new server',
        child: Icon(Icons.add),
      ),
    );
  }

  _navigateServerEdit(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/server_edit');
    setState(() {
      serverList.add(result);
    });
    int count = serverList.length;
    print('Servers: $count');
  }
}
