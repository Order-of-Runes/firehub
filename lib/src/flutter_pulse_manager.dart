
// Copyright (c) 2025 Ravikant Authors. All rights reserved.

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'analytics/analytics_manager.dart';

/// Signature of callback passed to [initialize] that is triggered when user
/// taps on a notification.
typedef SelectNotificationCallback = Future<dynamic> Function(String? payload);

class FirebaseFireManager {
  late final AnalyticsManager _analyticsManager;
  // // Flags
  // bool _hasGms = true;

  /// [Firebase.initializeApp] returns an instance of [FirebaseApp]
  /// The returned instance has not been used for anything else except
  /// verify that [Firebase.initializeApp] has been called
  FirebaseApp? _firebaseApp;

  final Completer<void> _initCompleter = Completer();

  Future<void> init() async {
    if (!isInitialized) {
      // Initialize firebase core
      // _platform ??= const LocalPlatform();

      _firebaseApp = await _initializeFirebaseApp();
      // Initialize crashlytics & analytics
      _analyticsManager = AnalyticsManager();
      await _analyticsManager.init();
      _initCompleter.complete();
    }
  }

  @visibleForTesting
  bool get isInitialized => _initCompleter.isCompleted;

  @visibleForTesting
  FirebaseApp? get firebaseApp => _firebaseApp;

  Future<AnalyticsManager> get analyticsManager async {
    await _initCompleter.future;
    return _analyticsManager;
  }

  Future<FirebaseApp> _initializeFirebaseApp() {
    return Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}
