import 'package:flutter/material.dart';
import 'package:newsgroups_usenet/nntp.dart';
import 'nntp.dart';

class ServerEdit extends StatefulWidget {
  @override
  _ServerEditState createState() => _ServerEditState();
}

class _ServerEditState extends State<ServerEdit> {
  NNTPServer server = NNTPServer();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Edit'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Server host name:'),
                  keyboardType: TextInputType.url,
                  initialValue: 'news.net',
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Host name is required';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    server.hostname = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Port:'),
                  keyboardType: TextInputType.number,
                  initialValue: '119',
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Port is required';
                    }
                    else {
                      int port = int.tryParse(value);
                      if(port <= 0 || port > (1 << 16)) {
                        return 'Invalid port number';
                      }
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    server.port = int.tryParse(value);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'User name:'),
                  keyboardType: TextInputType.url,
                  initialValue: 'slay',
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'User name is required';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    server.username = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'User e-mail address:'),
                  keyboardType: TextInputType.url,
                  initialValue: 'a@a.com',
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'E-mail is required, even a bogus one';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    server.useremail = value;
                  },
                ),
                SizedBox(height: 40),
                RaisedButton(
                  child: Text(
                      'Done',
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      Navigator.pop(context, server);
                    },
                  )
              ],
              )

          ),
        ),
      )
    );
  }
}
