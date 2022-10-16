import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: false,
  asExtension: false,
)
Future<GetIt> configureDependencies() async {
  final dependencyContainer = GetIt.asNewInstance();

  return $initGetIt(dependencyContainer);
}

class Environments {
  static const dev = 'dev';
  static const prod = 'prod';
}
