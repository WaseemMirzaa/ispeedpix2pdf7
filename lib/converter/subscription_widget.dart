import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:ispeedpix2pdf7/app_globals.dart';
import 'package:ispeedpix2pdf7/helper/log_helper.dart';
import 'package:ispeedpix2pdf7/screens/preview_pdf_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../custom_code/actions/pdf_multi_img.dart';
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

class SubscriptionWidget extends StatefulWidget {
  const SubscriptionWidget({super.key});

  @override
  State<SubscriptionWidget> createState() => _ConverterWidgetState();
}

class _ConverterWidgetState extends State<SubscriptionWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  AppLocalizations? l10n;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Offerings? offerings;
  bool _isSubscribed = false;
  CustomerInfo? _customerInfo;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

    try {
      getSubscriptionsData(null);
    } catch (e) {
      LogHelper.logMessage('Subscription Error', e);
    }

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

    // getSubscriptionsData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeSetState(() {});

      // Ensure that no text field is focused when the app starts
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 30.0,
            ),
          ),
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
                        width: 160.0,
                        height: 160.0,
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
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              // color: const Color(0xFF8ca9cf),
                              ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(color: borderColor, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    if (_isSubscribed)
                                      Text(
                                        _isSubscribed
                                            ? l10n!.currentPlanFullAccess
                                            :
                                            // 'Current Plan : Full Access'
                                            l10n!.currentPlanFreeTrial
                                        // 'Current Plan : Free Trial'
                                        ,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color: _isSubscribed
                                                  ? Colors.green
                                                  : Colors.black,
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RichText(
                                        textScaler:
                                            MediaQuery.of(context).textScaler,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${l10n!.freeTrialOneWeekUnlimitedUse}\n\n',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${l10n!.freeVersionTrialAfterTrialExpires}\n\n',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                            ),
                                            TextSpan(
                                              text: l10n!
                                                  .threeMinutesUsagePerMonth,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: l10n!.usageTimeResetMonthly,
                                              style: TextStyle(),
                                            ),
                                            // TextSpan(
                                            //   text: l10n!
                                            //       .createUpToFivePDFsEverySevenDays,
                                            //   // ' ✔ Create up to 5 PDFs every 7 days\n',
                                            //   style: TextStyle(
                                            //     fontSize: 14.0,
                                            //   ),
                                            // ),
                                            // TextSpan(
                                            //   text: l10n!
                                            //       .eachPDFCanHaveUpToThreePages,
                                            //   // ' ✔ Each PDF can have up to 3 pages\n',
                                            //   style: TextStyle(),
                                            // ),
                                            // TextSpan(
                                            //   text:
                                            //       l10n!.autoResetEverySevenDays,
                                            //   // ' ✔ Auto-reset every 7 days',
                                            //   style: TextStyle(),
                                            // ),
                                            TextSpan(
                                              text: l10n!
                                                  .oneTimePurchaseUnlockFullAccess,
                                              // '\n\nOne Time Purchase (Unlock Full Access)\n\n',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                            ),
                                            TextSpan(
                                              text: l10n!.unlimitedPDFCreation,

                                              // ' ✔ Unlimited PDF creation\n',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: l10n!
                                                  .singlePurchaseLifetimeAccess,

                                              // ' ✔ A single purchase for lifetime access\n\n',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: l10n!
                                                  .upgradeTodayToUnlockCompletePotential,
                                              // 'Upgrade today to unlock the complete potential of iSpeedPix2Pdf with a lifetime subscription 🚀',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                            ),
                                          ],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _isSubscribed,
                                      child: Align(
                                        alignment: const AlignmentDirectional(
                                            0.0, 0.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 8.0, 8.0, 0.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              // _cancelSubscription();
                                              Navigator.of(context).pop();
                                            },
                                            text: l10n!.enjoyFullAccess,
                                            // 'Enjoy Your Full Access'
                                            // ,
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 50.0,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                              color: Colors.green,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleLarge
                                                  .override(
                                                    fontFamily: 'Readex Pro',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .info,
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 0.0,
                                              borderSide: const BorderSide(
                                                color: Colors.green,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (Platform.isIOS && !_isSubscribed)
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            0.0, 0.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 8.0, 8.0, 0.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              LoadingDialog.show(context,
                                                  message: l10n!
                                                      .checkingActivePurchase);
                                              try {
                                                await checkAndRestorePurchases();
                                                // await getSubscriptionsData();
                                              } catch (_) {
                                                // LoadingDialog.hide(context);
                                              }
                                            },
                                            text: l10n!
                                                .alreadyPurchasedRestoreHere,
                                            // 'Already Purchased? Restore Here',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 50.0,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              iconPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                              color: const Color(0xFF173F5A),
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleLarge
                                                  .override(
                                                    fontFamily: 'Readex Pro',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .info,
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 0.0,
                                              borderSide: const BorderSide(
                                                color: Color(0xFF173F5A),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible: _isSubscribed,
                      //   child: Align(
                      //     alignment: const AlignmentDirectional(0.0, 0.0),
                      //     child: Padding(
                      //       padding: const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                      //       child: FFButtonWidget(
                      //         onPressed: () async {
                      //           // _cancelSubscription();
                      //         },
                      //         text: 'Enjoy Your Full Access',
                      //         options: FFButtonOptions(
                      //           width: double.infinity,
                      //           height: 50.0,
                      //           padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      //           iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      //           color:  Colors.green,
                      //           textStyle: FlutterFlowTheme.of(context).titleLarge.override(
                      //                 fontFamily: 'Readex Pro',
                      //                 color: FlutterFlowTheme.of(context).info,
                      //                 fontSize: 18.0,
                      //                 letterSpacing: 0.0,
                      //               ),
                      //           elevation: 0.0,
                      //           borderSide: const BorderSide(
                      //             color: Colors.green,
                      //             width: 2.0,
                      //           ),
                      //           borderRadius: BorderRadius.circular(8.0),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Visibility(
                        visible: !_isSubscribed,
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 16.0, 8.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await analytics.logEvent(
                                  name: 'event_on_buy_now_button_purchased',
                                  parameters: {
                                    'os':
                                        Platform.isAndroid ? 'android' : 'ios',
                                    'timestamp':
                                        DateTime.now().toIso8601String(),
                                    // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
                                  },
                                );
                                var offering =
                                    offerings?.getOffering('sub_lifetime');

                                if (offering != null) {
                                  try {
                                    var customerInfo =
                                        await Purchases.purchaseStoreProduct(
                                            offering.availablePackages[0]
                                                .storeProduct);

                                    getSubscriptionsData(
                                      'event_on_subscription_purchased',
                                    );

                                    LogHelper.logSuccessMessage(
                                        'Purchase Package', customerInfo);

                                    // getSubscriptionsData();
                                  } catch (e) {
                                    LogHelper.logErrorMessage(
                                        'Subscription Purchase Error ', e);
                                  }

                                  // offering
                                }
                              },
                              text: l10n!.buyNowInFourNineNine,
                              // 'Buy Now in 1.99\$'
                              // ,
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: const Color(0xFF173F5A),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: const BorderSide(
                                  color: Color(0xFF173F5A),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
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
      ),
    );
  }

  Future<void> checkAndRestorePurchases() async {
    try {
      _customerInfo = await Purchases.restorePurchases();

      // Check if restoration was successful by verifying entitlements
      final hasActiveEntitlement =
          _customerInfo?.entitlements.all['sub_lifetime']?.isActive ?? false;

      LoadingDialog.hide(context);

      if (hasActiveEntitlement) {
        await analytics.logEvent(
          name: 'event_on_subscription_restored',
          parameters: {
            'os': Platform.isAndroid ? 'android' : 'ios',
            'timestamp': DateTime.now().toIso8601String(),
            // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
          },
        );

        setState(() {
          _isSubscribed = true;
        });

        // Show success alert
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(l10n!.success),
              content: Text(l10n!.yourPurchaseHasBeenSuccessfullyRestored),
              actions: [
                TextButton(
                  child: Text(l10n!.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show no purchases found alert
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(l10n!.noPurchasesFound),
              content: Text(l10n!.weCouldNotFindAnyPreviousPurchasesToRestore),
              actions: [
                TextButton(
                  child: Text(l10n!.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Show error alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(l10n!.error),
            content: Text(l10n!.failedToRestorePurchasesPleaseTryAgainLater),
            actions: [
              TextButton(
                child: Text(l10n!.ok),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      LogHelper.logErrorMessage('Restore Purchase Error', e);
    }
  }

  // Method to cancel the subscription
  Future<void> _cancelSubscription() async {
    // try {

    var hasActiveEntitlements =
        _customerInfo?.entitlements.active.isNotEmpty ?? false;

    if (hasActiveEntitlements) {
      await Purchases.setAttributes({'subscription_status': 'canceled'});

      print("Subscription marked as canceled.");

      // var activeEntitlement = _customerInfo!.entitlements.active[0];
      //
      // await _openSubscriptionManagementPage();
    }
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
            await analytics.logEvent(
              name: 'event_on_subscription_restored',
              parameters: {
                'os': Platform.isAndroid ? 'android' : 'ios',
                'timestamp': DateTime.now().toIso8601String(),
                // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
              },
            );
            setState(() {
              // isPurchased = true;
              _isSubscribed = true;
            });
            LogHelper.logMessage('Receipt Status', 'Receipt found on device');
            LogHelper.logMessage('Receipt Data',
                '${receipt.substring(0, min(50, receipt.length))}...');

            // First try production URL
            final prodResponse = await _verifyReceipt(receipt, false);
            if (prodResponse != null && prodResponse['status'] == 0) {
              await analytics.logEvent(
                name: 'event_on_subscription_restored',
                parameters: {
                  'os': Platform.isAndroid ? 'android' : 'ios',
                  'timestamp': DateTime.now().toIso8601String(),
                  // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
                },
              );
              setState(() {
                // isPurchased = true;
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

  // Open the subscription management page in the App Store
  Future<void> _openSubscriptionManagementPage() async {
    var url = "https://apps.apple.com/account/subscriptions";

    if (AppGlobals.subscriptionType == SubscriptionType.sandbox) {}
    url = 'itms-apps://sandbox.itunes.apple.com/account/subscriptions';

    print(LogHelper.logMessage('Url', url));

    if (await canLaunch(url)) {
      await launch(url);

      getSubscriptionsData(null);
    } else {
      print('Could not open the subscription management page.');
    }
  }

  Future<void> getSubscriptionsData(String? message) async {
    _customerInfo = await Purchases.getCustomerInfo();

    offerings = await Purchases.getOfferings();
    var offering = offerings?.getOffering('sub_lifetime');

    LogHelper.logSuccessMessage('Customer Info', _customerInfo);

    LogHelper.logSuccessMessage('Offerings', offerings);

    if (_customerInfo?.entitlements.all['sub_lifetime'] != null &&
        _customerInfo?.entitlements.all['sub_lifetime']?.isActive == true) {
      // User has subscription, show them the featureGet lifetime access to iSpeedScan with a one-time purchase & unlock its full power today 🚀
      await analytics.logEvent(
        name: message ?? 'event_on_subscription_already_purchased',
        parameters: (message != null)
            ? {
                'price': offering?.availablePackages[0].storeProduct.price
                    .toString(),
                'currencyCode':
                    offering?.availablePackages[0].storeProduct.currencyCode,
                'os': Platform.isAndroid ? 'android' : 'ios',
                'timestamp': DateTime.now().toIso8601String(),
                // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
              }
            : {
                'os': Platform.isAndroid ? 'android' : 'ios',
                'timestamp': DateTime.now().toIso8601String(),
                // 'selectedFileCount': selectedUploadedFiles!.length.toString(),
              },
      );
      setState(() {
        _isSubscribed = true;
      });
    } else {
      _isSubscribed = false;
      setState(() {});

      // _shouldShowPurchaseButton = true;

      // _shouldShowPurchaseButton = true;
      checkPreviousAppPurchase();

      // Show the Paywall
    }
  }
}

class LoadingDialog {
  static bool isShowing = false;
  static bool isImagePickerCalled = false;
  static bool isAlreadyCancelled = false;

  static void show(BuildContext context, {String message = "Creating PDF..."}) {
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
                Text(message, style: const TextStyle(fontSize: 16)),
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
              child: Text(l10n.openSettingsButton),
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
