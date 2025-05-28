import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Initialize analytics
  static Future<void> initialize() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
    print('Analytics service initialized');
  }

  // Log a button tap event
  static Future<void> logButtonTap(String buttonName,
      {Map<String, dynamic>? additionalParams}) async {
    try {
      final Map<String, dynamic> parameters = {
        // 'button_name': buttonName,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Add any additional parameters
      if (additionalParams != null) {
        additionalParams.forEach((key, value) {
          if (value is String || value is num) {
            parameters[key] = value;
          } else if (value is bool) {
            parameters[key] = value.toString();
          } else if (value != null) {
            parameters[key] = value.toString();
          }
        });
      }

      await _analytics.logEvent(
        name: buttonName,
        parameters: parameters,
      );

      print('Logged button tap: $buttonName');
    } catch (e) {
      print('Failed to log button tap: $e');
    }
  }

  // Log a custom event
  static Future<void> logEvent(
      String name, Map<String, dynamic> parameters) async {
    try {
      // Convert parameters to acceptable types
      final Map<String, dynamic> sanitizedParams = {};

      parameters.forEach((key, value) {
        if (value is String || value is num) {
          sanitizedParams[key] = value;
        } else if (value is bool) {
          sanitizedParams[key] = value.toString();
        } else if (value != null) {
          sanitizedParams[key] = value.toString();
        }
      });

      await _analytics.logEvent(name: name, parameters: sanitizedParams);
      print('Analytics event logged: $name with parameters: $sanitizedParams');
    } catch (e) {
      print('Failed to log analytics event: $e');
    }
  }
}
