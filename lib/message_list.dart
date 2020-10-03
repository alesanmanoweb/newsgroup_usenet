import 'package:flutter/material.dart';
import 'package:newsgroups_usenet/nntp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  NNTPServer _server;
  NNTPGroup _group;
  Future _futureMessage;
  List<NNTPMessage> _messageList;
  List<NNTPMessage> _filteredMessageList;
  Map _arguments;

  String _formatMessage(NNTPMessage m) {
    return '${m.date} - ${m.from}';
  }

  @override
  Widget build(BuildContext context) {
    if (_server == null) {
      _arguments = ModalRoute.of(context).settings.arguments;
      _server = _arguments['server'];
      _group = _arguments['group'];
      _futureMessage = _server.requestMessageList(_group.name);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(_group.name),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Filter messages',
              ),
              onSubmitted: (searchString) {
                setState(() {
                  print('search: $searchString');
                  _filteredMessageList = _messageList
                      .where((element) => (element.subject
                          .toLowerCase()
                          .contains(searchString.toLowerCase())))
                      .toList();
                  print('filtered groups: ${_filteredMessageList.length}');
                });
              },
            ),
            Expanded(
                child: FutureBuilder(
                    future: _futureMessage,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                            child: Center(
                                child: SpinKitCircle(
                          color: Colors.teal,
                          size: 50.0,
                        )));
                      }
                      if (_messageList == null) {
                        _messageList = snapshot.data;
                        _filteredMessageList = _messageList;
                      }
                      return ListView.builder(
                          itemCount: _filteredMessageList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                title:
                                    Text(_filteredMessageList[index].subject),
                                subtitle: Text(_formatMessage(
                                    _filteredMessageList[index])),
                                onTap: () {
                                  // Navigator.pushNamed(context, '/message_list',
                                  //     arguments: {
                                  //       'server': _server,
                                  //       'group': _filteredGroupList[index],
                                });
                          });
                    })),
          ],
        ));
  }
}
