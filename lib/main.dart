import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:ispeedpix2pdf7/helper/constants.dart';
import 'package:ispeedpix2pdf7/helper/shared_preference_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  usePathUrlStrategy();

  await Purchases.configure(PurchasesConfiguration(
      (Platform.isAndroid) ? revenueCatAndroidKey : revenueCatKey
  ));

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

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    SharedPreferenceService().checkAndSaveDate();

    checkAndRestorePurchases();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    Future.delayed(const Duration(milliseconds: 1000),
        () => safeSetState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'iSpeedPix2PDF',
      // localizationsDelegates: const [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', ''), // English
      //   Locale('es', ''), // Spanish
      //   Locale('zh', ''), // Simplified Chinese
      //   Locale('fr', ''), // French
      //   Locale('de', ''), // German
      //   Locale('pt', ''), // Portuguese
      //   Locale('ar', ''), // Arabic
      //   Locale('hi', ''), // Hindi
      //   Locale('ja', ''), // Japanese
      //   Locale('ko', ''), // Korean
      //   Locale('ru', ''), // Russian
      //   Locale('it', ''), // Italian
      //   Locale('tr', ''), // Turkish
      //   Locale('vi', ''), // Vietnamese
      //   Locale('th', ''), // Thai
      // ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
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
