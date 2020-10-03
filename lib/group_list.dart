import 'package:flutter/material.dart';
import 'package:newsgroups_usenet/nntp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  NNTPServer _server;
  Future _futureGroup;
  List<NNTPGroup> _groupList;
  List<NNTPGroup> _filteredGroupList;
  Map _arguments;

  String _formatGroup(NNTPGroup g) {
    int n = g.a1 - g.a2;
    if (n <= 0) {
      return 'No messages';
    }
    return '$n messages';
  }

  @override
  Widget build(BuildContext context) {
    if (_server == null) {
      _arguments = ModalRoute.of(context).settings.arguments;
      _server = _arguments['server'];
      _futureGroup = _server.requestGroupList();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(_server.hostname),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Filter groups',
              ),
              onSubmitted: (searchString) {
                setState(() {
                  print('search: $searchString');
                  _filteredGroupList = _groupList
                      .where((element) => (element.name
                          .toLowerCase()
                          .contains(searchString.toLowerCase())))
                      .toList();
                  print('filtered groups: ${_filteredGroupList.length}');
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: _futureGroup,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                        child: Center(
                            child: SpinKitCircle(
                      color: Colors.teal,
                      size: 50.0,
                    )));
                  }
                  if (_groupList == null) {
                    _groupList = snapshot.data;
                    _filteredGroupList = _groupList;
                  }
                  return ListView.builder(
                      itemCount: _filteredGroupList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(_filteredGroupList[index].name),
                            subtitle:
                                Text(_formatGroup(_filteredGroupList[index])),
                            onTap: () {
                              Navigator.pushNamed(context, '/message_list',
                                  arguments: {
                                    'server': _server,
                                    'group': _filteredGroupList[index],
                                  });
                            });
                      });
                },
              ),
            ),
          ],
        ));
  }
}
