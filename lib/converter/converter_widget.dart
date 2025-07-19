import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ispeedpix2pdf7/helper/analytics_service.dart';
import 'package:ispeedpix2pdf7/helper/shared_preference_service.dart';
import 'package:ispeedpix2pdf7/screens/preview_pdf_screen.dart';
import 'package:ispeedpix2pdf7/widgets/language_selection_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:http/http.dart' as http;

import '../custom_code/actions/pdf_multi_img.dart';
import '../helper/log_helper.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'converter_model.dart';
export 'converter_model.dart';
import 'package:ispeedpix2pdf7/app_globals.dart';

class ConstValues {
  static int previousSelectedIndex = 0;
}

class ConverterWidget extends StatefulWidget {
  const ConverterWidget({super.key});

  @override
  State<ConverterWidget> createState() => _ConverterWidgetState();
}

bool _hasShownSubscriptionDialogThisSession = false;

class _ConverterWidgetState extends State<ConverterWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late ConverterModel _model;

  late SharedPreferenceService preferenceService;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Offerings? offerings;
  //TODO: FOR TESTING - Set to false to test trial expiration and 3-minute usage limits
  //TODO: Change back to true for production or when subscription logic is working
  bool _isSubscribed = false;
  bool _is7DaysPassed = false;
  CustomerInfo? _customerInfo;

  bool _isFocused = false;
  bool _hasBackSlash = false;

  final animationsMap = <String, AnimationInfo>{};

  AppLocalizations? l10n;
  List<SelectedFile>? selectedMedia;
  var hideCurrentDropdown = false;

  Timer? _usageTimer;
  int _usageSeconds = 0;
  bool _isTimerActive = false;
  DateTime? _lastActiveTime;

  // Usage time display variables
  Timer? _usageDisplayTimer;
  int _remainingUsageTime = 180; // Default 3 minutes = 180 seconds
  int _trialDaysRemaining = 3; // Trial days remaining
  bool _showUsageTime = false;
  bool _hasShownWarningDialog = false; // Track if warning dialog has been shown
  bool _hasShownDay2Dialog = false; // Track if Day 2 dialog has been shown

  // Add this property to track if we've shown the dialog this session

  @override
  void initState() {
    super.initState();

    // Register the observer
    WidgetsBinding.instance.addObserver(this);

    preferenceService = SharedPreferenceService();

    // Set trial end date if this is the first time
    preferenceService.setTrialEndDate();

    // Check if this is the first time the app is opened
    _checkFirstTimeAppOpen();

    // Reset the dialog shown flag at the start of each session
    _hasShownSubscriptionDialogThisSession = false;

    _model = createModel(context, () => ConverterModel());

    _model.filenameTextController = TextEditingController();

    _model.filenameFocusNode = FocusNode();

    _model.filenameFocusNode!.addListener(() {
      if (_isFocused && selectedMedia != null) {
        LoadingDialog.show(context, message: l10n!.creatingPdf);

        createPDF();
      }
      setState(() {
        _isFocused = _model.filenameFocusNode!.hasFocus;
      });
    });

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(3.0, 3.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });

    checkSubscriptionStatus();
    _setInstallationDateAndCheckDialogs();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      l10n = AppLocalizations.of(context);

      generateOrientationOptions();

      // Start usage time display for all users (for now)
      _startUsageTimeDisplay();

      // If selected orientation is empty or doesn't exist in the current options list, reset it
      if (_selectedOrientation.isEmpty) {
        _selectedOrientation = _orientationOptions[0];
        // setState(() {});
      }

      safeSetState(() {});

      // Ensure that no text field is focused when the app starts
      FocusScope.of(context).requestFocus(FocusNode());
    });

    initRateMyApp();
  }

  // Add this method to check and handle first-time app open
  Future<void> _checkFirstTimeAppOpen() async {
    bool isFirstTimeAppOpened = await preferenceService.isFirstTimeAppOpened();

    if (isFirstTimeAppOpened) {
      // Log first-time open event
      try {
        await analytics.logEvent(
          name: 'event_on_first_open',
          parameters: {
            'timestamp': DateTime.now().toIso8601String(),
            'os': Platform.isAndroid ? 'android' : 'ios',
          },
        );
        print('✅ Logged first-time app open event');
      } catch (e) {
        print('❌ Failed to log first-time app open event: $e');
      }

      // Set the flag to false for future app opens
      await preferenceService.setFirstTimeAppOpened(false);
    }
  }

  // Method to set installation date and check for day-based dialogs
  Future<void> _setInstallationDateAndCheckDialogs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Set installation date if not already set
      if (!prefs.containsKey('installation_date')) {
        String installationDate = DateTime.now().toIso8601String();
        await prefs.setString('installation_date', installationDate);
        print('📅 Installation date set: $installationDate');
      }

      // Check if user is subscribed
      if (_isSubscribed) {
        print('✅ User is subscribed, skipping day-based dialogs');
        return;
      }

      // Check if 3-day trial has ended
      bool trialEnded = await preferenceService.hasTrialEnded();
      if (trialEnded) {
        print('⏰ 3-day trial has ended, skipping day-based dialogs');
        return;
      }

      // Get installation date and calculate days
      String? installationDateStr = prefs.getString('installation_date');
      if (installationDateStr != null) {
        DateTime installationDate = DateTime.parse(installationDateStr);
        int daysSinceInstallation =
            DateTime.now().difference(installationDate).inDays;

        print('📊 Days since installation: $daysSinceInstallation');

        // Check for Day 2 dialog
        bool hasShownDay2 = prefs.getBool('has_shown_day2_dialog') ?? false;
        if (daysSinceInstallation >= 2 &&
            !hasShownDay2 &&
            !_hasShownDay2Dialog) {
          // Check if we can show the dialog today (once per day limit)
          bool canShowToday = await preferenceService.canShowDay2DialogToday();

          if (canShowToday) {
            _hasShownDay2Dialog = true;
            await prefs.setBool('has_shown_day2_dialog', true);

            // Mark dialog as shown today
            await preferenceService.markDay2DialogShownToday();

            Future.delayed(Duration(seconds: 2), () {
              if (mounted && !_isSubscribed) {
                showDay2Dialog(context);
              }
            });
          } else {
            print('📅 Day 2 dialog already shown today, skipping');
          }
        }
      }
    } catch (e) {
      print('❌ Error in _setInstallationDateAndCheckDialogs: $e');
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _usageTimer?.cancel();
    _usageDisplayTimer?.cancel();
    _pauseUsageTracking();

    // Remove the observer when disposing
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  String _selectedOrientation = ''; // Default selection

  // List of options for the dropdown
  List<String> _orientationOptions = [];

  generateOrientationOptions() {
    _orientationOptions = [
      l10n!.defaultMixedOrientation,
      l10n!.pagesFixedPortrait,
      l10n!.landscapePhotosTopAlignedForEasyViewing,
    ];
  }

  // Usage time display methods
  void _startUsageTimeDisplay() {
    print('🟢 Starting usage time display...');

    // Check if display timer is already running
    if (_usageDisplayTimer != null && _usageDisplayTimer!.isActive) {
      print('⚠️ Usage display timer already running, skipping start');
      return;
    }

    _showUsageTime = true;
    _updateRemainingUsageTime();

    // Update every second for smooth progress
    _usageDisplayTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _updateRemainingUsageTime();
    });
  }

  void _stopUsageTimeDisplay() {
    print('🔴 Stopping usage time display...');
    _usageDisplayTimer?.cancel();
    _usageDisplayTimer = null;
    _showUsageTime = false;
    setState(() {});
  }

  // Method to safely stop usage time display only for subscribed users
  void _stopUsageTimeDisplayIfSubscribed() {
    if (_isSubscribed) {
      print('🔴 Stopping usage time display for subscribed user...');
      _stopUsageTimeDisplay();
    } else {
      print('⚠️ Keeping usage time display running for non-subscribed user');
    }
  }

  Future<void> _updateRemainingUsageTime() async {
    try {
      print(
          '🔄 _updateRemainingUsageTime called - current _usageSeconds: $_usageSeconds');
      int remainingTime;
      int trialDays = 0;

      // Calculate trial days remaining
      bool trialEnded = await preferenceService.hasTrialEnded();
      if (!trialEnded) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? trialEndDateStr = prefs.getString('trial_end_date');
        if (trialEndDateStr != null) {
          DateTime trialEndDate = DateTime.parse(trialEndDateStr);
          DateTime now = DateTime.now();
          trialDays = trialEndDate.difference(now).inDays;
          if (trialDays < 0) trialDays = 0;
        }
      }

      if (_isSubscribed) {
        // Subscribed users always have full time available
        remainingTime = 180; // 3 minutes
        print('📊 User is subscribed, setting time to 180 seconds');
      } else {
        // Check if 3-day trial is still active
        if (!trialEnded) {
          // During trial period, always show full time
          remainingTime = 180; // 3 minutes
          print('🎁 3-day trial active, setting time to 180 seconds');
        } else {
          // Check if usage is paused
          bool isPaused = await preferenceService.isUsagePaused();
          if (isPaused) {
            remainingTime = 0;
            int remainingDays = await preferenceService.getRemainingPauseDays();
            print('⏸️ Usage paused, $remainingDays days remaining in pause');
          } else {
            // Non-subscribed users after trial: calculate remaining time based on current session usage
            int baseRemainingTime =
                await preferenceService.getRemainingUsageTime();

            // Subtract current session usage from the base remaining time
            remainingTime = baseRemainingTime - _usageSeconds;
            if (remainingTime < 0) remainingTime = 0;

            // Store the calculated remaining time in preferences
            await preferenceService.setRemainingTime(remainingTime);

            print(
                '📊 Non-subscribed user (trial ended): base=$baseRemainingTime, session=$_usageSeconds, remaining=$remainingTime');
          }
        }

        // Check if user is in the 80-90% usage range (18-36 seconds remaining)
        if (!_hasShownWarningDialog &&
            remainingTime > 0 &&
            remainingTime <= 36 &&
            remainingTime >= 18) {
          _hasShownWarningDialog = true;
          print('⚠️ Showing warning dialog (80-90% usage)');
          // Show warning dialog after a short delay
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              showUsageWarningDialog(context);
            }
          });
        }
      }

      print(
          '🔄 Updating UI: $_remainingUsageTime -> $remainingTime seconds, trial days: $trialDays');
      if (mounted) {
        setState(() {
          _remainingUsageTime = remainingTime;
          _trialDaysRemaining = trialDays;
        });
      }
      print(
          '⏱️ UI Updated - Remaining usage time: $_remainingUsageTime seconds, trial days: $_trialDaysRemaining (subscribed: $_isSubscribed)');
    } catch (e) {
      print('❌ Error fetching remaining usage time: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF173F5A),
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 10.0, 0.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.refresh,
                          // Flutter's default refresh icon
                          color: Colors.white,
                          // Match icon color with text
                          size: 24.0, // Adjust size to fit the text
                        ),
                        const SizedBox(width: 5.0),
                        // Add spacing between icon and text
                        Text(
                          l10n!.reset,
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .displayMedium
                              .override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation']!),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () async {
                _model = createModel(context, () => ConverterModel());

                _model.clearAllValues();

                _model.filenameTextController = TextEditingController();

                // _selectedOrientation = 'DEFAULT - Mixed Orientation';
                _selectedOrientation = l10n!.defaultMixedOrientation;

                _model.filenameTextController = TextEditingController();

                selectedMedia = null;

                _model.filenameDefault = '';

                // Stop the usage time display when resetting
                _stopUsageTimeDisplay();

                safeSetState(() {});

                setState(() {});
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 120.0,
                        height: 120.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/70769789-ECA9-4E75-AE97-86FF559889DF.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            3.0, 0.0, 0.0, 0.0),
                        child: Text(
                          l10n!.appTitle
                          // 'iSpeedPix2PDF'
                          ,
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .displayMedium
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation']!),
                      ),
                      // Usage time indicator
                      if (!_isSubscribed) // Always show for non-subscribed users
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              2.0, 10.0, 2.0, 10.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                // Title for subscription status
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      l10n!.trialTimeLeft,
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.0),
                                // Enhanced Time Remaining Widget with Different States
                                FutureBuilder<bool>(
                                  future: preferenceService.hasTrialEnded(),
                                  builder: (context, trialSnapshot) {
                                    bool trialEnded =
                                        trialSnapshot.data ?? false;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Trial Time Left or Usage Time Header
                                        if (!trialEnded && !_isSubscribed) ...[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 16,
                                                color: Color(0xFF173F5A),
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                l10n!.trialTimeLeft,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color:
                                                              Color(0xFF173F5A),
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '${_trialDaysRemaining} ${_trialDaysRemaining == 1 ? l10n!.day : l10n!.days} ${l10n!.left}',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color:
                                                              _trialDaysRemaining <=
                                                                      1
                                                                  ? Colors.red
                                                                  : Color(
                                                                      0xFF173F5A),
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                        ],

                                        // Progress Bar and Time Display
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: TweenAnimationBuilder<
                                                    double>(
                                                  duration: Duration(
                                                      milliseconds:
                                                          300), // Faster animation for smoother updates
                                                  curve: Curves.easeOut,
                                                  tween: Tween<double>(
                                                    begin: _remainingUsageTime /
                                                        180.0, // Start from current value
                                                    end: _remainingUsageTime /
                                                        180.0,
                                                  ),
                                                  builder:
                                                      (context, value, child) {
                                                    return LinearProgressIndicator(
                                                      value:
                                                          value, // Animated value
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        _remainingUsageTime < 50
                                                            ? Colors.red
                                                            : (_remainingUsageTime <
                                                                    90
                                                                ? Colors.orange
                                                                : Color(
                                                                    0xFF173F5A)),
                                                      ),
                                                      minHeight: 12.0,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  l10n!.remainingTime(
                                                      (_remainingUsageTime ~/
                                                          60),
                                                      (_remainingUsageTime % 60)
                                                          .toString()
                                                          .padLeft(2, '0')),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            _remainingUsageTime <
                                                                    50
                                                                ? Colors.red
                                                                : Colors
                                                                    .black87,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            _remainingUsageTime <
                                                                    50
                                                                ? FontWeight
                                                                    .w700
                                                                : FontWeight
                                                                    .w500,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                                if (_remainingUsageTime <
                                                    50) ...[
                                                  Text(
                                                    l10n!.sessionTime,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: Colors.red,
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 12.0),
                                // Trial motivation message for non-subscribed users within 7-day trial
                                if (!_isSubscribed) ...[
                                  FutureBuilder<bool>(
                                    future: preferenceService.hasTrialEnded(),
                                    builder: (context, trialSnapshot) {
                                      bool trialEnded =
                                          trialSnapshot.data ?? false;

                                      // Show message only if trial hasn't ended and remaining time > 50 seconds
                                      if (!trialEnded &&
                                          _remainingUsageTime >= 50) {
                                        return Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF173F5A)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Color(0xFF173F5A)
                                                  .withOpacity(0.3),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n!
                                                    .unlockUnlimitedAccessToday,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displayMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              Color(0xFF173F5A),
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                l10n!
                                                    .enjoyingFreeTrialUpgradeMessage,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.black,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return SizedBox
                                          .shrink(); // Return empty widget if conditions not met
                                    },
                                  ),
                                  SizedBox(height: 12.0),
                                ],
                                // Warning text when remaining time is less than 50 seconds (including 0) and trial has ended
                                FutureBuilder<bool>(
                                  future: preferenceService.hasTrialEnded(),
                                  builder: (context, trialSnapshot) {
                                    bool trialEnded =
                                        trialSnapshot.data ?? false;

                                    // Show warning only if trial has ended and remaining time < 50
                                    if (trialEnded &&
                                        _remainingUsageTime < 50) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color:
                                                    Colors.red.withOpacity(0.3),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder<bool>(
                                                  future: preferenceService
                                                      .isUsagePaused(),
                                                  builder:
                                                      (context, pauseSnapshot) {
                                                    bool isPaused =
                                                        pauseSnapshot.data ??
                                                            false;

                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FutureBuilder<bool>(
                                                          future: preferenceService
                                                              .isRemainingTimeExpired(),
                                                          builder: (context,
                                                              expiredSnapshot) {
                                                            bool isExpired =
                                                                expiredSnapshot
                                                                        .data ??
                                                                    false;

                                                            String titleText;
                                                            if (isPaused) {
                                                              titleText = l10n!
                                                                  .usagePausedThirtyDays;
                                                            } else if (isExpired ||
                                                                _remainingUsageTime <=
                                                                    0) {
                                                              titleText = l10n!
                                                                  .freeTimeExpired;
                                                            } else if (_remainingUsageTime <
                                                                90) {
                                                              // Use Day 2/4 dialog messages for yellow/orange state
                                                              titleText = l10n!
                                                                  .likingTheApp;
                                                            } else {
                                                              titleText = l10n!
                                                                  .almostOutOfFreeTime;
                                                            }

                                                            return Text(
                                                              titleText,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .displayMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        if (isPaused) ...[
                                                          FutureBuilder<int>(
                                                            future: preferenceService
                                                                .getRemainingPauseDays(),
                                                            builder: (context,
                                                                daysSnapshot) {
                                                              int remainingDays =
                                                                  daysSnapshot
                                                                          .data ??
                                                                      0;
                                                              return Text(
                                                                l10n!.usagePausedMessage(
                                                                    remainingDays),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              );
                                                            },
                                                          ),
                                                        ] else ...[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        18.0),
                                                            child:
                                                                FutureBuilder<
                                                                    bool>(
                                                              future: preferenceService
                                                                  .isRemainingTimeExpired(),
                                                              builder: (context,
                                                                  expiredSnapshot) {
                                                                bool isExpired =
                                                                    expiredSnapshot
                                                                            .data ??
                                                                        false;

                                                                String
                                                                    messageText;
                                                                if (isExpired ||
                                                                    _remainingUsageTime <=
                                                                        0) {
                                                                  messageText =
                                                                      l10n!
                                                                          .freeTimeExpiredMessage;
                                                                } else if (_remainingUsageTime <
                                                                    90) {
                                                                  // Use Day 2/4 dialog messages for yellow/orange state
                                                                  messageText =
                                                                      l10n!
                                                                          .likingTheAppMessage;
                                                                } else {
                                                                  messageText =
                                                                      l10n!
                                                                          .almostOutOfFreeTimeMessage;
                                                                }

                                                                return Text(
                                                                  messageText,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return SizedBox
                                        .shrink(); // Return empty widget if trial active or time >= 50
                                  },
                                ),
                                SizedBox(height: 12.0),
                                // Subscribe Now button
                                SizedBox(
                                  width: double.infinity,
                                  height: 36.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigate to subscription page
                                      context.pushNamed('Subscription');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF173F5A),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      l10n!.subscribeNow,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ),

                                // Debug buttons moved outside conditional block

                                // SizedBox(height: 6.0),
                                // // TODO: FOR TESTING - Button to simulate 0 seconds (expired)
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       try {
                                //         // Set usage time to 180 seconds (leaving 0 seconds)
                                //         SharedPreferences prefs =
                                //             await SharedPreferences
                                //                 .getInstance();
                                //         await prefs.setInt('usage_time', 180);
                                //         await prefs.setInt('usage_month',
                                //             DateTime.now().month);

                                //         // Set stored remaining time to 0 seconds
                                //         await preferenceService
                                //             .setRemainingTime(0);

                                //         // Reset session counter
                                //         _usageSeconds = 0;

                                //         // Update UI
                                //         await _updateRemainingUsageTime();

                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(
                                //           SnackBar(
                                //             content: Text(
                                //                 'Set to 0 seconds remaining (expired test)'),
                                //             duration: Duration(seconds: 2),
                                //           ),
                                //         );
                                //       } catch (e) {
                                //         print(
                                //             '❌ Error setting expired time: $e');
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.red,
                                //       foregroundColor: Colors.white,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(6.0),
                                //       ),
                                //       elevation: 0,
                                //     ),
                                //     child: Text(
                                //       'Set 0s Remaining (Expired)',
                                //       style: FlutterFlowTheme.of(context)
                                //           .bodyMedium
                                //           .override(
                                //             fontFamily: 'Inter',
                                //             color: Colors.white,
                                //             fontSize: 12.0,
                                //             letterSpacing: 0.0,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // // TODO: FOR TESTING - Button to reset 30-day pause
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       try {
                                //         // Reset the 30-day pause
                                //         await preferenceService.resetPause();

                                //         // Reset session variables
                                //         _usageSeconds = 0;
                                //         _hasShownSubscriptionDialogThisSession =
                                //             false;

                                //         // Update UI
                                //         await _updateRemainingUsageTime();

                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(
                                //           SnackBar(
                                //             content: Text(
                                //                 '30-day pause reset, usage time restored'),
                                //             duration: Duration(seconds: 2),
                                //           ),
                                //         );
                                //       } catch (e) {
                                //         print('❌ Error resetting pause: $e');
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.purple,
                                //       foregroundColor: Colors.white,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(6.0),
                                //       ),
                                //       elevation: 0,
                                //     ),
                                //     child: Text(
                                //       'Reset 30-Day Pause',
                                //       style: FlutterFlowTheme.of(context)
                                //           .bodyMedium
                                //           .override(
                                //             fontFamily: 'Inter',
                                //             color: Colors.white,
                                //             fontSize: 12.0,
                                //             letterSpacing: 0.0,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // // TODO: FOR TESTING - Button to manually expire trial
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       try {
                                //         // Set trial to expired (yesterday)
                                //         SharedPreferences prefs =
                                //             await SharedPreferences
                                //                 .getInstance();
                                //         DateTime yesterday = DateTime.now()
                                //             .subtract(Duration(days: 1));
                                //         await prefs.setString('trial_end_date',
                                //             yesterday.toIso8601String());

                                //         // Reset usage time and remaining time
                                //         await preferenceService
                                //             .resetUsageTime();
                                //         await preferenceService
                                //             .setRemainingTime(180);
                                //         _usageSeconds = 0;

                                //         // Update UI
                                //         await _updateRemainingUsageTime();

                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(
                                //           SnackBar(
                                //             content: Text(
                                //                 'Trial expired, 3-min timer will start'),
                                //             duration: Duration(seconds: 2),
                                //           ),
                                //         );
                                //       } catch (e) {
                                //         print('❌ Error expiring trial: $e');
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.deepOrange,
                                //       foregroundColor: Colors.white,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(6.0),
                                //       ),
                                //       elevation: 0,
                                //     ),
                                //     child: Text(
                                //       'Expire Trial (Start Timer)',
                                //       style: FlutterFlowTheme.of(context)
                                //           .bodyMedium
                                //           .override(
                                //             fontFamily: 'Inter',
                                //             color: Colors.white,
                                //             fontSize: 12.0,
                                //             letterSpacing: 0.0,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // // TODO: FOR TESTING - Button to reset trial (set to active)
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       try {
                                //         // Reset trial to active (7 days from now)
                                //         SharedPreferences prefs =
                                //             await SharedPreferences
                                //                 .getInstance();
                                //         DateTime now = DateTime.now();
                                //         DateTime trialEndDate =
                                //             now.add(Duration(days: 7));
                                //         await prefs.setString('trial_end_date',
                                //             trialEndDate.toIso8601String());

                                //         // Reset usage time and remaining time
                                //         await preferenceService
                                //             .resetUsageTime();
                                //         await preferenceService
                                //             .setRemainingTime(180);
                                //         _usageSeconds = 0;

                                //         // Update UI
                                //         await _updateRemainingUsageTime();

                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(
                                //           SnackBar(
                                //             content: Text(
                                //                 'Trial reset to 7 days active'),
                                //             duration: Duration(seconds: 2),
                                //           ),
                                //         );
                                //       } catch (e) {
                                //         print('❌ Error resetting trial: $e');
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.blue,
                                //       foregroundColor: Colors.white,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(6.0),
                                //       ),
                                //       elevation: 0,
                                //     ),
                                //     child: Text(
                                //       'Reset Trial (7 Days)',
                                //       style: FlutterFlowTheme.of(context)
                                //           .bodyMedium
                                //           .override(
                                //             fontFamily: 'Inter',
                                //             color: Colors.white,
                                //             fontSize: 12.0,
                                //             letterSpacing: 0.0,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // // TODO: FOR TESTING - Button to reset trial limit dialog date
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       try {
                                //         // Reset the trial limit dialog date
                                //         SharedPreferences prefs =
                                //             await SharedPreferences
                                //                 .getInstance();
                                //         await prefs.remove(
                                //             'last_trial_limit_dialog_date');

                                //         // Reset session flag
                                //         _hasShownSubscriptionDialogThisSession =
                                //             false;

                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(
                                //           SnackBar(
                                //             content: Text(
                                //                 'Trial limit dialog date reset'),
                                //             duration: Duration(seconds: 2),
                                //           ),
                                //         );
                                //       } catch (e) {
                                //         print(
                                //             '❌ Error resetting dialog date: $e');
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.indigo,
                                //       foregroundColor: Colors.white,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(6.0),
                                //       ),
                                //       elevation: 0,
                                //     ),
                                //     child: Text(
                                //       'Reset Dialog Date',
                                //       style: FlutterFlowTheme.of(context)
                                //           .bodyMedium
                                //           .override(
                                //             fontFamily: 'Inter',
                                //             color: Colors.white,
                                //             fontSize: 12.0,
                                //             letterSpacing: 0.0,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //     ),
                                //   ),
                                // ),
                                // TODO: FOR TESTING - Set Subscription False button

                                // TODO: FOR TESTING - Dialog Testing Buttons
                                // SizedBox(height: 6.0),
                                // // Debug Status Display
                                // Container(
                                //   padding: EdgeInsets.all(8.0),
                                //   decoration: BoxDecoration(
                                //     color: Colors.grey[100],
                                //     borderRadius: BorderRadius.circular(6.0),
                                //     border:
                                //         Border.all(color: Colors.grey[300]!),
                                //   ),
                                //   child: Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         'DEBUG STATUS:',
                                //         style: TextStyle(
                                //           fontSize: 10,
                                //           fontWeight: FontWeight.bold,
                                //           color: Colors.grey[600],
                                //         ),
                                //       ),
                                //       SizedBox(height: 4),
                                //       FutureBuilder<bool>(
                                //         future:
                                //             preferenceService.hasTrialEnded(),
                                //         builder: (context, snapshot) {
                                //           bool trialEnded =
                                //               snapshot.data ?? false;
                                //           return Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               Text(
                                //                 'Subscribed: $_isSubscribed',
                                //                 style: TextStyle(
                                //                     fontSize: 10,
                                //                     color: Colors.grey[700]),
                                //               ),
                                //               Text(
                                //                 'Trial Ended: $trialEnded',
                                //                 style: TextStyle(
                                //                     fontSize: 10,
                                //                     color: Colors.grey[700]),
                                //               ),
                                //               Text(
                                //                 'Remaining Time: $_remainingUsageTime s',
                                //                 style: TextStyle(
                                //                     fontSize: 10,
                                //                     color: Colors.grey[700]),
                                //               ),
                                //               Text(
                                //                 'Usage Timer: ${_usageTimer?.isActive ?? false ? "ACTIVE" : "INACTIVE"}',
                                //                 style: TextStyle(
                                //                     fontSize: 10,
                                //                     color: Colors.grey[700]),
                                //               ),
                                //               Text(
                                //                 'Display Timer: ${_usageDisplayTimer?.isActive ?? false ? "ACTIVE" : "INACTIVE"}',
                                //                 style: TextStyle(
                                //                     fontSize: 10,
                                //                     color: Colors.grey[700]),
                                //               ),
                                //             ],
                                //           );
                                //         },
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () {
                                //       showDay2Dialog(context);
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.blue,
                                //       foregroundColor: Colors.white,
                                //     ),
                                //     child: Text(
                                //       'Test Day 2 Dialog',
                                //       style: TextStyle(fontSize: 12),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () {
                                //       showDay4Dialog(context);
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.blue,
                                //       foregroundColor: Colors.white,
                                //     ),
                                //     child: Text(
                                //       'Test Day 4 Dialog',
                                //       style: TextStyle(fontSize: 12),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () {
                                //       showUsageWarningDialog(context);
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.orange,
                                //       foregroundColor: Colors.white,
                                //     ),
                                //     child: Text(
                                //       'Test Usage Warning Dialog',
                                //       style: TextStyle(fontSize: 12),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () {
                                //       showUsageLimitDialog(context);
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.red,
                                //       foregroundColor: Colors.white,
                                //     ),
                                //     child: Text(
                                //       'Test Usage Limit Dialog',
                                //       style: TextStyle(fontSize: 12),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 6.0),
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: 32.0,
                                //   child: ElevatedButton(
                                //     onPressed: () {
                                //       showTrialLimitDialog(context);
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.purple,
                                //       foregroundColor: Colors.white,
                                //     ),
                                //     child: Text(
                                //       'Test Trial Limit Dialog',
                                //       style: TextStyle(fontSize: 12),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),

                      // // ===== DEBUG BUTTONS SECTION (Always Visible) =====
                      // Padding(
                      //   padding: const EdgeInsetsDirectional.fromSTEB(
                      //       16.0, 8.0, 16.0, 8.0),
                      //   child: Column(
                      //     children: [
                      //       // Debug header
                      //       Container(
                      //         width: double.infinity,
                      //         padding: EdgeInsets.all(8.0),
                      //         decoration: BoxDecoration(
                      //           color: Colors.grey[200],
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           border: Border.all(color: Colors.grey[400]!),
                      //         ),
                      //         child: Text(
                      //           '🧪 DEBUG CONTROLS (Testing Only)',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.grey[700],
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 8.0),

                      //       // Set Subscription False button
                      //       SizedBox(
                      //         width: double.infinity,
                      //         height: 32.0,
                      //         child: ElevatedButton(
                      //           onPressed: () async {
                      //             try {
                      //               setState(() {
                      //                 _isSubscribed = false;
                      //               });

                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content:
                      //                       Text('Subscription set to false'),
                      //                   duration: Duration(seconds: 2),
                      //                 ),
                      //               );
                      //             } catch (e) {
                      //               print(
                      //                   '❌ Error setting subscription false: $e');
                      //             }
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.red,
                      //             foregroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(6.0),
                      //             ),
                      //             elevation: 0,
                      //           ),
                      //           child: Text(
                      //             'Set Subscription False',
                      //             style: FlutterFlowTheme.of(context)
                      //                 .bodyMedium
                      //                 .override(
                      //                   fontFamily: 'Inter',
                      //                   color: Colors.white,
                      //                   fontSize: 12.0,
                      //                   letterSpacing: 0.0,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.0),

                      //       // Demo Warning Dialog button
                      //       SizedBox(
                      //         width: double.infinity,
                      //         height: 32.0,
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //             showUsageWarningDialog(context);
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.orange,
                      //             foregroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(6.0),
                      //             ),
                      //             elevation: 0,
                      //           ),
                      //           child: Text(
                      //             'Demo Warning Dialog',
                      //             style: FlutterFlowTheme.of(context)
                      //                 .bodyMedium
                      //                 .override(
                      //                   fontFamily: 'Inter',
                      //                   color: Colors.white,
                      //                   fontSize: 12.0,
                      //                   letterSpacing: 0.0,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.0),

                      //       // Day 2 Dialog button
                      //       SizedBox(
                      //         width: double.infinity,
                      //         height: 32.0,
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //             showDay2Dialog(context);
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.purple,
                      //             foregroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(6.0),
                      //             ),
                      //             elevation: 0,
                      //           ),
                      //           child: Text(
                      //             'Day 2 Dialog',
                      //             style: FlutterFlowTheme.of(context)
                      //                 .bodyMedium
                      //                 .override(
                      //                   fontFamily: 'Inter',
                      //                   color: Colors.white,
                      //                   fontSize: 12.0,
                      //                   letterSpacing: 0.0,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.0),

                      //       // Day 4 Dialog button
                      //       SizedBox(
                      //         width: double.infinity,
                      //         height: 32.0,
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //             showDay4Dialog(context);
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.teal,
                      //             foregroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(6.0),
                      //             ),
                      //             elevation: 0,
                      //           ),
                      //           child: Text(
                      //             'Day 4 Dialog',
                      //             style: FlutterFlowTheme.of(context)
                      //                 .bodyMedium
                      //                 .override(
                      //                   fontFamily: 'Inter',
                      //                   color: Colors.white,
                      //                   fontSize: 12.0,
                      //                   letterSpacing: 0.0,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.0),

                      //       // Expire Trial button
                      //       SizedBox(
                      //         width: double.infinity,
                      //         height: 32.0,
                      //         child: ElevatedButton(
                      //           onPressed: () async {
                      //             // Manually set trial as expired for testing
                      //             SharedPreferences prefs =
                      //                 await SharedPreferences.getInstance();
                      //             DateTime pastDate = DateTime.now()
                      //                 .subtract(Duration(days: 8));
                      //             await prefs.setString('trial_end_date',
                      //                 pastDate.toIso8601String());

                      //             // Update the trial status
                      //             await checkSubscriptionStatus();

                      //             // Force start usage tracking after trial expiration
                      //             _startUsageTracking();

                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //               SnackBar(
                      //                 content: Text(
                      //                     'Trial manually expired for testing'),
                      //                 duration: Duration(seconds: 2),
                      //               ),
                      //             );
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.red,
                      //             foregroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(6.0),
                      //             ),
                      //             elevation: 0,
                      //           ),
                      //           child: Text(
                      //             'Expire Trial (Testing)',
                      //             style: FlutterFlowTheme.of(context)
                      //                 .bodyMedium
                      //                 .override(
                      //                   fontFamily: 'Inter',
                      //                   color: Colors.white,
                      //                   fontSize: 12.0,
                      //                   letterSpacing: 0.0,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.0),

                      //       // Reset Usage Time button
                      //       SizedBox(
                      //         width: double.infinity,
                      //         height: 32.0,
                      //         child: ElevatedButton(
                      //           onPressed: () async {
                      //             try {
                      //               print('🔄 Starting usage time reset...');

                      //               // Stop all timers first
                      //               _pauseUsageTracking();
                      //               _stopUsageTimeDisplay();

                      //               // Reset usage time in SharedPreferences
                      //               await preferenceService.resetUsageTime();
                      //               print(
                      //                   '✅ SharedPreferences reset completed');

                      //               // Reset stored remaining time to 180 seconds
                      //               await preferenceService
                      //                   .setRemainingTime(180);
                      //               print(
                      //                   '✅ Stored remaining time reset to 180 seconds');

                      //               // Reset all dialog flags
                      //               _hasShownSubscriptionDialogThisSession =
                      //                   false;
                      //               _hasShownWarningDialog = false;

                      //               // Reset timer variables
                      //               _usageSeconds = 0;
                      //               _isTimerActive = false;
                      //               print('🔄 Reset _usageSeconds to 0');

                      //               // Manually set the remaining time to 180 and update UI
                      //               setState(() {
                      //                 _remainingUsageTime = 180;
                      //               });

                      //               // Wait a moment then update from SharedPreferences
                      //               await Future.delayed(
                      //                   Duration(milliseconds: 100));
                      //               await _updateRemainingUsageTime();

                      //               // Restart usage time display
                      //               _startUsageTimeDisplay();

                      //               print(
                      //                   '🔄 Usage time manually reset to $_remainingUsageTime seconds');

                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content: Text(
                      //                       'Usage time reset to 3:00 minutes ($_remainingUsageTime seconds)'),
                      //                   duration: Duration(seconds: 2),
                      //                 ),
                      //               );
                      //             } catch (e) {
                      //               print('❌ Error resetting usage time: $e');
                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content: Text(
                      //                       'Error resetting usage time: $e'),
                      //                   duration: Duration(seconds: 2),
                      //                 ),
                      //               );
                      //             }
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.green,
                      //             foregroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(6.0),
                      //             ),
                      //             elevation: 0,
                      //           ),
                      //           child: Text(
                      //             'Reset Usage Time',
                      //             style: FlutterFlowTheme.of(context)
                      //                 .bodyMedium
                      //                 .override(
                      //                   fontFamily: 'Inter',
                      //                   color: Colors.white,
                      //                   fontSize: 12.0,
                      //                   letterSpacing: 0.0,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // // ===== MORE DEBUG BUTTONS =====
                      // Padding(
                      //   padding: const EdgeInsetsDirectional.fromSTEB(
                      //       16.0, 0.0, 16.0, 8.0),
                      //   child: Column(
                      //     children: [
                      //       // Force Start Timer button
                      //       SizedBox(
                      //         width: double.infinity,
                      //         height: 32.0,
                      //         child: ElevatedButton(
                      //           onPressed: () async {
                      //             try {
                      //               print(
                      //                   '🧪 Force starting usage timer for testing...');

                      //               // Stop any existing timers first
                      //               _pauseUsageTracking();
                      //               _stopUsageTimeDisplay();

                      //               // Reset session variables
                      //               _usageSeconds = 0;
                      //               _isTimerActive = false;
                      //               _hasShownSubscriptionDialogThisSession =
                      //                   false;
                      //               _hasShownWarningDialog = false;

                      //               // Update remaining time
                      //               await _updateRemainingUsageTime();

                      //               // Force start both timers
                      //               _startUsageTimeDisplay();
                      //               _forceStartUsageTracking();

                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content: Text(
                      //                       'Force started usage timer for testing'),
                      //                   duration: Duration(seconds: 2),
                      //                 ),
                      //               );
                      //             } catch (e) {
                      //               print('❌ Error force starting timer: $e');
                      //             }
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.purple,
                      //             foregroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(6.0),
                      //             ),
                      //             elevation: 0,
                      //           ),
                      //           child: Text(
                      //             'Force Start Timer (Test)',
                      //             style: FlutterFlowTheme.of(context)
                      //                 .bodyMedium
                      //                 .override(
                      //                   fontFamily: 'Inter',
                      //                   color: Colors.white,
                      //                   fontSize: 12.0,
                      //                   letterSpacing: 0.0,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.0),

                      //       // Set 30s Remaining button
                      //       SizedBox(
                      //         width: double.infinity,
                      //         height: 32.0,
                      //         child: ElevatedButton(
                      //           onPressed: () async {
                      //             try {
                      //               // Set usage time to 150 seconds (leaving 30 seconds)
                      //               SharedPreferences prefs =
                      //                   await SharedPreferences.getInstance();
                      //               await prefs.setInt('usage_time', 150);
                      //               await prefs.setInt(
                      //                   'usage_month', DateTime.now().month);

                      //               // Set stored remaining time to 30 seconds
                      //               await preferenceService
                      //                   .setRemainingTime(30);

                      //               // Reset session counter
                      //               _usageSeconds = 0;

                      //               // Update UI
                      //               await _updateRemainingUsageTime();

                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content: Text(
                      //                       'Set to 30 seconds remaining (red bar test)'),
                      //                   duration: Duration(seconds: 2),
                      //                 ),
                      //               );
                      //             } catch (e) {
                      //               print('❌ Error setting low time: $e');
                      //             }
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.orange,
                      //             foregroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(6.0),
                      //             ),
                      //             elevation: 0,
                      //           ),
                      //           child: Text(
                      //             'Set 30s Remaining (Test)',
                      //             style: FlutterFlowTheme.of(context)
                      //                 .bodyMedium
                      //                 .override(
                      //                   fontFamily: 'Inter',
                      //                   color: Colors.white,
                      //                   fontSize: 12.0,
                      //                   letterSpacing: 0.0,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 8.0),

                      //       // Debug Status Display
                      //       Container(
                      //         padding: EdgeInsets.all(8.0),
                      //         decoration: BoxDecoration(
                      //           color: Colors.grey[100],
                      //           borderRadius: BorderRadius.circular(6.0),
                      //           border: Border.all(color: Colors.grey[300]!),
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               'DEBUG STATUS:',
                      //               style: TextStyle(
                      //                 fontSize: 10,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.grey[600],
                      //               ),
                      //             ),
                      //             SizedBox(height: 4),
                      //             FutureBuilder<bool>(
                      //               future: preferenceService.hasTrialEnded(),
                      //               builder: (context, snapshot) {
                      //                 bool trialEnded = snapshot.data ?? false;
                      //                 return Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Text(
                      //                       'Subscribed: $_isSubscribed',
                      //                       style: TextStyle(
                      //                           fontSize: 10,
                      //                           color: Colors.grey[700]),
                      //                     ),
                      //                     Text(
                      //                       'Trial Ended: $trialEnded',
                      //                       style: TextStyle(
                      //                           fontSize: 10,
                      //                           color: Colors.grey[700]),
                      //                     ),
                      //                     Text(
                      //                       'Remaining Time: $_remainingUsageTime s',
                      //                       style: TextStyle(
                      //                           fontSize: 10,
                      //                           color: Colors.grey[700]),
                      //                     ),
                      //                     Text(
                      //                       'Usage Timer: ${_usageTimer?.isActive ?? false ? "ACTIVE" : "INACTIVE"}',
                      //                       style: TextStyle(
                      //                           fontSize: 10,
                      //                           color: Colors.grey[700]),
                      //                     ),
                      //                     Text(
                      //                       'Display Timer: ${_usageDisplayTimer?.isActive ?? false ? "ACTIVE" : "INACTIVE"}',
                      //                       style: TextStyle(
                      //                           fontSize: 10,
                      //                           color: Colors.grey[700]),
                      //                     ),
                      //                   ],
                      //                 );
                      //               },
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            4, 0, 4.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(0.0),
                              topRight: Radius.circular(0.0),
                            ),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                3.0, 0.0, 0.0, 0.0),
                            child: DropdownButton<String>(
                              underline: Container(),
                              value: _selectedOrientation,
                              onChanged: (String? newValue) {
                                _selectedOrientation = newValue!;

                                ConstValues.previousSelectedIndex =
                                    _orientationOptions
                                        .indexOf(_selectedOrientation);

                                LoadingDialog.show(context,
                                    message: l10n!.creatingPdf);

                                setState(() {
                                  createPDF();
                                });
                              },
                              items: _orientationOptions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                );
                              }).toList(),
                              isExpanded:
                                  true, // Makes the dropdown button fill the available width
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 16.0, 0.0, 0.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4.0, 0.0, 4.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        try {
                                          LogHelper.logErrorMessage(
                                              'Analytics Error', 'None');
                                          await analytics.logEvent(
                                            name:
                                                'event_on_choose_files_button_pressed',
                                            parameters: {
                                              'os': Platform.isAndroid
                                                  ? 'android'
                                                  : 'ios',
                                              'timestamp': DateTime.now()
                                                  .toIso8601String(),
                                            },
                                          );
                                          // LogHelper.logErrorMessage(
                                          //     'Analytics Error',
                                          //     'Successfully Logged');
                                        } catch (e) {
                                          LogHelper.logErrorMessage(
                                              'Analytics Error', e);
                                          print('Failed to log event: $e');
                                        }
                                        // await AnalyticsService.logButtonTap(
                                        //     'event_on_choose_files_button_pressed',
                                        //     additionalParams: {
                                        //       //   'source_format': 'jpg',
                                        //       //   'target_format': 'pdf',
                                        //       //   'file_count': imageFiles.length.toString(),
                                        //     });
                                        var pdfCreatedCount =
                                            await preferenceService
                                                .getPdfCreatedCount();

                                        LogHelper.logMessage(
                                            'pdfCreatedCount', pdfCreatedCount);

                                        // Check if user is not subscribed and trial has ended
                                        if (!_isSubscribed && _is7DaysPassed) {
                                          // Get remaining usage time
                                          int remainingTime =
                                              await preferenceService
                                                  .getRemainingUsageTime();

                                          // If no time remaining, show limit dialog (only once per day)
                                          if (remainingTime <= 0 &&
                                              !_hasShownSubscriptionDialogThisSession) {
                                            // Check if we can show the dialog today
                                            bool canShowToday =
                                                await preferenceService
                                                    .canShowTrialLimitDialogToday();

                                            if (canShowToday) {
                                              // Mark dialog as shown today
                                              await preferenceService
                                                  .markTrialLimitDialogShownToday();

                                              _hasShownSubscriptionDialogThisSession =
                                                  true;
                                              await analytics.logEvent(
                                                name:
                                                    'event_usage_limit_reached',
                                                parameters: {
                                                  'os': Platform.isAndroid
                                                      ? 'android'
                                                      : 'ios',
                                                  'timestamp': DateTime.now()
                                                      .toIso8601String(),
                                                  'remaining_time': '0',
                                                },
                                              );
                                              showUsageLimitDialog(context);
                                              return;
                                            } else {
                                              print(
                                                  '⏰ Trial limit dialog already shown today, skipping in createPDF');
                                              _hasShownSubscriptionDialogThisSession =
                                                  true;
                                              return;
                                            }
                                          }
                                        }

                                        Timer(Duration(seconds: 1), () {
                                          LoadingDialog.show(context,
                                              message: l10n!.creatingPdf);
                                        });

                                        LoadingDialog.isImagePickerCalled =
                                            true;
                                        LoadingDialog.isAlreadyCancelled =
                                            false;

                                        // Start the usage time display when conversion begins
                                        _startUsageTimeDisplay();

                                        bool hasRemainingTime =
                                            await preferenceService
                                                .hasRemainingUsageTime();

                                        try {
                                          var media = await selectMedia(
                                            maxWidth: (Platform.isAndroid)
                                                ? 880.00 * 2
                                                : 880.00,
                                            maxHeight: (Platform.isAndroid)
                                                ? 660.00 * 2
                                                : 660.00,
                                            imageQuality:
                                                (Platform.isAndroid) ? 90 : 81,
                                            includeDimensions: true,
                                            mediaSource:
                                                MediaSource.photoGallery,
                                            multiImage: true,
                                            isSubscribed: _isSubscribed,
                                            are7DaysPassed: _is7DaysPassed,
                                            remainingTime: _remainingUsageTime,
                                            // isPurchased: isPurchased,
                                          );

                                          if (media != null) {
                                            selectedMedia = media;
                                          }

                                          Timer(Duration(seconds: 1), () {
                                            createPDF();
                                          });
                                        } catch (e) {
                                          print(
                                              '🔴🔴🔴Error While Creating PDF: $e');
                                          // Use the safer method to stop usage time display only for subscribed users
                                          _stopUsageTimeDisplayIfSubscribed();
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(0.0),
                                            bottomRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(0.0),
                                            topRight: Radius.circular(0.0),
                                          ),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Align(
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        4.0, 0.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 100.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF173F5A),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  child: Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: AutoSizeText(
                                                          l10n!.chooseFiles,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                          minFontSize: 8,
                                                          maxLines: 1,
                                                        ),
                                                      )),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        8.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    _model.fname,
                                                    l10n!.noFilesSelected,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, left: 4),
                              child: Row(
                                children: [
                                  Text(
                                    //todo add check of 3 mins passed
                                    (!_isSubscribed &&
                                            _is7DaysPassed &&
                                            _remainingUsageTime <= 0)
                                        ? l10n!
                                            .youCanSelectUpTo3ImagesInFreeVersion
                                        : l10n!.youCanSelectUpTo60Images,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsetsDirectional.fromSTEB(
                      //       8.0, 16.0, 8.0, 16.0),
                      //   child: TextFormField(
                      //     controller: _model.filenameTextController,
                      //     focusNode: _model
                      //         .filenameFocusNode, // Use the FocusNode here
                      //     autofocus: true,
                      //     obscureText: false,
                      //     decoration: InputDecoration(
                      //       labelText:
                      //           _isFocused ? 'Filename' : 'Filename (Optional)',
                      //       labelStyle: FlutterFlowTheme.of(context)
                      //           .labelMedium
                      //           .override(
                      //             fontFamily: 'Inter',
                      //             letterSpacing: 0.0,
                      //           ),
                      //       hintText: 'Enter custom file name (optional)',
                      //       hintStyle: FlutterFlowTheme.of(context)
                      //           .labelMedium
                      //           .override(
                      //             fontFamily: 'Inter',
                      //             letterSpacing: 0.0,
                      //           ),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: FlutterFlowTheme.of(context).alternate,
                      //           width: 2.0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide: const BorderSide(
                      //           color: Color(0xFF173F5A),
                      //           width: 2.0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       errorBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: Colors.red,
                      //           width: 2.0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       focusedErrorBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color:  Colors.red,
                      //           width: 2.0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       filled: true,
                      //     ),
                      //     style:
                      //         FlutterFlowTheme.of(context).bodyMedium.override(
                      //               fontFamily: 'Inter',
                      //               letterSpacing: 0.0,
                      //             ),
                      //     validator: _model.filenameTextControllerValidator
                      //         .asValidator(context),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            8.0, 16.0, 8.0, (_hasBackSlash ? 6.0 : 16.0)),
                        child: TextFormField(
                          controller: _model.filenameTextController,
                          focusNode: _model.filenameFocusNode,
                          onChanged: (value) {
                            _hasBackSlash = false;

                            setState(() {
                              const invalidCharacters = r'\/:*?"<>|';

                              for (var char in invalidCharacters.runes) {
                                if (value.contains(String.fromCharCode(char))) {
                                  _hasBackSlash = true;
                                }
                              }
                            });
                          },
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: _isFocused
                                ? l10n!.filename
                                : l10n!.filenameOptional,
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: l10n!.enterCustomFileNameOptional
                            // 'Enter custom file name (optional)'
                            ,
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF173F5A),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                          validator: _model
                              .filenameTextControllerValidator, // Assign the validator here
                        ),
                      ),
                      if (_hasBackSlash)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 0, 8.0, 16.0),
                          child: Text(
                            l10n!.filenameCannotContainCharacters,
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    color: Colors.red),
                          ),
                        ),

                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (_model.pdfFile != null &&
                              (_model.pdfFile?.bytes?.isNotEmpty ?? false))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 4.0, 8.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_hasBackSlash) {
                                    showFilenameErrorDialog(context);
                                  } else {
                                    print(
                                        'ConverterWidget: isPermissionEnabled Calling...');
                                    // var isPermissionEnabled =
                                    //     await _requestStoragePermission(
                                    //         context);

                                    print(
                                        'ConverterWidget: isPermissionEnabled Called...');

                                    // if (!isPermissionEnabled) {
                                    //   print(
                                    //       'ConverterWidget: isPermissionEnabled False Returning...');

                                    //   return;
                                    // }

                                    analytics.logEvent(
                                      name:
                                          'event_on_download_pdf_button_pressed',
                                      parameters: {
                                        'os': Platform.isAndroid
                                            ? 'android'
                                            : 'ios',
                                        'timestamp':
                                            DateTime.now().toIso8601String(),
                                        // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
                                      },
                                    );

                                    // print('ConverterWidget: isPermissionEnabled Called...');

                                    _model.filenameDefaultDown = await actions
                                        .generateFormattedDateTime();

                                    _model.download =
                                        await actions.downloadFFUploadedFile(
                                      _model.pdfFile!,
                                      _model.filenameTextController.text != ''
                                          ? _model.filenameTextController.text
                                          : _model.filenameDefaultDown!,
                                    );

                                    safeSetState(() {});
                                  }
                                },
                                text: l10n!.downloadPDF
                                // 'Download PDF'
                                ,
                                icon: const Icon(
                                  Icons.sim_card_download_sharp,
                                  size: 20.0,
                                ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF173F5A),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF173F5A),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          if (_model.pdfFile != null &&
                              (_model.pdfFile?.bytes?.isNotEmpty ?? false))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 4.0, 8.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_hasBackSlash) {
                                    showFilenameErrorDialog(context);
                                  } else {
                                    await analytics.logEvent(
                                      name:
                                          'event_on_view_pdf_button_purchased',
                                      parameters: {
                                        'timestamp':
                                            DateTime.now().toIso8601String(),
                                        'os': Platform.isAndroid
                                            ? 'android'
                                            : 'ios',
                                        // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
                                      },
                                    );
                                    if (_model.filenameTextController.text
                                        .isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewerScreen(
                                            pdfBytes: _model.pdfFile!.bytes,
                                            title: _model
                                                .filenameTextController.text,
                                          ),
                                        ),
                                      );
                                    } else {
                                      _model.filenameDefault = await actions
                                          .generateFormattedDateTime();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewerScreen(
                                              pdfBytes: _model.pdfFile!.bytes,
                                              title: _model.filenameDefault!),
                                        ),
                                      );
                                    }
                                    safeSetState(() {});
                                  }
                                },
                                text: l10n!.viewPdf,
                                icon: const Icon(
                                  Icons.visibility,
                                  size: 20.0,
                                ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF173F5A),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: Color(0xFF173F5A),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 4, 8.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await analytics.logEvent(
                                  name: 'event_on_about_button_purchased',
                                  parameters: {
                                    'timestamp':
                                        DateTime.now().toIso8601String(),
                                    'os':
                                        Platform.isAndroid ? 'android' : 'ios',
                                    // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
                                  },
                                );
                                context.pushNamed('Mainmenu').then((_) {
                                  l10n = AppLocalizations.of(context);
                                  generateOrientationOptions();
                                  if (!_orientationOptions
                                      .contains(_selectedOrientation)) {
                                    _selectedOrientation = _orientationOptions[
                                        ConstValues.previousSelectedIndex];
                                  }
                                });
                              },
                              text: l10n!.about,
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF173F5A),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Color(0xFF173F5A),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsetsDirectional.fromSTEB(
                          //       8.0, 4, 8.0, 0.0),
                          //   child: FFButtonWidget(
                          //     onPressed: () async {
                          //       showTrialLimitDialog(context);
                          //     },
                          //     text: 'ShowTrialButtonDialog',
                          //     options: FFButtonOptions(
                          //       width: double.infinity,
                          //       height: 50.0,
                          //       padding: const EdgeInsetsDirectional.fromSTEB(
                          //           24.0, 0.0, 24.0, 0.0),
                          //       iconPadding:
                          //           const EdgeInsetsDirectional.fromSTEB(
                          //               0.0, 0.0, 0.0, 0.0),
                          //       color: Color(0xFF173F5A),
                          //       textStyle: FlutterFlowTheme.of(context)
                          //           .titleLarge
                          //           .override(
                          //             fontFamily: 'Readex Pro',
                          //             color: FlutterFlowTheme.of(context).info,
                          //             fontSize: 18.0,
                          //             letterSpacing: 0.0,
                          //           ),
                          //       elevation: 0.0,
                          //       borderSide: BorderSide(
                          //         color: Color(0xFF173F5A),
                          //         width: 2.0,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsetsDirectional.fromSTEB(
                          //       8.0, 4, 8.0, 0.0),
                          //   child: FFButtonWidget(
                          //     onPressed: () async {
                          //       _showPermissionDialog(context,
                          //           l10n!.storagePermissionMessageRequired);
                          //     },
                          //     text: 'showPermissionsDialog',
                          //     options: FFButtonOptions(
                          //       width: double.infinity,
                          //       height: 50.0,
                          //       padding: const EdgeInsetsDirectional.fromSTEB(
                          //           24.0, 0.0, 24.0, 0.0),
                          //       iconPadding:
                          //           const EdgeInsetsDirectional.fromSTEB(
                          //               0.0, 0.0, 0.0, 0.0),
                          //       color: Color(0xFF173F5A),
                          //       textStyle: FlutterFlowTheme.of(context)
                          //           .titleLarge
                          //           .override(
                          //             fontFamily: 'Readex Pro',
                          //             color: FlutterFlowTheme.of(context).info,
                          //             fontSize: 18.0,
                          //             letterSpacing: 0.0,
                          //           ),
                          //       elevation: 0.0,
                          //       borderSide: BorderSide(
                          //         color: Color(0xFF173F5A),
                          //         width: 2.0,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsetsDirectional.fromSTEB(
                          //       8.0, 4, 8.0, 0.0),
                          //   child: FFButtonWidget(
                          //     onPressed: () async {
                          //       showFilenameErrorDialog(context);
                          //     },
                          //     text: 'showFilenameErrorDialog',
                          //     options: FFButtonOptions(
                          //       width: double.infinity,
                          //       height: 50.0,
                          //       padding: const EdgeInsetsDirectional.fromSTEB(
                          //           24.0, 0.0, 24.0, 0.0),
                          //       iconPadding:
                          //           const EdgeInsetsDirectional.fromSTEB(
                          //               0.0, 0.0, 0.0, 0.0),
                          //       color: Color(0xFF173F5A),
                          //       textStyle: FlutterFlowTheme.of(context)
                          //           .titleLarge
                          //           .override(
                          //             fontFamily: 'Readex Pro',
                          //             color: FlutterFlowTheme.of(context).info,
                          //             fontSize: 18.0,
                          //             letterSpacing: 0.0,
                          //           ),
                          //       elevation: 0.0,
                          //       borderSide: BorderSide(
                          //         color: Color(0xFF173F5A),
                          //         width: 2.0,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //   ),
                          // ),
                          // if( !_isSubscribed )
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 4.0, 8.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await analytics.logEvent(
                                  name:
                                      'event_on_view_subscription_page_button_pressed',
                                  parameters: {
                                    'os':
                                        Platform.isAndroid ? 'android' : 'ios',
                                    'timestamp':
                                        DateTime.now().toIso8601String(),
                                  },
                                );
                                context.pushNamed('Subscription').then((_) {
                                  checkSubscriptionStatus();
                                  setState(
                                      () {}); // This will trigger a rebuild, calling initState if necessary
                                });
                              },
                              text: !_isSubscribed
                                  ? '${l10n!.getFullLifetimeAccess}\$'
                                  : l10n!.viewPurchaseDetails,
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF173F5A),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Color(0xFF173F5A),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 4, 8.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LanguageSelectionScreen()))
                                    .then((_) {
                                  l10n = AppLocalizations.of(context);
                                  generateOrientationOptions();

                                  // // Log the language change event
                                  // await analytics.logEvent(
                                  //   name: 'event_on_language_changed',
                                  //   parameters: {
                                  //     'os': Platform.isAndroid ? 'android' : 'ios',
                                  //     'timestamp': DateTime.now().toIso8601String(),
                                  //     'new_language': Localizations.localeOf(context).languageCode,
                                  //   },
                                  // );

                                  // Store current index before regenerating options
                                  int currentIndex =
                                      ConstValues.previousSelectedIndex;

                                  // Ensure the index is valid for the new list of options
                                  if (currentIndex >=
                                      _orientationOptions.length) {
                                    currentIndex = 0;
                                    ConstValues.previousSelectedIndex = 0;
                                  }

                                  // Set the orientation to the corresponding option in the new language
                                  _selectedOrientation =
                                      _orientationOptions[currentIndex];

                                  // Force a complete rebuild of the widget
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  });
                                });

                                // If language was changed, rebuild the screen
                              },
                              text: l10n!.selectLanguage,
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF173F5A),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Color(0xFF173F5A),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsetsDirectional.fromSTEB(
                          //       0.0, 20.0, 0.0, 0.0),
                          //   child: FFButtonWidget(
                          //     onPressed: () async {
                          //       context.pushNamed('Mainmenu');
                          //     },
                          //     text: 'Main Menu',
                          //     options: FFButtonOptions(
                          //       height: 40.0,
                          //       padding: const EdgeInsetsDirectional.fromSTEB(
                          //           24.0, 0.0, 24.0, 0.0),
                          //       iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          //           0.0, 0.0, 0.0, 0.0),
                          //       color: const Color(0xFF4A90E2),
                          //       textStyle: FlutterFlowTheme.of(context)
                          //           .titleSmall
                          //           .override(
                          //             fontFamily: 'Inter',
                          //             color: Colors.white,
                          //             letterSpacing: 0.0,
                          //           ),
                          //       elevation: 3.0,
                          //       borderSide: const BorderSide(
                          //         color: Colors.transparent,
                          //         width: 1.0,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //   ),
                          // ),

                          // DEBUG TESTING SECTION - Only visible in debug mode
//                           if (kDebugMode) ...[
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
//                               child: Container(
//                                 width: double.infinity,
//                                 padding: EdgeInsets.all(16.0),
//                                 decoration: BoxDecoration(
//                                   color: Colors.yellow.withOpacity(0.1),
//                                   border: Border.all(
//                                       color: Colors.orange, width: 2),
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '🧪 DEBUG TESTING CONTROLS',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.orange[800],
//                                       ),
//                                     ),
//                                     SizedBox(height: 12),

//                                     // Current Status Display
//                                     Container(
//                                       padding: EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.withOpacity(0.1),
//                                         borderRadius: BorderRadius.circular(4),
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text('Current Status:',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold)),
//                                               Spacer(),
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   _debugTimerStatus();
//                                                   setState(
//                                                       () {}); // Refresh display
//                                                 },
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor: Colors.blue,
//                                                   foregroundColor: Colors.white,
//                                                   minimumSize: Size(60, 30),
//                                                 ),
//                                                 child: Text('Refresh',
//                                                     style: TextStyle(
//                                                         fontSize: 10)),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(height: 4),
//                                           Text(
//                                               'Subscribed: ${_isSubscribed ? "✅ YES" : "❌ NO"}'),
//                                           Text(
//                                               'Remaining Time: ${_remainingUsageTime}s'),
//                                           Text('Usage Seconds: $_usageSeconds'),
//                                           Text(
//                                               'Display Timer: ${_usageDisplayTimer?.isActive ?? false ? "🟢 RUNNING" : "🔴 STOPPED"}'),
//                                           Text(
//                                               'Usage Timer: ${_usageTimer?.isActive ?? false ? "🟢 RUNNING" : "🔴 STOPPED"}'),
//                                           Text(
//                                               'Timer Active Flag: ${_isTimerActive ? "✅ TRUE" : "❌ FALSE"}'),
//                                           FutureBuilder<bool>(
//                                             future: preferenceService
//                                                 .hasTrialEnded(),
//                                             builder: (context, snapshot) {
//                                               bool trialEnded =
//                                                   snapshot.data ?? false;
//                                               return Text(
//                                                   'Trial Status: ${trialEnded ? "⏰ EXPIRED" : "🎁 ACTIVE"}');
//                                             },
//                                           ),
//                                           FutureBuilder<bool>(
//                                             future: preferenceService
//                                                 .isUsagePaused(),
//                                             builder: (context, snapshot) {
//                                               bool isPaused =
//                                                   snapshot.data ?? false;
//                                               return Text(
//                                                   'Usage: ${isPaused ? "⏸️ PAUSED" : "▶️ ACTIVE"}');
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 16),

