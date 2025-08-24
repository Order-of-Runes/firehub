import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show FlutterError, kDebugMode, kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_pulse/flutter_pulse.dart';

// Toggle firebase crashlyctics in debug mode
const bool enableFirebaseCrashlyticsInDebug = true;

class AnalyticsManager {
  final bool hasGms;
  bool _isInitialized = false;
  final bool _shouldEnableFirebaseCrashlyticsInDebug = enableFirebaseCrashlyticsInDebug;
  FirebaseCrashlytics? _firebaseCrashlytics;
  FirebaseAnalytics? _firebaseAnalytics;

  AnalyticsManager({this.hasGms = true});

  Future<void> init() async {
    if (!_isInitialized) {
      if (hasGms) {
        _firebaseAnalytics = _firebaseAnalytics ?? FirebaseAnalytics.instance;

        if (isMobile) {
          _firebaseCrashlytics = _firebaseCrashlytics ?? FirebaseCrashlytics.instance;
          await _firebaseCrashlytics?.setCrashlyticsCollectionEnabled(!kDebugMode || _shouldEnableFirebaseCrashlyticsInDebug);
          await _firebaseAnalytics?.setAnalyticsCollectionEnabled(!kDebugMode || _shouldEnableFirebaseCrashlyticsInDebug);

          // Pass all uncaught errors from the framework to Crashlytics
          FlutterError.onError = (err) {
            if (err.library != 'SVG') {
              _firebaseCrashlytics?.recordFlutterError(err);
            }
          };
        }
      }
    }
    _isInitialized = true;
  }

  /// Set data to identify  analytics report
  Future<void> setAnalyticsIdentifier({required Map<String, dynamic> maps}) async {
    for (final entry in maps.entries) {
      await _firebaseAnalytics!.setUserProperty(name: entry.key, value: entry.value);
    }
  }

  /*------------------------------ Crashlytics ------------------------------*/

  /// Crash the app
  void crashApp() {
    if (kDebugMode && hasGms) {
      _firebaseCrashlytics?.crash();
    }
  }

  /// Log custom crashes/exceptions not caught by crashlytics automatically. For eg. exceptions
  ///
  /// Firebase :
  ///   8 recent logs are sent to the server
  ///   App restart is required to sync the log in the console
  ///   Rest of logs are discarded
  Future<void> recordError(dynamic message, {StackTrace? stackTrace, bool fatal = false, dynamic reason}) async {
    if (hasGms) await _firebaseCrashlytics?.recordError(message, stackTrace, printDetails: false, fatal: fatal, reason: reason);
  }

  /*------------------------------ Analytics ------------------------------*/

  /// Log custom events for analytics
  ///
  /// [name] : Name of the event
  ///
  /// [eventParameters] : Any additional information about the event
  Future<void> logEvent({required String name, Map<String, dynamic>? eventParameters}) async {
    assert(name.isNotEmpty, 'Name should not be empty');
    if (hasGms) {
      await _firebaseAnalytics?.logEvent(name: name, parameters: {if (eventParameters != null) ...eventParameters!});
    }
  }
}
/// Returns true if the app is running on a mobile device (Android or iOS).
bool get isMobile =>
    !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);