// Copyright (c) 2025 Ravikant Authors. All rights reserved.

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firehub/src/analytics/analytics_hub.dart';
import 'package:firehub/src/analytics/crashlytics_hub.dart';
import 'package:flutter/foundation.dart';

class Firehub {
  Firehub({
    required this.options,
    this.crashlyticsPulse = const FirePulse(),
    this.analyticsPulse = const FirePulse(),
  });

  /// [Firebase.initializeApp] returns an instance of [FirebaseApp]
  /// The returned instance has not been used for anything else except
  /// verify that [Firebase.initializeApp] has been called
  late final FirebaseApp _firebaseApp;

  late final AnalyticsHub? _analyticsHub;
  late final CrashlyticsHub? _crashlyticsHub;

  final FirePulse crashlyticsPulse;
  final FirePulse analyticsPulse;

  final FirebaseOptions options;

  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _firebaseApp = await Firebase.initializeApp(options: options);

      // Initialize crashlytics & analytics
      if (crashlyticsPulse.enable) {
        _crashlyticsHub = CrashlyticsHub(
          enableInDebug: crashlyticsPulse.enableLoggingInDebug,
        );
        await _crashlyticsHub!.init();
      }

      if (analyticsPulse.enable) {
        _analyticsHub = AnalyticsHub(
          enableInDebug: analyticsPulse.enableLoggingInDebug,
        );
        await _analyticsHub!.init();
      }

      _isInitialized = true;
    }
  }

  AnalyticsHub? get analyticsHub => _analyticsHub;

  CrashlyticsHub? get crashlyticsHub => _crashlyticsHub;

  @visibleForTesting
  FirebaseApp get firebaseApp => _firebaseApp;
}

class FirePulse {
  const FirePulse({
    this.enable = true,
    this.enableLoggingInDebug = false,
  });

  const FirePulse.none() : enable = false, enableLoggingInDebug = false;

  final bool enable;
  final bool enableLoggingInDebug;
}
