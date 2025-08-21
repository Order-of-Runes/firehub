// Copyright (c) 2025 Ravikant Authors. All rights reserved.

import 'package:flutter/foundation.dart';

/// Denotes only the mobile target platform which is specific to Flutter Engine.
bool get isMobilePlatform => defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

/// Returns true when a native mobile app is used.
bool get isMobile {
  return !kIsWeb && isMobilePlatform;
}

/// Returns true when web is launched in mobile browser.
bool get isMobileWeb {
  return kIsWeb && isMobilePlatform;
}

/// Returns true when web is launched in devices other than mobile platform.
bool get isDesktopWeb {
  return kIsWeb && !isMobilePlatform;
}

bool get isWeb => kIsWeb;