//                                     // Subscription Status Controls
//                                     Text(
//                                       'Subscription Status:',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () {
//                                               setState(() {
//                                                 // _isSubscribed = true;
//                                               });
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(
//                                                 SnackBar(
//                                                     content: Text(
//                                                         '✅ Subscription set to TRUE')),
//                                               );
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.green,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Set Subscribed'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () {
//                                               setState(() {
//                                                 _isSubscribed = false;
//                                               });
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(
//                                                 SnackBar(
//                                                     content: Text(
//                                                         '❌ Subscription set to FALSE')),
//                                               );
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.red,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Set Unsubscribed'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 16),

//                                     // Trial Controls
//                                     Text(
//                                       'Trial Controls:',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 SharedPreferences prefs =
//                                                     await SharedPreferences
//                                                         .getInstance();
//                                                 DateTime now = DateTime.now();
//                                                 DateTime trialEndDate =
//                                                     now.add(Duration(days: 7));
//                                                 await prefs.setString(
//                                                     'trial_end_date',
//                                                     trialEndDate
//                                                         .toIso8601String());

//                                                 await preferenceService
//                                                     .resetUsageTime();
//                                                 await preferenceService
//                                                     .setRemainingTime(180);
//                                                 _usageSeconds = 0;
//                                                 await _updateRemainingUsageTime();

//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '🎁 Trial reset to 7 days active')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error resetting trial: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.blue,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Reset Trial (7 Days)'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 SharedPreferences prefs =
//                                                     await SharedPreferences
//                                                         .getInstance();
//                                                 DateTime yesterday =
//                                                     DateTime.now().subtract(
//                                                         Duration(days: 1));
//                                                 await prefs.setString(
//                                                     'trial_end_date',
//                                                     yesterday
//                                                         .toIso8601String());

//                                                 await _updateRemainingUsageTime();

//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '⏰ Trial set to EXPIRED')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error expiring trial: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.orange,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Expire Trial'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 16),

//                                     // Usage Time Controls
//                                     Text(
//                                       'Usage Time Controls:',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 // Stop only the usage timer (keep display timer running)
//                                                 _pauseUsageTracking();

//                                                 // Set time to 30 seconds
//                                                 await preferenceService
//                                                     .setRemainingTime(30);

//                                                 // Reset session variables
//                                                 _usageSeconds = 0;

//                                                 // Update UI first
//                                                 await _updateRemainingUsageTime();

//                                                 // Force start usage tracking for testing
//                                                 _forceStartUsageTracking();

//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '⚠️ Timer set to 30s and started!')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error setting time: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.amber,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Set 30s'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 // Stop only the usage timer (keep display timer running)
//                                                 _pauseUsageTracking();

//                                                 // Set time to 0 seconds (expired)
//                                                 await preferenceService
//                                                     .setRemainingTime(0);

//                                                 // Reset session variables
//                                                 _usageSeconds = 0;

//                                                 // Update UI to show expired state
//                                                 await _updateRemainingUsageTime();

//                                                 // Don't start timers since time is 0

//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '🚫 Timer set to 0s (expired)')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error setting time: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.red,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Set 0s'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 // Stop only the usage timer (keep display timer running)
//                                                 _pauseUsageTracking();

//                                                 // Reset usage time in SharedPreferences
//                                                 await preferenceService
//                                                     .resetUsageTime();
//                                                 await preferenceService
//                                                     .setRemainingTime(180);

//                                                 // Reset session variables
//                                                 _usageSeconds = 0;
//                                                 _hasShownWarningDialog = false;
//                                                 _hasShownSubscriptionDialogThisSession =
//                                                     false;

//                                                 // Update UI first
//                                                 await _updateRemainingUsageTime();

//                                                 // Force start usage tracking for testing (bypass trial check)
//                                                 // Display timer should already be running from initState
//                                                 _forceStartUsageTracking();

//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '✅ Timer reset to 180s and started!')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error resetting time: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.green,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Reset 180s'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 16),

//                                     // Usage Pause Controls
//                                     Text(
//                                       'Usage Pause Controls:',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 await preferenceService
//                                                     .startUsagePause();
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '⏸️ Usage PAUSED for 30 days')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error starting pause: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.purple,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Start 30-Day Pause'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 SharedPreferences prefs =
//                                                     await SharedPreferences
//                                                         .getInstance();
//                                                 await prefs.remove(
//                                                     'usage_pause_start_date');
//                                                 await preferenceService
//                                                     .setRemainingTime(180);
//                                                 await _updateRemainingUsageTime();
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '▶️ 30-day pause RESET')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error resetting pause: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.teal,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Reset Pause'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 16),

