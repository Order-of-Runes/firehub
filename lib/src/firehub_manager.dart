// Copyright (c) 2025 Ravikant Authors. All rights reserved.

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'analytics/analytics_manager.dart';

class FireHubManager {
  late final AnalyticsManager _analyticsManager;

  // // Flags
  // bool _hasGms = true;

  /// [Firebase.initializeApp] returns an instance of [FirebaseApp]
  /// The returned instance has not been used for anything else except
  /// verify that [Firebase.initializeApp] has been called
  FirebaseApp? _firebaseApp;

  final Completer<void> _initCompleter = Completer();

  Future<void> init({required FirebaseOptions options}) async {
    if (!isInitialized) {

      _firebaseApp = await _initializeFirebaseApp(options: options);
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

  Future<FirebaseApp> _initializeFirebaseApp({required FirebaseOptions options}) {
    return Firebase.initializeApp(options: options);
  }
}
