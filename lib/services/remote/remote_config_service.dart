import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  final Logger _logger;
  bool _isInitialized = false;
  StreamSubscription<RemoteConfigUpdate>? _configUpdateSubscription;

  final StreamController<Map<String, dynamic>> _configChangesController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get configChanges =>
      _configChangesController.stream;

  RemoteConfigService(this._remoteConfig, this._logger);

  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.i('Remote Config already initialized');
      return;
    }

    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 60),
          minimumFetchInterval: const Duration(seconds: 3600),
        ),
      );

      await _remoteConfig.setDefaults(const {
        'enableContinueLoginButton': true,
      });

      final activated = await _remoteConfig.fetchAndActivate();
      _isInitialized = true;
      _logger.i(
        'Remote Config initialized successfully. Activated: $activated',
      );

      startListeningForUpdates();
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize Remote Config: $e');
      _logger.e('Stack trace: $stackTrace');
      _isInitialized = false;
      rethrow;
    }
  }

  void startListeningForUpdates() {
    _configUpdateSubscription = _remoteConfig.onConfigUpdated.listen(
      (RemoteConfigUpdate event) async {
        _logger.i('Remote Config updated. Updated keys: ${event.updatedKeys}');

        try {
          await _remoteConfig.activate();
          _logger.i('Remote Config activated successfully');

          final updatedValues = <String, dynamic>{};
          for (final key in event.updatedKeys) {
            updatedValues[key] = _getValueByKey(key);
          }

          _configChangesController.add(updatedValues);
          _logger.i('Notified listeners about config changes');
        } catch (e) {
          _logger.e('Failed to activate updated config: $e');
        }
      },
      onError: (error) {
        _logger.e('Error listening to config updates: $error');
      },
    );
    _logger.i('Started listening for Remote Config updates');
  }

  void stopListeningForUpdates() {
    _configUpdateSubscription?.cancel();
    _configUpdateSubscription = null;
    _logger.i('Stopped listening for Remote Config updates');
  }

  dynamic _getValueByKey(String key) {
    try {
      final value = _remoteConfig.getValue(key);
      final source = value.source;

      if (source == ValueSource.valueStatic) {
        return null;
      }

      final stringValue = value.asString();

      if (stringValue.toLowerCase() == 'true' ||
          stringValue.toLowerCase() == 'false') {
        return stringValue.toLowerCase() == 'true';
      }

      final intValue = int.tryParse(stringValue);
      if (intValue != null) {
        return intValue;
      }

      final doubleValue = double.tryParse(stringValue);
      if (doubleValue != null) {
        return doubleValue;
      }

      return stringValue;
    } catch (e) {
      _logger.e('Failed to get value for key $key: $e');
      return null;
    }
  }

  void dispose() {
    stopListeningForUpdates();
    _configChangesController.close();
    _logger.i('RemoteConfigService disposed');
  }

  bool getEnableContinueLoginButton() {
    try {
      if (!_isInitialized) {
        _logger.w('Remote Config not initialized, using default value');
        return true;
      }
      final value = _remoteConfig.getBool('enableContinueLoginButton');
      _logger.d('enableContinueLoginButton = $value');
      return value;
    } catch (e) {
      _logger.e('Failed to get enableContinueLoginButton: $e');
      return true;
    }
  }

  String getString(String key) {
    try {
      if (!_isInitialized) {
        _logger.w('Remote Config not initialized, using default value');
        return '';
      }
      return _remoteConfig.getString(key);
    } catch (e) {
      _logger.e('Failed to get string value for $key: $e');
      return '';
    }
  }

  int getInt(String key) {
    try {
      if (!_isInitialized) {
        _logger.w('Remote Config not initialized, using default value');
        return 0;
      }
      return _remoteConfig.getInt(key);
    } catch (e) {
      _logger.e('Failed to get int value for $key: $e');
      return 0;
    }
  }

  double getDouble(String key) {
    try {
      if (!_isInitialized) {
        _logger.w('Remote Config not initialized, using default value');
        return 0.0;
      }
      return _remoteConfig.getDouble(key);
    } catch (e) {
      _logger.e('Failed to get double value for $key: $e');
      return 0.0;
    }
  }

  bool getBool(String key) {
    try {
      if (!_isInitialized) {
        _logger.w('Remote Config not initialized, using default value');
        return false;
      }
      return _remoteConfig.getBool(key);
    } catch (e) {
      _logger.e('Failed to get bool value for $key: $e');
      return false;
    }
  }

  bool get isInitialized => _isInitialized;
}
