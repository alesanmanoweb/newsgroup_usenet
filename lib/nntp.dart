import 'dart:async';
import 'dart:io';
import 'dart:convert';

class NNTPServer {
  String hostname;
  int port;
  String username;
  String useremail;
  int _count = 0;

  NNTPServer({ this.hostname, this.port, this.username, this.useremail});

  List<NNTPGroup> _groupList;
  List<NNTPMessage> _messageList;
  Completer _completer;
  Socket _socket;

  Future requestGroupList() async {
    _count = 0;
    _groupList = List<NNTPGroup>();
    _completer = Completer();
    Socket.connect(hostname, port).then((socket) {
      _socket = socket;
      print('Connected to: ${_socket.remoteAddress.address}:${_socket
          .remotePort}');
      _socket.cast<List<int>>().transform(utf8.decoder).transform(
          LineSplitter()).listen(_receiveGroupList, onError: _errorHandler);
      _socket.writeln('LIST ACTIVE');
    });
    return _completer.future;
  }

  void _receiveGroupList(String line) {
    _count++;
    if (_count <= 2)
      return; // skipping response headers
    if (line == '.') { // end of response
      print('Received $_count groups.');
      _completer.complete(_groupList);
      _socket.destroy(); // excessive?
      return;
    }
    List<String> groupInfo = line.split(' ');
    if (groupInfo.length != 4) {
      print('Len not 4 - $line');
      return;
    }
    _groupList.add(NNTPGroup(
        groupInfo[0], int.tryParse(groupInfo[1]), int.tryParse(groupInfo[2])));
  }

  void _errorHandler(error) {
    print('***********ERROR!!!!!!!!');
    print(error);
  }

  Future requestMessageList(String group) async {
    _count = 0;
    _messageList = List<NNTPMessage>();
    _completer = Completer();
    int index = -1;
    int firstMsgID;
    int lastMsgID;
    StringBuffer sb = StringBuffer();
    bool inHeader = true;
    bool newArticle = true;
    String subject, from, date, body;
    StreamTransformer charDecoder = latin1.decoder;
    Socket.connect(hostname, port).then((socket) {
      socket.cast<List<int>>().transform(charDecoder).transform(
          LineSplitter()).listen((String line) {
            _count++;
            if(_count <= 1) {
              return; // skipping the general connection greeting
            }
            print('****************************** line: $line');
            if(index == -1) { // We have not received the Group info yet
              print('parsing GROUP');
              // Parsing the GROUP output
              List<String> groupInfo = line.split(' ');
              if (groupInfo.length != 5) {
                // code, tot msg, firstMsgID, lastMsgID, groupname
                print('Len not 5 - $line');
              }
              int code = int.tryParse(groupInfo[0]);
              firstMsgID = int.tryParse(groupInfo[2]);
              lastMsgID = int.tryParse(groupInfo[3]);
              // check return code
              index = firstMsgID; // firstMsgID
              if (lastMsgID - firstMsgID > 20) {
                index = lastMsgID - 20;
              }
              print('first index set to: $index');
              print('Sending ARTICLE $index');
              socket.writeln('ARTICLE $index');
            }
            else { // parsing the ARTICLE output
              if(newArticle) { // parse server response
                List<String> response = line.split(' ');
                int r = int.tryParse(response[0]);
                if(r > 400) { // article not found...
                  print('ARTICLE $index not found...');
                  index++;
                  if(index <= lastMsgID) {
                    print('Sending ARTICLE $index');
                    socket.writeln('ARTICLE $index');
                  }
                  else {
                    print('COMPLETE!');
                    _completer.complete(_messageList);
                    socket.destroy(); // excessive?
                    return;
                  }
                }
                else {
                  newArticle = false;
                  return;
                }
              }
              //print('parsing article');
              if(line == '.') { // message received completely
                print('message complete');
                _messageList.add(NNTPMessage(index, subject, from, date, sb.toString()));
                sb.clear();
                inHeader = true;
                newArticle = true;
                charDecoder = latin1.decoder;
                index++;

                if(index <= lastMsgID) {
                  print('Sending ARTICLE $index');
                  socket.writeln('ARTICLE $index');
                }
                else {
                  print('COMPLETE!');
                  _completer.complete(_messageList);
                  socket.destroy(); // excessive?
                }
              }
              else if(inHeader) {
                print('headerparsing');
                if(line == '') {
                  print('headers finished');
                  inHeader = false;
                }
                else if(line.startsWith('Subject:')) {
                  subject = line.substring(9);
                }
                else if(line.startsWith('From:')) {
                  from = line.substring(6);
                }
                else if(line.startsWith('Date:')) {
                  date = line.substring(5);
                }
                else if(line.startsWith('Content-Type:')) {
                  if (line.toLowerCase().contains('utf-8')) {
                    charDecoder=utf8.decoder;
                  }
                }
              }
              else {
                //print('body');
                sb.writeln(line);
              }
            }
      }, onError: _errorHandler);
      socket.writeln('GROUP $group');
    });
    return _completer.future;
  }

  void _receiveMessageList(String line) {
    _count++;
    if (_count <= 2)
      return; // skipping response headers
    if (line == '.') { // end of response
      print('Received $_count groups.');
      _completer.complete(_groupList);
      _socket.destroy(); // excessive?
      return;
    }
    List<String> groupInfo = line.split(' ');
    if (groupInfo.length != 4) {
      print('Len not 4 - $line');
      return;
    }
    _groupList.add(NNTPGroup(
        groupInfo[0], int.tryParse(groupInfo[1]), int.tryParse(groupInfo[2])));
  }
}

class NNTPGroup {
  final String name;
  final int a1;
  final int a2;

  NNTPGroup(this.name, this.a1, this.a2);
}

class NNTPMessage {
  final int number;
  //String group; // this will likely be necessary at some point
  //String header;
  final String subject;
  final String from;
  final String date;
  final String body;

  NNTPMessage(
      this.number,
      this.subject,
      this.from,
      this.date,
      this.body,
      );
}
