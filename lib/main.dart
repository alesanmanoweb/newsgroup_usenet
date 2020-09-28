import 'package:flutter/material.dart';
import 'server_list.dart';
import 'server_edit.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
  routes: {
    '/': (context) => ServerList(),
    '/server_edit': (context) => ServerEdit(),
  },
));
