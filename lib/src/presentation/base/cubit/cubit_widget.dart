import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CubitWidget<S, C extends Cubit<S>> extends StatelessWidget {
  const CubitWidget({Key? key}) : super(key: key);

  C cubit(BuildContext context) => BlocProvider.of<C>(context);

  T arguments<T>(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments as T;

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, S>(
      listener: onStateChanged,
      child: Builder(builder: (context) {
        initParams(context);

        return buildWidget(context);
      }),
    );
  }

  Widget observeState({
    required BlocWidgetBuilder<S> builder,
    BlocBuilderCondition<S>? buildWhen,
  }) {
    return BlocBuilder<C, S>(
      builder: builder,
      buildWhen: buildWhen,
    );
  }

  void initParams(BuildContext context) {}

  void onStateChanged(BuildContext context, S state) {}

  Widget buildWidget(BuildContext context);
}
