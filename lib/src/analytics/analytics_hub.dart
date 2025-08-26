// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firehub/src/foundation/fire_event.dart';
import 'package:flutter/foundation.dart';

class AnalyticsHub {
  AnalyticsHub({this.enableInDebug = false});

  bool _isInitialized = false;
  FirebaseAnalytics? _firebaseAnalytics;
  final bool enableInDebug;

  Future<void> init() async {
    if (!_isInitialized && _canLog) {
      _firebaseAnalytics = _firebaseAnalytics ?? FirebaseAnalytics.instance;

      await _firebaseAnalytics?.setAnalyticsCollectionEnabled(!kDebugMode || enableInDebug);

      _isInitialized = true;
    }
  }

  /// Set data to identify  analytics report
  Future<void> setAnalyticsIdentifier({required Map<String, dynamic> maps}) async {
    if (_firebaseAnalytics != null) {
      final futures = <Future<void>>[];
      for (final entry in maps.entries) {
        futures.add(
          _firebaseAnalytics!.setUserProperty(
            name: entry.key,
            value: entry.value,
          ),
        );
      }

      await Future.wait(futures);
    }
  }

  /// Log custom events for analytics
  ///
  /// [name] : Name of the event
  ///
  /// [eventParameters] : Any additional information about the event
  Future<void> logEvent(FireEvent event, {Map<String, dynamic>? eventParameters}) async {
    final name = event.name;
    assert(name.isNotEmpty, 'Name should not be empty');
    if (_isInitialized) {
      await _firebaseAnalytics?.logEvent(
        name: name,
        parameters: {if (eventParameters != null) ...eventParameters},
      );
    }
  }

  @visibleForTesting
  bool get isInitialized => _isInitialized;

  /// Returns true for the following platforms
  /// Android
  /// iOS
  /// Macos
  /// Web
  bool get _canLog =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}
