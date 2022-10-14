import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/src/presentation/features/screens/home/home_screen.dart';

final routerDelegate = BeamerDelegate(
  guards: [],
  initialPath: HomeScreen.screenName,
  locationBuilder: RoutesLocationBuilder(
    routes: <String, Widget Function(BuildContext, BeamState, Object?)>{
      HomeScreen.screenName: (c, s, o) => const HomeScreen(),
    },
  ),
);