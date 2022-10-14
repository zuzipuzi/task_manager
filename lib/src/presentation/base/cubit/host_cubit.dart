import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/di/di.dart';

class HostCubit<T extends BlocBase> extends StatelessWidget {
  const HostCubit({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: (_) => getIt.get(),
      child: child,
    );
  }
}