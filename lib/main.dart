import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:ispeedpix2pdf7/firebase_service';
import 'package:ispeedpix2pdf7/helper/analytics_service.dart';
import 'package:ispeedpix2pdf7/helper/constants.dart';
import 'package:ispeedpix2pdf7/helper/language_service.dart';
import 'package:ispeedpix2pdf7/helper/shared_preference_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';

// Global variable to track if Firebase is initialized
bool _isFirebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    } else {
      print('Firebase was already initialized');
    }

    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    // Enable analytics collection
    await analytics.setAnalyticsCollectionEnabled(true);

    // Enable debug mode specifically for Android
    if (Platform.isAndroid) {
      // Set debug mode for Android
      await analytics.setAnalyticsCollectionEnabled(true);
      print('Android analytics debug mode enabled');

      // Log a test event for Android
      await analytics.logEvent(
        name: 'android_test_event',
        parameters: {
          'platform': 'android',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('Android test event logged');
    }

    await analytics.logAppOpen();
    print('Logged app_open event');
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }

  GoRouter.optionURLReflectsImperativeAPIs = true;

  usePathUrlStrategy();

  await Purchases.configure(PurchasesConfiguration(
      (Platform.isAndroid) ? revenueCatAndroidKey : revenueCatKey));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    _initializeLocale();

    // Listen for language changes
    LanguageService.localeNotifier.addListener(() {
      safeSetState(() {
        _locale = LanguageService.localeNotifier.value;
      });
    });

    SharedPreferenceService().checkAndSaveDate();
    checkAndRestorePurchases();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    Future.delayed(const Duration(milliseconds: 1000),
        () => safeSetState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  @override
  void dispose() {
    // Clean up the listener
    LanguageService.localeNotifier.removeListener(() {});
    super.dispose();
  }

  Future<void> _initializeLocale() async {
    final locale = await LanguageService.getLocale();
    safeSetState(() {
      _locale = locale;
    });
  }

  void setLocale(Locale locale) {
    safeSetState(() {
      _locale = locale;
    });
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'iSpeedPix2PDF',
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
        Locale('zh', ''), // Simplified Chinese
        Locale('fr', ''), // French
        Locale('de', ''), // German
        Locale('pt', ''), // Portuguese
        Locale('ar', ''), // Arabic
        Locale('hi', ''), // Hindi
        Locale('ja', ''), // Japanese
        Locale('ko', ''), // Korean
        Locale('ru', ''), // Russian
        Locale('it', ''), // Italian
        Locale('tr', ''), // Turkish
        Locale('vi', ''), // Vietnamese
        Locale('th', ''), // Thai
        Locale('he', ''), // Hebrew
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      builder: (context, child) {
        // Get the current locale
        final locale = Localizations.localeOf(context);
        final isRtl = locale.languageCode == 'ar' ||
            locale.languageCode == 'hi' ||
            locale.languageCode == 'he';

        // Apply the correct text direction based on language
        return Directionality(
          // key: UniqueKey(), // Add a unique key
          textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: child!,
        );
      },
    );
  }

  Future<void> checkAndRestorePurchases() async {
    await Purchases.setDebugLogsEnabled(true);

    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();

      // ... check restored purchaserInfo to see if entitlement is now active
    } on PlatformException catch (e) {
      // Error restoring purchases
    }
  }
}
