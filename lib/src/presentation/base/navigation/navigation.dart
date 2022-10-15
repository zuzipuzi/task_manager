import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/src/presentation/base/cubit/host_cubit.dart';
import 'package:task_manager/src/presentation/features/screens/day/day_cubit.dart';
import 'package:task_manager/src/presentation/features/screens/day/day_screen.dart';
import 'package:task_manager/src/presentation/features/screens/home/home_cubit.dart';
import 'package:task_manager/src/presentation/features/screens/home/home_screen.dart';

final routerDelegate = BeamerDelegate(
  guards: [],
  initialPath: HomeScreen.screenName,
  locationBuilder: RoutesLocationBuilder(
    routes: <String, Widget Function(BuildContext, BeamState, Object?)>{
      HomeScreen.screenName: (c, s, o) =>
          const HostCubit<HomeCubit>(child: HomeScreen()),
      DayScreen.screenName: (c, s, o) =>
          const HostCubit<DayCubit>(child: DayScreen()),
    },
  ),
);
