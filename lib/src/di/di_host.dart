import 'package:flutter/material.dart';
import 'di.dart';

class DIHost extends StatefulWidget {
  const DIHost({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  State<DIHost> createState() => _DIHostState();
}

class _DIHostState extends State<DIHost> {
  late final Future configureDependenciesFuture;

  @override
  void initState() {
    super.initState();

    configureDependenciesFuture = configureDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: configureDependenciesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.child;
        } else {
          return Container();
        }
      },
    );
  }
}