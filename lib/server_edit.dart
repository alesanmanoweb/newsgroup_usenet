// each server has:
// host
// port
// userdata (name, email)
// settings

import 'package:flutter/material.dart';

class ServerEdit extends StatefulWidget {
  @override
  _ServerEditState createState() => _ServerEditState();
}

class _ServerEditState extends State<ServerEdit> {
  String hostName;
  int port;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Edit'),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Server host name:'),
                keyboardType: TextInputType.url,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Host name is required';
                  }
                  return null;
                },
                onSaved: (String value) {
                  hostName = value;
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
                  port = int.tryParse(value);
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

                    print(hostName);
                    print(port);
                  },
                )
            ],
            )

        ),
      )
    );
  }
}
