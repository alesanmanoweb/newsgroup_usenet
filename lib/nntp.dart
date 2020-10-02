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
  Socket _socket;

  Future requestGroupList() async {
    count = 0;
    _groupList = List<NNTPGroup>();
    _completer = Completer();
    Socket.connect(hostname, port).then((socket) {
      _socket = socket;
      print('Connected to: ${_socket.remoteAddress.address}:${_socket.remotePort}');
      _socket.cast<List<int>>().transform(utf8.decoder).transform(LineSplitter()).listen(_receiveGroupList, onError: _errorHandler);
      _socket.writeln('LIST ACTIVE');
    });
    return _completer.future;
  }

  void _receiveGroupList(String line) {
    count++;
    if(count <= 2)
      return; // skipping response headers
    if(line == '.') { // end of response
      print('Received $count groups.');
      _completer.complete(_groupList);
      _socket.destroy(); // excessive?
      return;
    }
    List<String> groupInfo = line.split(' ');
    if(groupInfo.length != 4) {
      print('Len not 4 - $line');
      return;
    }
    _groupList.add(NNTPGroup(groupInfo[0], int.tryParse(groupInfo[1]), int.tryParse(groupInfo[2])));
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