//                                     // Dialog Testing Controls
//                                     Text(
//                                       'Dialog Testing:',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () {
//                                               showUsageWarningDialog(context);
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.orange,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Warning Dialog'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () {
//                                               showDay2Dialog(context);
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.purple,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Day 2 Dialog'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () {
//                                               showDay4Dialog(context);
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.teal,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Day 4 Dialog'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () {
//                                               showUsageLimitDialog(context);
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.red,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Usage Limit Dialog'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 SharedPreferences prefs =
//                                                     await SharedPreferences
//                                                         .getInstance();
//                                                 await prefs.remove(
//                                                     'last_trial_limit_dialog_date');
//                                                 _hasShownSubscriptionDialogThisSession =
//                                                     false;
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '🔄 Dialog dates reset')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error resetting dialog dates: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.indigo,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Reset Dialog Dates'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 16),

//                                     // Installation Date Controls
//                                     Text(
//                                       'Installation Date Controls:',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 SharedPreferences prefs =
//                                                     await SharedPreferences
//                                                         .getInstance();
//                                                 DateTime twoDaysAgo =
//                                                     DateTime.now().subtract(
//                                                         Duration(days: 2));
//                                                 await prefs.setString(
//                                                     'installation_date',
//                                                     twoDaysAgo
//                                                         .toIso8601String());
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '📅 Installation set to 2 days ago')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error setting installation date: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.blue,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Set Day 2'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 SharedPreferences prefs =
//                                                     await SharedPreferences
//                                                         .getInstance();
//                                                 DateTime fourDaysAgo =
//                                                     DateTime.now().subtract(
//                                                         Duration(days: 4));
//                                                 await prefs.setString(
//                                                     'installation_date',
//                                                     fourDaysAgo
//                                                         .toIso8601String());
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '📅 Installation set to 4 days ago')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error setting installation date: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.green,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Set Day 4'),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Expanded(
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               try {
//                                                 SharedPreferences prefs =
//                                                     await SharedPreferences
//                                                         .getInstance();
//                                                 DateTime now = DateTime.now();
//                                                 await prefs.setString(
//                                                     'installation_date',
//                                                     now.toIso8601String());
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                       content: Text(
//                                                           '📅 Installation reset to today')),
//                                                 );
//                                               } catch (e) {
//                                                 print(
//                                                     '❌ Error resetting installation date: $e');
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.grey,
//                                               foregroundColor: Colors.white,
//                                             ),
//                                             child: Text('Reset Today'),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
// //
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: const Color(0xFF8ca9cf),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RichText(
                                        textScaler:
                                            MediaQuery.of(context).textScaler,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: l10n!.dataCollection
                                              // 'Data Collection:'
                                              ,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' ${l10n!.weDoNotCollectAnyPersonalData}:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '\n- ${l10n!.noImagesAreShared}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ].divide(const SizedBox(height: 12.0)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createPDF() async {
    const String LOG_TAG = "PDF_CREATION";
    print('[$LOG_TAG] Starting PDF creation process');

    if (selectedMedia == null) {
      print(
          '[$LOG_TAG] No media selected, hiding loading dialog and returning');
      LoadingDialog.hide(context);
      // Don't stop usage time display when no media selected - keep it running for non-subscribed users
      return;
    }

    print('[$LOG_TAG] Selected media count: ${selectedMedia!.length}');

    if (selectedMedia != null &&
        selectedMedia!
            .every((m) => validateFileFormat(m.storagePath, context))) {
      print('[$LOG_TAG] All selected files have valid format');

      if (!_isSubscribed) {
        print(
            '[$LOG_TAG] User is not subscribed, incrementing PDF created count');
        preferenceService.incrementAndReturnPdfCreatedCount();
      }

      print('[$LOG_TAG] Setting isDataUploading to true');
      safeSetState(() => _model.isDataUploading = true);

      var selectedUploadedFiles = <FFUploadedFile>[];

      try {
        print('[$LOG_TAG] Converting selected media to FFUploadedFile objects');
        selectedUploadedFiles = selectedMedia!
            .map((m) => FFUploadedFile(
                  name: m.storagePath.split('/').last,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                  blurHash: m.blurHash,
                ))
            .toList();

        await analytics.logEvent(
          name: 'event_on_create_pdf_called',
          parameters: {
            'os': Platform.isAndroid ? 'android' : 'ios',
            'timestamp': DateTime.now().toIso8601String(),
            'selectedFileCount': selectedUploadedFiles!.length.toString(),
          },
        );
        print(
            '[$LOG_TAG] Successfully converted ${selectedUploadedFiles.length} files');
      } catch (e) {
        print('[$LOG_TAG] Error converting media files: $e');
      } finally {
        print('[$LOG_TAG] Setting isDataUploading to false');
        _model.isDataUploading = false;
      }

      if (selectedUploadedFiles.length == selectedMedia!.length) {
        print('[$LOG_TAG] All files converted successfully, updating model');
        safeSetState(() {
          _model.uploadedLocalFiles = selectedUploadedFiles;
        });
      } else {
        print('[$LOG_TAG] Not all files were converted, returning');
        // Don't stop usage time display when file conversion fails - keep it running for non-subscribed users
        safeSetState(() {});
        return;
      }
    } else {
      print('[$LOG_TAG] Some files have invalid format');
    }

    print(
        '[$LOG_TAG] Uploaded local files count: ${_model.uploadedLocalFiles.length}');

    if (_model.uploadedLocalFiles.length > 1) {
      print('[$LOG_TAG] Multiple files selected, updating display name');
      _model.fname =
          '${_model.uploadedLocalFiles.length.toString()} ${l10n!.filesSelected}';
      print('[$LOG_TAG] Display name set to: ${_model.fname}');
      safeSetState(() {});
    } else {
      if (_model.uploadedLocalFiles.length == 1) {
        print('[$LOG_TAG] Single file selected, getting filename');
        _model.name = await actions.filename(
          _model.uploadedLocalFiles.firstOrNull!,
        );
        print('[$LOG_TAG] Filename retrieved: ${_model.name}');
        _model.fname = _model.name;
        safeSetState(() {});
      } else {
        _model.fname = l10n!.noFilesSelected;
        safeSetState(() {});
      }
    }

    print('[$LOG_TAG] Checking for landscape images');
    _model.checkLandscapeGallery = await actions.checkIfLandscape(
      _model.uploadedLocalFiles.toList(),
    );
    print(
        '[$LOG_TAG] Landscape images detected: ${_model.checkLandscapeGallery}');

    if (_model.checkLandscapeGallery!) {
      print('[$LOG_TAG] Processing landscape images');
      final pileupList = _model.uploadedLocalFiles.map((file) {
        return SerializableFile(file.bytes!, file.name!).toMap();
      }).toList();
      print(
          '[$LOG_TAG] Created serializable file list with ${pileupList.length} items');

      print(
          '[$LOG_TAG] Filename from text controller: ${_model.filenameTextController.text}');

      final params = PdfMultiImgParams(
        fileupList: pileupList,
        filename: valueOrDefault<String>(
          _model.filenameTextController.text,
          'file',
        ),
        notes: _model.filenameTextController.text,
        isFirstPageSelected: true,
        fit: 'contain',
        selectedIndex: _orientationOptions.indexOf(_selectedOrientation),
      );
      print(
          '[$LOG_TAG] Created PDF parameters with orientation: $_selectedOrientation (index: ${_orientationOptions.indexOf(_selectedOrientation)})');

      print('[$LOG_TAG] Starting PDF generation with isolate');
      _model.pdf2 = await pdfMultiImgWithIsolate(params);
      print(
          '[$LOG_TAG] PDF generation completed, PDF size: ${_model.pdf2?.bytes?.length ?? 0} bytes');

      _model.pdfFile = _model.pdf2;
      _model.landscapeExists = _model.checkLandscapeGallery;
      print('[$LOG_TAG] PDF file assigned to model');

      safeSetState(() {});
    } else {
      print('[$LOG_TAG] Processing portrait/mixed images');
      final pileupList = _model.uploadedLocalFiles.map((file) {
        return SerializableFile(file.bytes!, file.name!).toMap();
      }).toList();
      print(
          '[$LOG_TAG] Created serializable file list with ${pileupList.length} items');

      print(
          '[$LOG_TAG] Filename from text controller: ${_model.filenameTextController.text}');

      final params = PdfMultiImgParams(
        fileupList: pileupList,
        filename: valueOrDefault<String>(
          _model.filenameTextController.text,
          'file',
        ),
        notes: _model.filenameTextController.text,
        isFirstPageSelected: true,
        fit: 'contain',
        selectedIndex: _orientationOptions.indexOf(_selectedOrientation),
      );
      print(
          '[$LOG_TAG] Created PDF parameters with orientation: $_selectedOrientation (index: ${_orientationOptions.indexOf(_selectedOrientation)})');

      print('[$LOG_TAG] Starting PDF generation with isolate');
      _model.pdf2 = await pdfMultiImgWithIsolate(params);
      print(
          '[$LOG_TAG] PDF generation completed, PDF size: ${_model.pdf2?.bytes?.length ?? 0} bytes');

      _model.pdfFile = _model.pdf2;
      _model.landscapeExists = _model.checkLandscapeGallery;
      print('[$LOG_TAG] PDF file assigned to model');

      safeSetState(() {});
    }

    print('[$LOG_TAG] Updating UI state');
    safeSetState(() {});
    print('[$LOG_TAG] Hiding loading dialog');
    LoadingDialog.hide(context);

    // Use the safer method to stop usage time display only for subscribed users
    _stopUsageTimeDisplayIfSubscribed();

    // Ensure usage time display is running for non-subscribed users
    if (!_isSubscribed && !_showUsageTime) {
      print('[$LOG_TAG] Restarting usage time display for non-subscribed user');
      _startUsageTimeDisplay();
    }

    print('[$LOG_TAG] PDF creation process completed successfully');
  }

  Future<bool> checkPreviousAppPurchase() async {
    if (!Platform.isIOS) {
      LogHelper.logMessage('Platform Check', 'Not iOS platform');
      return false;
    }

    try {
      final client = http.Client();

      // Try up to 3 times to get the receipt
      for (int i = 0; i < 3; i++) {
        try {
          final receipt = await const MethodChannel('app_store_receipt')
              .invokeMethod<String>('getReceipt');

          if (receipt != null) {
            // isPurchased = true;
            setState(() {
              // _isPurchased = true;
              _isSubscribed = true;
            });
            LogHelper.logMessage('Receipt Status', 'Receipt found on device');
            LogHelper.logMessage('Receipt Data',
                '${receipt.substring(0, min(50, receipt.length))}...');

            // First try production URL
            final prodResponse = await _verifyReceipt(receipt, false);
            if (prodResponse != null && prodResponse['status'] == 0) {
              setState(() {
                // _isP = true;

                _isSubscribed = true;
              });
              LogHelper.logSuccessMessage(
                  'Purchase Verification', 'Valid production receipt found');
              return true;
            }

            // If production fails, try sandbox
            final sandboxResponse = await _verifyReceipt(receipt, true);
            if (sandboxResponse != null && sandboxResponse['status'] == 0) {
              LogHelper.logSuccessMessage(
                  'Purchase Verification', 'Valid sandbox receipt found');
              return true;
            }
          }

          LogHelper.logMessage(
              'Receipt Attempt', 'Attempt ${i + 1} failed, retrying...');
          await Future.delayed(const Duration(seconds: 1));
        } catch (e) {
          LogHelper.logErrorMessage('Receipt Fetch Error', e);
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      LogHelper.logErrorMessage(
          'Receipt Status', 'Failed to verify receipt after 3 attempts');
      return false;
    } catch (e) {
      LogHelper.logErrorMessage('Receipt Validation', e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> _verifyReceipt(
      String receipt, bool sandbox) async {
    try {
      // In debug mode, always try sandbox endpoint first
      final url = 'https://sandbox.itunes.apple.com/verifyReceipt';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'receipt-data': receipt,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      LogHelper.logErrorMessage('Receipt Verification Error', e);
    }
    return null;
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    // if (Platform.isAndroid) {
    //   PermissionStatus status;

    //   if (int.parse(Platform.version.split('.')[0]) >= 13) {
    //     // For Android 13+ (API 33+)
    //     status = await Permission.photos.request();
    //   } else if (int.parse(Platform.version.split('.')[0]) >= 11) {
    //     // For Android 11 and 12 (API 30, 31, 32)
    //     status = await Permission.storage.request();
    //   } else {
    //     // For Android 10 and below
    //     status = await Permission.storage.request();
    //   }

    //   if (status.isDenied) {
    //     _showPermissionDialog(
    //       context,
    //       l10n!.storagePermissionMessageRequired
    //       // 'This app needs storage permission to save PDFs'
    //       ,
    //       // AppLocalizations.of(context)!.storagePermissionMessageRequired
    //     );
    //     return false;
    //   }

    //   if (status.isPermanentlyDenied) {
    //     _showPermissionDialog(context, l10n!.storagePermissionMessageRequired,
    //         openSettings: true);
    //     return false;
    //   }
    // }
    return true;
  }

  Future<void> checkSubscriptionStatus() async {
    // Check if trial has ended
    _is7DaysPassed = await preferenceService.hasTrialEnded();

    // Set trial end date if not already set
    await preferenceService.setTrialEndDate();

    try {
      _customerInfo = await Purchases.getCustomerInfo();

      if (_customerInfo?.entitlements.all['sub_lifetime'] != null &&
          _customerInfo?.entitlements.all['sub_lifetime']?.isActive == true) {
        // User has subscription
        await analytics.logEvent(
          name: 'event_on_subscription_already_purchased',
          parameters: {
            'os': Platform.isAndroid ? 'android' : 'ios',
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
        setState(() {
          _isSubscribed = true;
        });
        // Keep usage time display for all users (for now)
        if (!_showUsageTime) {
          _startUsageTimeDisplay();
        }
      } else {
        _isSubscribed = false;
        setState(() {});

        // Check for previous purchases
        bool hasPreviousPurchase = await checkPreviousAppPurchase();
        if (hasPreviousPurchase) {
          setState(() {
            _isSubscribed = true;
          });
          // Keep usage time display for all users (for now)
          if (!_showUsageTime) {
            _startUsageTimeDisplay();
          }
        } else {
          // Start usage time display for all users (for now)
          if (!_showUsageTime) {
            _startUsageTimeDisplay();
          }
        }
        // If not subscribed and trial has ended, check remaining usage time
        if (!_isSubscribed &&
            _is7DaysPassed &&
            !_hasShownSubscriptionDialogThisSession) {
          bool hasRemainingTime =
              await preferenceService.hasRemainingUsageTime();
          if (!hasRemainingTime) {
            // Show usage limit dialog after a short delay
            Future.delayed(Duration(seconds: 1), () {
              if (mounted) {
                _hasShownSubscriptionDialogThisSession = true;
                showUsageLimitDialog(context);
              }
            });
          }
        }
      }
    } catch (e) {
      LogHelper.logErrorMessage('Subscription Check Error', e);
    }
  }

  void initRateMyApp() {
    // todo revert this commeted function
    // RateMyApp rateMyApp = RateMyApp(
    //   preferencesPrefix: 'rateMyApp_',
    //   minDays: 7,
    //   minLaunches: 7,
    //   remindDays: 7,
    //   remindLaunches: 10,
    //   googlePlayIdentifier: 'com.mycompany.ispeedpix2pdf7',
    //   appStoreIdentifier: '6667115897',
    // );

    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 1,
      minLaunches: 1,
      remindDays: 1,
      remindLaunches: 1,
      googlePlayIdentifier: 'com.mycompany.ispeedpix2pdf7',
      appStoreIdentifier: '6667115897',
    );

    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: '${l10n!.rateThisApp}', // The dialog title.
          message: '${l10n!.rateThisAppMessage}', // The dialog message.
          rateButton: '${l10n!.rate}', // The dialog "rate" button text.
          noButton:
              '${l10n!.noThanks}', // iTHANKS', // The dialog "no" button text.
          laterButton: '${l10n!.maybeLater}', // The dialog "later" button text.
          listener: (button) {
            // The button click listener (useful if you want to cancel the click event).
            switch (button) {
              case RateMyAppDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          ignoreNativeDialog:
              false, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: const DialogStyle(), // Custom dialog styles.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          // contentBuilder: (co/ntext, defaultContent) => content, // This one allows you to change the default dialog content.
          // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
        );
      }
    });
  }

  // Add this method to start tracking usage time
  // Force start usage tracking for testing purposes (bypasses trial/subscription checks)
  void _forceStartUsageTracking() async {
    print('🧪 FORCE starting usage tracking for testing');

    // Stop any existing timer first
    if (_usageTimer != null && _usageTimer!.isActive) {
      _usageTimer!.cancel();
      print('🛑 Cancelled existing usage timer');
    }

    _lastActiveTime = DateTime.now();
    _isTimerActive = true;

    // Create a timer that fires every second
    _usageTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!_isTimerActive || !mounted) {
        timer.cancel();
        return;
      }

      _usageSeconds++;
      print(
          '⏱️ Usage seconds: $_usageSeconds, remaining: $_remainingUsageTime');

      // For testing: directly decrement the remaining time instead of recalculating
      if (_remainingUsageTime > 0) {
        setState(() {
          _remainingUsageTime--;
        });
      }

      // Check if time has expired
      if (_remainingUsageTime <= 0) {
        print('⏰ Time expired, pausing timer');
        _pauseUsageTracking();

        // Show usage limit dialog if not shown this session
        if (!_hasShownSubscriptionDialogThisSession) {
          _hasShownSubscriptionDialogThisSession = true;
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              showUsageLimitDialog(context);
            }
          });
        }
      }
    });

    print('🟢 FORCE started usage tracking timer');
  }

  void _startUsageTracking() async {
    // Timer will NOT run if: 3 days have not passed OR user is subscribed
    if (_isSubscribed) {
      print('🚫 Timer will NOT run: User is subscribed (isSubscribed = true)');
      return; // No need to track for subscribers
    }

    // Check if 3-day trial period has ended
    bool trialEnded = await preferenceService.hasTrialEnded();
    if (!trialEnded) {
      print(
          '🚫 Timer will NOT run: 3 days have not passed (trialEnded = false)');
      return; // No need to track during trial period
    }

    print(
        '✅ Timer WILL run: 3 days passed AND user not subscribed (trialEnded=$trialEnded && isSubscribed=$_isSubscribed)');

    // Check if timer is already running
    if (_usageTimer != null && _usageTimer!.isActive) {
      print('⚠️ Usage timer already running, skipping start');
      return;
    }

    // Check if usage is paused (30-day cooldown)
    bool isPaused = await preferenceService.isUsagePaused();
    if (isPaused) {
      int remainingDays = await preferenceService.getRemainingPauseDays();
      print('⏸️ Usage is paused, $remainingDays days remaining');
      return;
    }

    print(
        '🟢 Starting usage tracking - _isSubscribed: $_isSubscribed, trial ended: $trialEnded');
    _lastActiveTime = DateTime.now();
    _isTimerActive = true;

    // Create a timer that fires every second
    _usageTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!_isTimerActive || !mounted) {
        timer.cancel();
        return;
      }

      _usageSeconds++;
      print('⏱️ Usage seconds: $_usageSeconds');

      // Update UI every second for smooth progress
      if (mounted) {
        await _updateRemainingUsageTime();
      }

      // Every 10 seconds, record the usage time
      if (_usageSeconds % 10 == 0) {
        await preferenceService.recordUsageTime(10);

        // Check remaining time for warnings and limits
        int remainingTime = await preferenceService.getRemainingUsageTime();

        // Check if user is in the 80-90% usage range (18-36 seconds remaining)
        if (!_hasShownWarningDialog &&
            remainingTime > 0 &&
            remainingTime <= 36 &&
            remainingTime >= 18) {
          _hasShownWarningDialog = true;
          if (mounted) {
            showUsageWarningDialog(context);
          }
        }

        // Check if we've exceeded the monthly limit
        bool hasRemainingTime = await preferenceService.hasRemainingUsageTime();
        if (!hasRemainingTime && !_hasShownSubscriptionDialogThisSession) {
          // Check if we can show the dialog today (once per day limit)
          bool canShowToday =
              await preferenceService.canShowTrialLimitDialogToday();

          if (canShowToday && !_hasShownSubscriptionDialogThisSession) {
            // Start the 30-day pause
            await preferenceService.startUsagePause();

            // Mark dialog as shown today
            await preferenceService.markTrialLimitDialogShownToday();

            _pauseUsageTracking();
            _hasShownSubscriptionDialogThisSession = true;
            if (mounted) {
              showUsageLimitDialog(context);
            }
          } else {
            print('⏰ Trial limit dialog already shown today, skipping');
            // Still pause usage tracking even if dialog not shown
            await preferenceService.startUsagePause();
            _pauseUsageTracking();
            _hasShownSubscriptionDialogThisSession = true;
          }

          // Log the event
          await analytics.logEvent(
            name: 'event_usage_limit_reached',
            parameters: {
              'os': Platform.isAndroid ? 'android' : 'ios',
              'timestamp': DateTime.now().toIso8601String(),
              'usage_seconds': _usageSeconds.toString(),
            },
          );
        }
      }
    });
  }

  // Pause the usage tracking
  void _pauseUsageTracking() {
    print('⏸️ Pausing usage tracking...');
    _isTimerActive = false;

    // Cancel the usage timer if it's running
    if (_usageTimer != null && _usageTimer!.isActive) {
      _usageTimer!.cancel();
      print('✅ Usage timer cancelled');
    }

    // Record the final seconds since last checkpoint
    if (_lastActiveTime != null) {
      final now = DateTime.now();
      final secondsSinceLastActive = now.difference(_lastActiveTime!).inSeconds;
      if (secondsSinceLastActive > 0 && secondsSinceLastActive < 10) {
        preferenceService.recordUsageTime(secondsSinceLastActive);
      }
    }
  }

  // Resume the usage tracking
  void _resumeUsageTracking() async {
    // Timer will NOT run if: 3 days have not passed OR user is subscribed
    if (_isSubscribed) {
      print('🚫 Resume blocked: User is subscribed (isSubscribed = true)');
      return; // No need to track for subscribers
    }

    // Check if 3-day trial period has ended
    bool trialEnded = await preferenceService.hasTrialEnded();
    if (!trialEnded) {
      print('🚫 Resume blocked: 3 days have not passed (trialEnded = false)');
      return; // No need to track during trial period
    }

    // Check if timer is already running
    if (_usageTimer != null && _usageTimer!.isActive) {
      print('⚠️ Usage timer already running, skipping resume');
      return;
    }

    print('▶️ Resuming usage tracking...');
    _lastActiveTime = DateTime.now();
    _isTimerActive = true;

    // Restart the usage tracking timer
    _startUsageTracking();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('📱 didChangeDependencies called');
    _debugTimerStatus();
    // Timer will NOT run if: 3 days have not passed OR user is subscribed
    _startUsageTracking();
  }

  // Debug method to check timer status
  void _debugTimerStatus() {
    print('🔍 Timer Status:');
    print(
        '  - Usage Timer: ${_usageTimer?.isActive ?? false ? "ACTIVE" : "INACTIVE"}');
    print(
        '  - Display Timer: ${_usageDisplayTimer?.isActive ?? false ? "ACTIVE" : "INACTIVE"}');
    print('  - Timer Active Flag: $_isTimerActive');
    print('  - Usage Seconds: $_usageSeconds');
  }

  // Add this method to handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App has been resumed from background
      _resumeUsageTracking();

      // Check subscription status again but don't reset the dialog flag
      // This ensures the dialog only shows once per app session
      checkSubscriptionStatus();
    } else if (state == AppLifecycleState.paused) {
      // App is going to background
      _pauseUsageTracking();
    }
  }
}

