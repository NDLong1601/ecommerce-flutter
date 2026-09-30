// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:ecommerce_mobile_app/core/logging/app_logger.dart' as _i701;
import 'package:ecommerce_mobile_app/core/logging/console_app_logger.dart'
    as _i314;
import 'package:ecommerce_mobile_app/cubit/counter/counter_cubit.dart' as _i218;
import 'package:ecommerce_mobile_app/cubit/create_account/create_account_cubit.dart'
    as _i483;
import 'package:ecommerce_mobile_app/cubit/profile/profile_cubit.dart' as _i739;
import 'package:ecommerce_mobile_app/cubit/sign_in/sign_in_cubit.dart' as _i980;
import 'package:ecommerce_mobile_app/di/third_party_module.dart' as _i498;
import 'package:ecommerce_mobile_app/services/local/notification_service.dart'
    as _i719;
import 'package:ecommerce_mobile_app/services/remote/firebase_service.dart'
    as _i527;
import 'package:ecommerce_mobile_app/services/remote/remote.dart' as _i83;
import 'package:ecommerce_mobile_app/services/remote/remote_config_service.dart'
    as _i180;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:firebase_remote_config/firebase_remote_config.dart' as _i627;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyModule = _$ThirdPartyModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => thirdPartyModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i558.FlutterSecureStorage>(
      () => thirdPartyModule.flutterSecureStorage,
    );
    gh.factory<_i59.FirebaseAuth>(() => thirdPartyModule.firebaseAuth);
    gh.factory<_i974.FirebaseFirestore>(
      () => thirdPartyModule.firebaseFirestore,
    );
    gh.factory<_i892.FirebaseMessaging>(
      () => thirdPartyModule.firebaseMessaging,
    );
    await gh.factoryAsync<_i627.FirebaseRemoteConfig>(
      () => thirdPartyModule.firebaseRemoteConfig,
      preResolve: true,
    );
    gh.factory<_i163.FlutterLocalNotificationsPlugin>(
      () => thirdPartyModule.flutterLocalNotificationsPlugin,
    );
    gh.factory<_i974.Logger>(() => thirdPartyModule.logger);
    gh.factory<_i218.CounterCubit>(() => _i218.CounterCubit());
    gh.singleton<_i180.RemoteConfigService>(
      () => _i180.RemoteConfigService(
        gh<_i627.FirebaseRemoteConfig>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i701.AppLogger>(() => _i314.ConsoleAppLogger());
    gh.lazySingleton<_i527.FirebaseService>(
      () => _i527.FirebaseService(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i719.NotificationService>(
      () => _i719.NotificationService(
        gh<_i892.FirebaseMessaging>(),
        gh<_i163.FlutterLocalNotificationsPlugin>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i980.SignInCubit>(
      () => _i980.SignInCubit(gh<_i83.FirebaseService>()),
    );
    gh.factory<_i739.ProfileCubit>(
      () => _i739.ProfileCubit(gh<_i83.FirebaseService>()),
    );
    gh.factory<_i483.CreateAccountCubit>(
      () => _i483.CreateAccountCubit(gh<_i83.FirebaseService>()),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i498.ThirdPartyModule {}
