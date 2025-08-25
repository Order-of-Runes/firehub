// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsHub {
  CrashlyticsHub({
    required this.enableInDebug,
  });

  FirebaseCrashlytics? _firebaseCrashlytics;
  bool _isInitialized = false;
  final bool enableInDebug;

  Future<void> init() async {
    if (!_isInitialized && _canLogCrash) {
      _firebaseCrashlytics = _firebaseCrashlytics ?? FirebaseCrashlytics.instance;
      await _firebaseCrashlytics?.setCrashlyticsCollectionEnabled(!kDebugMode || enableInDebug);

      // Pass all uncaught errors from the framework to Crashlytics
      FlutterError.onError = (err) {
        if (err.library != 'SVG') {
          _firebaseCrashlytics?.recordFlutterError(err);
        }
      };

      _isInitialized = true;
    }
  }

  // TODO (Ishwor) Verify validity of the following
  /// Log custom crashes/exceptions not caught by crashlytics automatically. For eg. exceptions
  ///
  /// Firebase :
  ///   8 recent logs are sent to the server
  ///   App restart is required to sync the log in the console
  ///   Rest of logs are discarded
  Future<void> recordError(
    dynamic message, {
    StackTrace? stackTrace,
    bool fatal = false,
    dynamic reason,
  }) async {
    if (_isInitialized) {
      await _firebaseCrashlytics?.recordError(
        message,
        stackTrace,
        printDetails: false,
        fatal: fatal,
        reason: reason,
      );
    }
  }

  @visibleForTesting
  bool get isInitialized => _isInitialized;

  /// Returns true for the following platforms
  /// Android
  /// iOS
  /// Macos
  bool get _canLogCrash =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);
}