class LoadingDialog {
  static bool isShowing = false;
  static bool isImagePickerCalled = false;
  static bool isAlreadyCancelled = false;

  static void show(BuildContext context, {String? message}) {
    if (isAlreadyCancelled) {
      isAlreadyCancelled = false;
      return;
    }

    isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(
                    message ?? AppLocalizations.of(context)!.creatingPdfMessage,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context, {bool isImagePickerCalled = false}) {
    Navigator.of(context, rootNavigator: true).pop(); // Closes the dialog
  }
}

// Function to show an AlertDialog for permissions
void _showPermissionDialog(BuildContext context, String message,
    {bool openSettings = false}) {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.permissionRequired),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(l10n.cancelButton),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          if (openSettings)
            TextButton(
              child: Text(l10n.openSettingsButton), // Text("Open Settings"),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
        ],
      );
    },
  );
}

void showTrialLimitDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Image.asset(
                'assets/images/premium.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 15),
            Text(
              textAlign: TextAlign.center,
              l10n!.freeTrialExpiredMessage,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF173F5A),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.justify,
              l10n.freeFeatureRenewal,
              // textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.justify,
              '${l10n.upgradePrompt}',
              // textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF173F5A),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("${l10n.cancelButton}",
                style: FlutterFlowTheme.of(context).displayMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    )),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to subscription page
              Navigator.pop(context);
              context.pushNamed('Subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF173F5A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("${l10n.subscribeNowButton}",
                style: FlutterFlowTheme.of(context).displayMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    )),
          ),
        ],
      );
    },
  );
}

