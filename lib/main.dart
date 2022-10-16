import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/src/di/di_host.dart';
import 'package:task_manager/src/presentation/base/navigation/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DIHost(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        title: 'Task manager',
      ),
    );
  }
}
