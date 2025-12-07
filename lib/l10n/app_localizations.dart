import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get rest;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'iSpeedPix2PDF'**
  String get appTitle;

  /// No description provided for @defaultMixedOrientation.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT - Mixed Orientation'**
  String get defaultMixedOrientation;

  /// No description provided for @pagesFixedPortrait.
  ///
  /// In en, this message translates to:
  /// **'Pages Fixed - Portrait'**
  String get pagesFixedPortrait;

  /// No description provided for @landscapePhotosTopAlignedForEasyViewing.
  ///
  /// In en, this message translates to:
  /// **'Landsape Photos - Top Aligned for easy viewing'**
  String get landscapePhotosTopAlignedForEasyViewing;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @chooseFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose Files'**
  String get chooseFiles;

  /// No description provided for @noFilesSelected.
  ///
  /// In en, this message translates to:
  /// **'No Files Selected'**
  String get noFilesSelected;

  /// No description provided for @youCanSelectUpTo3ImagesInFreeVersion.
  ///
  /// In en, this message translates to:
  /// **'*You can select up to 3 Images in free version'**
  String get youCanSelectUpTo3ImagesInFreeVersion;

  /// No description provided for @youCanSelectUpTo60Images.
  ///
  /// In en, this message translates to:
  /// **'*You can select up to 60 Images'**
  String get youCanSelectUpTo60Images;

  /// No description provided for @filename.
  ///
  /// In en, this message translates to:
  /// **'Filename'**
  String get filename;

  /// No description provided for @filenameOptional.
  ///
  /// In en, this message translates to:
  /// **'Filename (Optional)'**
  String get filenameOptional;

  /// No description provided for @enterCustomFileNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Enter custom file name (optional)'**
  String get enterCustomFileNameOptional;

  /// No description provided for @filenameCannotContainCharacters.
  ///
  /// In en, this message translates to:
  /// **'Filename cannot contain any of the following characters: \\ /: * ? \" < > |'**
  String get filenameCannotContainCharacters;

  /// No description provided for @downloadPDF.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPDF;

  /// No description provided for @viewPdf.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get viewPdf;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @getFullLifetimeAccess.
  ///
  /// In en, this message translates to:
  /// **'Get Full Lifetime Access in 1.99'**
  String get getFullLifetimeAccess;

  /// No description provided for @viewPurchaseDetails.
  ///
  /// In en, this message translates to:
  /// **'View Purchase Details'**
  String get viewPurchaseDetails;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection:'**
  String get dataCollection;

  /// No description provided for @invalidFilename.
  ///
  /// In en, this message translates to:
  /// **'Invalid Filename'**
  String get invalidFilename;

  /// No description provided for @freeFeatureRenewal.
  ///
  /// In en, this message translates to:
  /// **'FREE FEATURES RENEW EVERY 3 DAYS'**
  String get freeFeatureRenewal;

  /// No description provided for @upgradePrompt.
  ///
  /// In en, this message translates to:
  /// **'UPGRADE NOW WITH A ONE TIME PURCHASE & UNLOCK THE FULL POWER OF iSpeedPix2PDF 🚀.'**
  String get upgradePrompt;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @rateAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate this app'**
  String get rateAppTitle;

  /// No description provided for @rateAppMessage.
  ///
  /// In en, this message translates to:
  /// **'If you enjoy using this app, we\'d really appreciate it if you could take a minute to leave a review! Your feedback helps us improve and won\'t take more than a minute of your time.'**
  String get rateAppMessage;

  /// No description provided for @rateButton.
  ///
  /// In en, this message translates to:
  /// **'RATE'**
  String get rateButton;

  /// No description provided for @noThanksButton.
  ///
  /// In en, this message translates to:
  /// **'NO THANKS'**
  String get noThanksButton;

  /// No description provided for @maybeLaterButton.
  ///
  /// In en, this message translates to:
  /// **'MAYBE LATER'**
  String get maybeLaterButton;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @trialLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Trial Limit Reached'**
  String get trialLimitReached;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @creatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Creating PDF'**
  String get creatingPdf;

  /// No description provided for @loadingImagesInProgress.
  ///
  /// In en, this message translates to:
  /// **'Loading Images'**
  String get loadingImagesInProgress;

  /// No description provided for @subscriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Subscription Required'**
  String get subscriptionRequired;

  /// No description provided for @subscriptionMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please subscribe to continue using all features'**
  String get subscriptionMessageRequired;

  /// No description provided for @subscribeNowButton.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNowButton;

  /// No description provided for @restorePurchaseButton.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get restorePurchaseButton;

  /// No description provided for @purchaseRestoredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Purchase Restored Successfully'**
  String get purchaseRestoredSuccessfully;

  /// No description provided for @purchaseRestoreFailedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to Restore Purchase'**
  String get purchaseRestoreFailedError;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage Permission Required'**
  String get storagePermissionRequired;

  /// No description provided for @storagePermissionMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'This app needs storage permission to save PDFs'**
  String get storagePermissionMessageRequired;

  /// No description provided for @grantPermissionButton.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermissionButton;

  /// No description provided for @openSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettingsButton;

  /// No description provided for @permissionDeniedError.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionDeniedError;

  /// No description provided for @errorWhileCreatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error While Creating PDF'**
  String get errorWhileCreatingPdf;

  /// No description provided for @errorWhileSavingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error Saving PDF'**
  String get errorWhileSavingPdf;

  /// No description provided for @errorWhileLoadingImages.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Images'**
  String get errorWhileLoadingImages;

  /// No description provided for @pdfCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF Created Successfully'**
  String get pdfCreatedSuccessfully;

  /// No description provided for @pdfSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF Saved Successfully'**
  String get pdfSavedSuccessfully;

  /// No description provided for @tryAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainButton;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @savingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingInProgress;

  /// No description provided for @downloadingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloadingInProgress;

  /// No description provided for @invalidFileTypeError.
  ///
  /// In en, this message translates to:
  /// **'Invalid file type'**
  String get invalidFileTypeError;

  /// No description provided for @maxFileSizeExceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum file size exceeded'**
  String get maxFileSizeExceeded;

  /// No description provided for @maxImagesLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of images reached'**
  String get maxImagesLimitReached;

  /// No description provided for @trialLimitMessageReached.
  ///
  /// In en, this message translates to:
  /// **'You have reached the trial limit. Please subscribe to continue using all features.'**
  String get trialLimitMessageReached;

  /// No description provided for @freeVersionLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Free version is limited to {count} PDFs'**
  String freeVersionLimitReached(Object Count, Object count);

  /// No description provided for @imageQualityHighOption.
  ///
  /// In en, this message translates to:
  /// **'High Quality (90%)'**
  String get imageQualityHighOption;

  /// No description provided for @imageQualityMediumOption.
  ///
  /// In en, this message translates to:
  /// **'Medium Quality (70%)'**
  String get imageQualityMediumOption;

  /// No description provided for @imageQualityLowOption.
  ///
  /// In en, this message translates to:
  /// **'Low Quality (50%)'**
  String get imageQualityLowOption;

  /// No description provided for @orientationDefaultOption.
  ///
  /// In en, this message translates to:
  /// **'Default Orientation'**
  String get orientationDefaultOption;

  /// No description provided for @orientationPortraitOption.
  ///
  /// In en, this message translates to:
  /// **'Force Portrait'**
  String get orientationPortraitOption;

  /// No description provided for @orientationLandscapeOption.
  ///
  /// In en, this message translates to:
  /// **'Force Landscape'**
  String get orientationLandscapeOption;

  /// No description provided for @orientationMixedOption.
  ///
  /// In en, this message translates to:
  /// **'Mixed Orientation'**
  String get orientationMixedOption;

  /// No description provided for @unsupportedFileFormatError.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file format'**
  String get unsupportedFileFormatError;

  /// No description provided for @supportedFormatsMessage.
  ///
  /// In en, this message translates to:
  /// **'Supported formats: JPG, PNG, HEIC'**
  String get supportedFormatsMessage;

  /// No description provided for @shareViaButton.
  ///
  /// In en, this message translates to:
  /// **'Share via'**
  String get shareViaButton;

  /// No description provided for @sharePdfButton.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get sharePdfButton;

  /// No description provided for @enjoyingAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Enjoying iSpeedPix2PDF?'**
  String get enjoyingAppMessage;

  /// No description provided for @rateAppStoreButton.
  ///
  /// In en, this message translates to:
  /// **'Rate on App Store'**
  String get rateAppStoreButton;

  /// No description provided for @ratePlayStoreButton.
  ///
  /// In en, this message translates to:
  /// **'Rate on Play Store'**
  String get ratePlayStoreButton;

  /// No description provided for @sendFeedbackButton.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedbackButton;

  /// No description provided for @preparingImagesInProgress.
  ///
  /// In en, this message translates to:
  /// **'Preparing Images...'**
  String get preparingImagesInProgress;

  /// No description provided for @optimizingImagesInProgress.
  ///
  /// In en, this message translates to:
  /// **'Optimizing Images...'**
  String get optimizingImagesInProgress;

  /// No description provided for @generatingPdfInProgress.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdfInProgress;

  /// No description provided for @almostDoneMessage.
  ///
  /// In en, this message translates to:
  /// **'Almost Done...'**
  String get almostDoneMessage;

  /// No description provided for @unlockFeatureButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock This Feature'**
  String get unlockFeatureButton;

  /// No description provided for @premiumFeatureMessage.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeatureMessage;

  /// No description provided for @upgradeToUnlockMessage.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to unlock all features'**
  String get upgradeToUnlockMessage;

  /// No description provided for @weDoNotCollectAnyPersonalData.
  ///
  /// In en, this message translates to:
  /// **' We do not collect, store, or process any personal data from users. All data is handled locally on your device. This means'**
  String get weDoNotCollectAnyPersonalData;

  /// No description provided for @noImagesAreShared.
  ///
  /// In en, this message translates to:
  /// **'No images are uploaded to a server.\n- No personal data is collected, stored, or shared by our mobile app.'**
  String get noImagesAreShared;

  /// No description provided for @filesSelected.
  ///
  /// In en, this message translates to:
  /// **'Files Selected'**
  String get filesSelected;

  /// No description provided for @rateThisApp.
  ///
  /// In en, this message translates to:
  /// **'Rate this app'**
  String get rateThisApp;

  /// No description provided for @rateThisAppMessage.
  ///
  /// In en, this message translates to:
  /// **'If you enjoy using this app, would really appreciate it if you could take a minute to leave a review! Your feedback helps us improve and won’t take more than a minute of your time.'**
  String get rateThisAppMessage;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'RATE'**
  String get rate;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'NO THANKS'**
  String get noThanks;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'MAYBE LATER'**
  String get maybeLater;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @freeTrialExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'FREE TRIAL EXPIRED or FREE FEATURES EXHAUSTED'**
  String get freeTrialExpiredMessage;

  /// No description provided for @upgradeNowButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNowButton;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get howToUse;

  /// No description provided for @simplicityAndEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Simplicity and Efficiency'**
  String get simplicityAndEfficiency;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Security'**
  String get privacyAndSecurity;

  /// No description provided for @moreAppsByTevinEighDesigns.
  ///
  /// In en, this message translates to:
  /// **'More Apps By Tevin Eigh Designs'**
  String get moreAppsByTevinEighDesigns;

  /// No description provided for @aboutTevinEighDesigns.
  ///
  /// In en, this message translates to:
  /// **'About Tevin Eigh Designs'**
  String get aboutTevinEighDesigns;

  /// No description provided for @returnToConverter.
  ///
  /// In en, this message translates to:
  /// **'Return to Converter'**
  String get returnToConverter;

  /// No description provided for @currentPlanFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Current Plan: Full Access'**
  String get currentPlanFullAccess;

  /// No description provided for @currentPlanFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Current Plan: Free Trial'**
  String get currentPlanFreeTrial;

  /// No description provided for @freeTrialOneWeekUnlimitedUse.
  ///
  /// In en, this message translates to:
  /// **'FREE TRIAL – 3 Days – Unlimited Use'**
  String get freeTrialOneWeekUnlimitedUse;

  /// No description provided for @freeVersionTrialAfterTrialExpires.
  ///
  /// In en, this message translates to:
  /// **'FREE VERSION – After Trial Expires'**
  String get freeVersionTrialAfterTrialExpires;

  /// No description provided for @createUpToFivePDFsEverySevenDays.
  ///
  /// In en, this message translates to:
  /// **'✔ Create up to 5 PDFs every 3 days\n'**
  String get createUpToFivePDFsEverySevenDays;

  /// No description provided for @eachPDFCanHaveUpToThreePages.
  ///
  /// In en, this message translates to:
  /// **'✔ Each PDF can have up to 3 pages\n'**
  String get eachPDFCanHaveUpToThreePages;

  /// No description provided for @autoResetEverySevenDays.
  ///
  /// In en, this message translates to:
  /// **'✔ Auto-reset every 3 days\n\n'**
  String get autoResetEverySevenDays;

  /// No description provided for @oneTimePurchaseUnlockFullAccess.
  ///
  /// In en, this message translates to:
  /// **'One Time Purchase (Unlock Full Access)\n\n'**
  String get oneTimePurchaseUnlockFullAccess;

  /// No description provided for @adFreeAfterPurchase.
  ///
  /// In en, this message translates to:
  /// **'✔ Ad-free after purchase\n'**
  String get adFreeAfterPurchase;

  /// No description provided for @unlimitedPDFCreation.
  ///
  /// In en, this message translates to:
  /// **'✔ Unlimited PDF creation\n'**
  String get unlimitedPDFCreation;

  /// No description provided for @singlePurchaseLifetimeAccess.
  ///
  /// In en, this message translates to:
  /// **'✔ A single purchase for lifetime access\n\n'**
  String get singlePurchaseLifetimeAccess;

  /// No description provided for @upgradeTodayToUnlockCompletePotential.
  ///
  /// In en, this message translates to:
  /// **'Upgrade today to unlock the complete potential of iSpeedPix2Pdf with a lifetime subscription 🚀'**
  String get upgradeTodayToUnlockCompletePotential;

  /// No description provided for @enjoyFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Enjoy Your Full Access'**
  String get enjoyFullAccess;

  /// No description provided for @checkingActivePurchase.
  ///
  /// In en, this message translates to:
  /// **'Checking Active Purchase'**
  String get checkingActivePurchase;

  /// No description provided for @alreadyPurchasedRestoreHere.
  ///
  /// In en, this message translates to:
  /// **'Already Purchased? Restore Here'**
  String get alreadyPurchasedRestoreHere;

  /// No description provided for @buyNowInFourNineNine.
  ///
  /// In en, this message translates to:
  /// **'Buy Now in 1.99'**
  String get buyNowInFourNineNine;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @yourPurchaseHasBeenSuccessfullyRestored.
  ///
  /// In en, this message translates to:
  /// **'Your purchase has been successfully restored!'**
  String get yourPurchaseHasBeenSuccessfullyRestored;

  /// No description provided for @purchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get purchaseHistory;

  /// No description provided for @noPurchasesFound.
  ///
  /// In en, this message translates to:
  /// **'No purchases found'**
  String get noPurchasesFound;

  /// No description provided for @weCouldNotFindAnyPreviousPurchasesToRestore.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any previous purchases to restore.'**
  String get weCouldNotFindAnyPreviousPurchasesToRestore;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @purchaseAmount.
  ///
  /// In en, this message translates to:
  /// **'Purchase Amount'**
  String get purchaseAmount;

  /// No description provided for @purchaseStatus.
  ///
  /// In en, this message translates to:
  /// **'Purchase Status'**
  String get purchaseStatus;

  /// No description provided for @purchaseId.
  ///
  /// In en, this message translates to:
  /// **'Purchase ID'**
  String get purchaseId;

  /// No description provided for @purchaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Purchase Details'**
  String get purchaseDetails;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failedToRestorePurchasesPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore purchases. Please try again later.'**
  String get failedToRestorePurchasesPleaseTryAgainLater;

  /// No description provided for @howToUseISpeedPix2PDFStepByStep.
  ///
  /// In en, this message translates to:
  /// **'How to Use iSpeedPix2PDF: Step-by-Step'**
  String get howToUseISpeedPix2PDFStepByStep;

  /// No description provided for @howToUsePointOne.
  ///
  /// In en, this message translates to:
  /// **'1. Select Picture\'\'s  \nTap the \'\'Choose Files\'\' button to open your \nphoto gallery\n-Select the photos you want to include in your \nPDF. You can choose multiple images at once\n \n2. Add a File Name (Optional)\n- You can give your PDF a custom file name by tapping the \'\'File Name\'\' field\n- If you don\'\'t provide a name, the app will automatically assign one in the format iSpeedPix2PDF_DATE_TIME\n \n3. View or Download the PDF\n- Download it to save the file (The file is designed \nto be small enough for easy sharing and management)\n- View it directly within the app for a quick look\n \n4. Share the PDF\n- Once saved, you can share the PDF via email, messaging apps, upload it to cloud services, or \nany other sharing option on your device\n- With the PDF saved, you can easily manage, \nedit, and share your scans using the tools you\'\'re already familiar with—streamlining the process for faster, more efficient document handling\n\nThat\'\'s it! You\'\'ve created, viewed, and shared a compact, easily manageable PDF with iSpeedPix2PDF.'**
  String get howToUsePointOne;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// No description provided for @simplicityAndPrivacyDetail.
  ///
  /// In en, this message translates to:
  /// **'Our Philosophy\n-Simplicity: Our apps are designed to be intuitive and straightforward, making them easy to use for everyone.\n\n-Security: By keeping all processing on the client side, we ensure your data remains private and secure.\n-Efficiency: We continually refine our apps to remove unnecessary steps while preserving their core functionality.'**
  String get simplicityAndPrivacyDetail;

  /// No description provided for @simplicityAndPrivacyDetailTwo.
  ///
  /// In en, this message translates to:
  /// **'We believe in providing just what you need, nothing more, nothing less. As we evolve, our commitment remains to enhance efficiency without compromising on the primary purpose of our applications.'**
  String get simplicityAndPrivacyDetailTwo;

  /// No description provided for @simplicityAndPrivacyDetailThree.
  ///
  /// In en, this message translates to:
  /// **'Explore our range of client-side apps and experience the difference simplicity, efficiency, and security can make in your daily tasks.'**
  String get simplicityAndPrivacyDetailThree;

  /// No description provided for @privacyAndSecurityDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to iSpeedPix2PDF. We are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use the iSpeedPix2PDF app on mobile devices.'**
  String get privacyAndSecurityDetailTitle;

  /// No description provided for @privacyAndSecurityDetailOne.
  ///
  /// In en, this message translates to:
  /// **'1. Information Collection and Use - iSpeedPix2PDF is a client-side app; all data processed by the app remains local to your device, with no data sent to external servers for processing.\n-Photo Gallery Access: iSpeedPix2PDF requires access to your device’s photo gallery to allow you to select images for conversion into PDFs.\n-Once a PDF is generated, the app does not store or retain any files. Users have full control over their PDFs and can choose to share, email, save, or upload them as they prefer.'**
  String get privacyAndSecurityDetailOne;

  /// No description provided for @privacyAndSecurityDetailTwo.
  ///
  /// In en, this message translates to:
  /// **'2. No Data Transmission - As a client-side app, iSpeedPix2PDF ensures that none of your data, including personal information or generated PDFs, is transmitted to external servers or third-party services. Every step of the process—from selecting images to generating PDFs—happens entirely on your device, guaranteeing the highest level of privacy and security.'**
  String get privacyAndSecurityDetailTwo;

  /// No description provided for @privacyAndSecurityDetailThree.
  ///
  /// In en, this message translates to:
  /// **'3. One-Time Lifetime Subscription - iSpeedPix2PDF operates on a one-time lifetime subscription model, meaning you only need to pay once for full access to all features—no recurring charges, no hidden fees. Payment processing is handled securely through a service to verify and manage purchases. Once purchased, the app remains fully functional without requiring additional payments.'**
  String get privacyAndSecurityDetailThree;

  /// No description provided for @privacyAndSecurityDetailFour.
  ///
  /// In en, this message translates to:
  /// **'4. No Advertisements - We do not display ads or sell your data. iSpeedPix2PDF is designed to provide a seamless and efficient user experience without interruptions from advertisements. Our focus is on ensuring a simple and secure method for creating and sharing PDFs, completely under your control.'**
  String get privacyAndSecurityDetailFour;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @aboutTevinEighDescription.
  ///
  /// In en, this message translates to:
  /// **'At Tevin Eigh Designs, we specialize in creating client-side apps that solve daily problems with simplicity, efficiency, and security. Our focus is on delivering the core functionality you need with the fewest steps and clicks possible, ensuring you can concentrate on your main tasks without distractions.\n\nOur Philosophy\n-Simplicity: Our apps are designed to be intuitive and straithforward, making them easy to use for everyone.\n-Security: By keeping all processing on the client side, we ensure your data remains private and secure.\n-Efficiency: We continually refine our apps to remove unnecessary steps while preserving their core functionality.\n\nWe Believe in providing just what you need, nothing more, nothing less. As we evolve, our commitment remains to enhance efficiency without compromising on the primary purpose of our applications.\n\nExplore our range of client-side apps and experience the difference simplicity, efficiency, and security can make in your daily tasks.\n\nwww.tevineigh.com\n'**
  String get aboutTevinEighDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Convert images to PDF quickly and easily'**
  String get aboutAppDescription;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @privacyAndSecurityDetailFive.
  ///
  /// In en, this message translates to:
  /// **'5. Privacy Policy - Our apps use Google Firebase for App Store Optimization (ASO) and Search Engine Optimization (SEO) purposes only. We do not collect, sell, or use this information for any other purposes.\n\nFor more information about Google Firebase’s data practices, please refer to their Privacy Policy:'**
  String get privacyAndSecurityDetailFive;

  /// No description provided for @monthlyUsageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Monthly Usage Limit Reached'**
  String get monthlyUsageLimitReached;

  /// No description provided for @monthlyUsageLimitDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used your 3 minutes of free usage time for this month. Your usage time will reset at the beginning of next month.'**
  String get monthlyUsageLimitDescription;

  /// No description provided for @unlockUnlimitedUsageWithSubscription.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited usage time with a one-time purchase of our lifetime subscription.'**
  String get unlockUnlimitedUsageWithSubscription;

  /// No description provided for @laterButton.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get laterButton;

  /// No description provided for @remainingUsageTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining usage time: {minutes} min {seconds} sec'**
  String remainingUsageTime(int minutes, int seconds);

  /// No description provided for @threeMinutesUsagePerMonth.
  ///
  /// In en, this message translates to:
  /// **'✔ 3 minutes of usage time per month\n'**
  String get threeMinutesUsagePerMonth;

  /// No description provided for @usageTimeResetMonthly.
  ///
  /// In en, this message translates to:
  /// **'✔ Usage time resets monthly\n\n'**
  String get usageTimeResetMonthly;

  /// No description provided for @trialTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'Trial Time Left'**
  String get trialTimeLeft;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes}:{seconds} remaining'**
  String remainingTime(int minutes, String seconds);

  /// No description provided for @unlockUnlimitedAccessToday.
  ///
  /// In en, this message translates to:
  /// **'Unlock Unlimited Access Today!'**
  String get unlockUnlimitedAccessToday;

  /// No description provided for @enjoyingFreeTrialUpgradeMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re enjoying the free trial! Why wait? Upgrade now to our lifetime plan and never worry about time limits again. One payment, unlimited usage forever — no subscriptions, no recurring charges!'**
  String get enjoyingFreeTrialUpgradeMessage;

  /// No description provided for @usagePausedThirtyDays.
  ///
  /// In en, this message translates to:
  /// **'Usage Paused (30 Days)'**
  String get usagePausedThirtyDays;

  /// No description provided for @freeTimeExpired.
  ///
  /// In en, this message translates to:
  /// **'Free Time Expired'**
  String get freeTimeExpired;

  /// No description provided for @almostOutOfFreeTime.
  ///
  /// In en, this message translates to:
  /// **'Almost Out of Free Time'**
  String get almostOutOfFreeTime;

  /// No description provided for @usagePausedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your free time is paused for {days} more days. Upgrade to our lifetime plan to get unlimited usage immediately — no recurring charges, no subscriptions.'**
  String usagePausedMessage(int days);

  /// No description provided for @freeTimeExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'⏰ Time\'s up! But your journey continues...🌟 Upgrade to Premium and scan without limits! Join thousands of users who\'ve unlocked their full potential.'**
  String get freeTimeExpiredMessage;

  /// No description provided for @almostOutOfFreeTimeMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re almost out of free time this month! Upgrade to our lifetime plan with a single one-time payment — no recurring charges, no subscriptions. Get unlimited usage forever.'**
  String get almostOutOfFreeTimeMessage;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @likingTheApp.
  ///
  /// In en, this message translates to:
  /// **'Liking the App?'**
  String get likingTheApp;

  /// No description provided for @likingTheAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Liking the app? Get lifetime access today with a single one-time payment — no recurring charges, no subscriptions. Unlock unlimited usage forever!'**
  String get likingTheAppMessage;

  /// No description provided for @maybeLatr.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLatr;

  /// No description provided for @getLifetimeAccess.
  ///
  /// In en, this message translates to:
  /// **'Get Lifetime Access'**
  String get getLifetimeAccess;

  /// No description provided for @stillEnjoyingIt.
  ///
  /// In en, this message translates to:
  /// **'Still Enjoying It?'**
  String get stillEnjoyingIt;

  /// No description provided for @stillEnjoyingItMessage.
  ///
  /// In en, this message translates to:
  /// **'Still enjoying it? Upgrade now and keep access forever with our lifetime plan — one payment, no subscriptions, unlimited usage for life!'**
  String get stillEnjoyingItMessage;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @upgradeForever.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Forever'**
  String get upgradeForever;

  /// No description provided for @almostOutOfFreeTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Almost Out of Free Time'**
  String get almostOutOfFreeTimeTitle;

  /// No description provided for @almostOutOfFreeTimeWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re almost out of free time this month! Upgrade to our lifetime plan with a single one-time payment — no recurring charges, no subscriptions. Get unlimited usage forever.'**
  String get almostOutOfFreeTimeWarningMessage;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNow;

  /// No description provided for @creatingPdfMessage.
  ///
  /// In en, this message translates to:
  /// **'Creating PDF...'**
  String get creatingPdfMessage;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @sessionTime.
  ///
  /// In en, this message translates to:
  /// **'session time'**
  String get sessionTime;

  /// No description provided for @usePromoCode.
  ///
  /// In en, this message translates to:
  /// **'Use Promo Code'**
  String get usePromoCode;

  /// No description provided for @enterPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Promo Code'**
  String get enterPromoCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @invalidPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid Promo Code'**
  String get invalidPromoCode;

  /// No description provided for @promoCodeAppliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Promo Code Applied Successfully!'**
  String get promoCodeAppliedSuccessfully;

  /// No description provided for @promoCode.
  ///
  /// In en, this message translates to:
  /// **'Promo Code'**
  String get promoCode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'he',
    'hi',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'th',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
