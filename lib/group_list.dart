import 'package:flutter/material.dart';
import 'package:newsgroups_usenet/nntp.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {

  NNTPServer _server;
  Future _futureGroup;

  @override
  Widget build(BuildContext context) {
    _server = ModalRoute.of(context).settings.arguments;
    _futureGroup = _server.requestGroupList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Group List'),
      ),
      body:  Container(
        child: FutureBuilder(
          future: _futureGroup,
          builder: (context, snapshot) {
            if(snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('loading'),
                )
              );
            }
            else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data[index].name),
                      subtitle: Text('${snapshot.data[index].a1} - ${snapshot.data[index].a2}'),
                    );
                  }
              );
            }
          },
        ),
      )
    );
  }
}
