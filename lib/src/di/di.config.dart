// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;
import 'package:task_manager/src/data/repositories/date_repository.dart' as _i6;
import 'package:task_manager/src/data/storages/dates_storage.dart' as _i4;
import 'package:task_manager/src/di/modules/shared_module.dart' as _i9;
import 'package:task_manager/src/domain/repositories/date_repository.dart'
    as _i5;
import 'package:task_manager/src/presentation/features/screens/day/day_cubit.dart'
    as _i7;
import 'package:task_manager/src/presentation/features/screens/home/home_cubit.dart'
    as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final sharedModule = _$SharedModule();
  await gh.factoryAsync<_i3.SharedPreferences>(
    () => sharedModule.sharedPreferences,
    preResolve: true,
  );
  gh.singleton<_i4.DatesStorage>(
      _i4.DatesStorage(get<_i3.SharedPreferences>()));
  gh.lazySingleton<_i5.DateRepository>(
      () => _i6.DateRepositoryImpl(get<_i4.DatesStorage>()));
  gh.factory<_i7.DayCubit>(() => _i7.DayCubit(get<_i5.DateRepository>()));
  gh.factory<_i8.HomeCubit>(() => _i8.HomeCubit(get<_i5.DateRepository>()));
  return get;
}

class _$SharedModule extends _i9.SharedModule {}
