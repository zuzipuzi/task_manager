import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'di.dart';

class DIHost extends StatelessWidget {
  const DIHost({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  static GetIt of(BuildContext context) {
    return Provider.of<GetIt>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: configureDependencies(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Provider(
                lazy: false,
                create: (_) => snapshot.data as GetIt,
                child: child,
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
