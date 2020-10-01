import 'dart:async';
import 'dart:io';
import 'dart:convert';

class NNTPServer {
  String hostname;
  int port;
  String username;
  String useremail;
  int count = 0;

  NNTPServer({ this.hostname, this.port, this.username, this.useremail});

  List<NNTPGroup> _groupList;
  Completer _completer;

  Future requestGroupList() async {
    count = 0;
    _groupList = List<NNTPGroup>();
    _completer = Completer();
    Socket.connect(hostname, port).then((socket) {
      print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      socket.cast<List<int>>().transform(utf8.decoder).transform(LineSplitter()).listen(_receiveGroupList, onError: _errorHandler);
      socket.writeln('LIST ACTIVE');
    });
    return _completer.future;
  }

  void _receiveGroupList(String line) {
    count++;
    if(count <= 2)
      return; // skipping response headers
    if(count < 10){ print('receiveList: $line');}
    if(line == '.') { // end of response
      print('Received $count groups.');
      _completer.complete(_groupList);
    }
    // List<String> groupInfo = line.split(' ');
    // _groupList.add(NNTPGroup(groupInfo[0], int.tryParse(groupInfo[1]), int.tryParse(groupInfo[2])));
    _groupList.add(NNTPGroup(line, 0, 1));
  }

  void _errorHandler(error) {
    print('***********ERROR!!!!!!!!');
    print(error);
  }
}

class NNTPGroup {
  final String name;
  final int a1;
  final int a2;

  NNTPGroup(this.name, this.a1, this.a2);
}
