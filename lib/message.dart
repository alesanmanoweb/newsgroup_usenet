import 'package:flutter/material.dart';
import 'package:newsgroups_usenet/nntp.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map _arguments = ModalRoute.of(context).settings.arguments;
    final NNTPServer _server = _arguments['server'];
    final NNTPGroup _group = _arguments['group'];
    final NNTPMessage _message = _arguments['message'];
    print('Subject: ${_message.subject}');
    print('Body: ${_message.body}');
    return Scaffold(
      appBar: AppBar(
        title: Text(_message.subject),
      ),
      body: Container(
        child: Text(_message.body),
      ),
    );
  }
}
