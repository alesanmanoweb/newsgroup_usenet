import 'package:flutter/material.dart';
import 'server_list.dart';
import 'server_edit.dart';
import 'group_list.dart';
import 'message_list.dart';
import 'message.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
  routes: {
    '/': (context) => ServerList(),
    '/server_edit': (context) => ServerEdit(),
    '/group_list': (context) => GroupList(),
    '/message_list': (context) => MessageList(),
    '/message': (context) => Message(),
  },
));