void showDay2Dialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Image.asset(
                'assets/images/premium.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 15),
            Text(
              textAlign: TextAlign.center,
              l10n!.likingTheApp,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF173F5A),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              l10n!.likingTheAppMessage,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              l10n!.maybeLatr,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pushNamed('Subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF173F5A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              l10n!.getLifetimeAccess,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      );
    },
  );
}

void showDay4Dialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Image.asset(
                'assets/images/premium.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 15),
            Text(
              textAlign: TextAlign.center,
              l10n!.stillEnjoyingIt,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF173F5A),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              l10n!.stillEnjoyingItMessage,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              l10n!.notNow,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pushNamed('Subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF173F5A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              l10n!.upgradeForever,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      );
    },
  );
}

void showUsageLimitDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Text(
            textAlign: TextAlign.center,
            l10n.monthlyUsageLimitReached,
            style: FlutterFlowTheme.of(context).displayMedium.override(
                  fontFamily: 'Poppins',
                  color: Color(0xFF173F5A),
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.monthlyUsageLimitDescription,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              l10n.unlockUnlimitedUsageWithSubscription,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(l10n.laterButton),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to subscription page
              Navigator.pop(context);
              context.pushNamed('Subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF173F5A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(l10n.subscribeNowButton,
                style: FlutterFlowTheme.of(context).displayMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    )),
          ),
        ],
      );
    },
  );
}

void showFilenameErrorDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.invalidFilename),
        content: Text('${l10n.filenameCannotContainCharacters}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('${l10n.ok}'),
          ),
        ],
      );
    },
  );
}

void showUsageWarningDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    barrierDismissible: true, // User can dismiss by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Image.asset(
                'assets/images/premium.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 15),
            Text(
              textAlign: TextAlign.center,
              l10n!.likingTheApp,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF173F5A),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              l10n!.likingTheAppMessage,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              l10n!.later,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to subscription page
              Navigator.pop(context);
              context.pushNamed('Subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF173F5A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              l10n!.upgradeNowButton,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      );
    },
  );
}
