// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/network/network_info.dart' as _i75;
import 'features/auth/data/datasources/auth_local_datasource.dart' as _i1043;
import 'features/auth/data/datasources/auth_remote_datasource.dart' as _i588;
import 'features/auth/data/repositories/auth_repository_impl.dart' as _i111;
import 'features/auth/domain/repositories/auth_repository.dart' as _i1015;
import 'features/auth/domain/usecases/login_usecase.dart' as _i206;
import 'features/auth/domain/usecases/register_usecase.dart' as _i693;
import 'features/auth/presentation/bloc/auth_bloc.dart' as _i363;
import 'features/cart/data/datasources/cart_local_datasource.dart' as _i403;
import 'features/cart/data/repositories/cart_repository_impl.dart' as _i302;
import 'features/cart/domain/repositories/cart_repository.dart' as _i303;
import 'features/cart/domain/usecases/add_to_cart_usecase.dart' as _i187;
import 'features/cart/domain/usecases/clear_cart_usecase.dart' as _i97;
import 'features/cart/domain/usecases/get_cart_items_usecase.dart' as _i403;
import 'features/cart/domain/usecases/remove_from_cart_usecase.dart' as _i192;
import 'features/cart/domain/usecases/update_quantity_usecase.dart' as _i796;
import 'features/cart/presentation/bloc/cart_bloc.dart' as _i239;
import 'features/home/data/datasources/home_remote_datasource.dart' as _i400;
import 'features/home/data/repositories/home_repository_impl.dart' as _i689;
import 'features/home/domain/repositories/home_repository.dart' as _i649;
import 'features/home/domain/usecases/get_products_usecase.dart' as _i222;
import 'features/home/presentation/bloc/home_bloc.dart' as _i123;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.lazySingleton<_i403.CartLocalDataSource>(
    () => _i403.CartLocalDataSource(),
  );
  gh.lazySingleton<_i303.CartRepository>(
    () => _i302.CartRepositoryImpl(gh<_i403.CartLocalDataSource>()),
  );
  gh.lazySingleton<_i588.AuthRemoteDataSource>(
    () => _i588.AuthRemoteDataSource(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i400.HomeRemoteDataSource>(
    () => _i400.HomeRemoteDataSource(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i1043.AuthLocalDataSource>(
    () => _i1043.AuthLocalDataSource(gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i187.AddToCartUseCase>(
    () => _i187.AddToCartUseCase(gh<_i303.CartRepository>()),
  );
  gh.lazySingleton<_i97.ClearCartUseCase>(
    () => _i97.ClearCartUseCase(gh<_i303.CartRepository>()),
  );
  gh.lazySingleton<_i403.GetCartItemsUseCase>(
    () => _i403.GetCartItemsUseCase(gh<_i303.CartRepository>()),
  );
  gh.lazySingleton<_i192.RemoveFromCartUseCase>(
    () => _i192.RemoveFromCartUseCase(gh<_i303.CartRepository>()),
  );
  gh.lazySingleton<_i796.UpdateQuantityUseCase>(
    () => _i796.UpdateQuantityUseCase(gh<_i303.CartRepository>()),
  );
  gh.lazySingleton<_i75.NetworkInfo>(
    () => _i75.NetworkInfoImpl(gh<_i895.Connectivity>()),
  );
  gh.lazySingleton<_i649.HomeRepository>(
    () => _i689.HomeRepositoryImpl(gh<_i400.HomeRemoteDataSource>()),
  );
  gh.lazySingleton<_i239.CartBloc>(
    () => _i239.CartBloc(
      gh<_i187.AddToCartUseCase>(),
      gh<_i192.RemoveFromCartUseCase>(),
      gh<_i403.GetCartItemsUseCase>(),
      gh<_i97.ClearCartUseCase>(),
      gh<_i796.UpdateQuantityUseCase>(),
    ),
  );
  gh.lazySingleton<_i222.GetProductsUseCase>(
    () => _i222.GetProductsUseCase(gh<_i649.HomeRepository>()),
  );
  gh.lazySingleton<_i1015.AuthRepository>(
    () => _i111.AuthRepositoryImpl(
      gh<_i588.AuthRemoteDataSource>(),
      gh<_i1043.AuthLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i206.LoginUseCase>(
    () => _i206.LoginUseCase(gh<_i1015.AuthRepository>()),
  );
  gh.lazySingleton<_i693.RegisterUseCase>(
    () => _i693.RegisterUseCase(gh<_i1015.AuthRepository>()),
  );
  gh.lazySingleton<_i363.AuthBloc>(
    () => _i363.AuthBloc(
      gh<_i206.LoginUseCase>(),
      gh<_i693.RegisterUseCase>(),
      gh<_i1015.AuthRepository>(),
    ),
  );
  gh.lazySingleton<_i123.HomeBloc>(
    () => _i123.HomeBloc(gh<_i222.GetProductsUseCase>()),
  );
  return getIt;
}
