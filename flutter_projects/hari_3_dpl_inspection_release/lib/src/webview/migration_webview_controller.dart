import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'navigation_policy.dart';

WebViewController buildMigrationWebViewController({
  required ValueChanged<int> onProgress,
  required ValueChanged<String> onBlocked,
  required VoidCallback onMainFrameError,
}) {
  return WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..setBackgroundColor(const Color(0xfff7f8fb))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: onProgress,
        onNavigationRequest: (request) {
          if (TrainingNavigationPolicy.allows(request.url)) {
            return NavigationDecision.navigate;
          }
          onBlocked(request.url);
          return NavigationDecision.prevent;
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame != false) onMainFrameError();
        },
      ),
    )
    ..loadFlutterAsset('assets/migration_guide.html');
}
