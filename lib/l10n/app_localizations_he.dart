// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get rest => 'איפוס';

  @override
  String get appTitle => 'iSpeedPix2PDF';

  @override
  String get defaultMixedOrientation => 'ברירת מחדל - תצוגה מעורבת';

  @override
  String get pagesFixedPortrait => 'עמודים קבועים - לאורך';

  @override
  String get landscapePhotosTopAlignedForEasyViewing =>
      'תמונות לרוחב - מיושרות למעלה לצפייה נוחה';

  @override
  String get reset => 'איפוס';

  @override
  String get chooseFiles => 'בחר קבצים';

  @override
  String get noFilesSelected => 'לא נבחרו קבצים';

  @override
  String get youCanSelectUpTo3ImagesInFreeVersion =>
      '*ניתן לבחור עד 3 תמונות בגרסה החינמית';

  @override
  String get youCanSelectUpTo60Images => '*ניתן לבחור עד 60 תמונות';

  @override
  String get filename => 'שם קובץ';

  @override
  String get filenameOptional => 'שם קובץ (אופציונלי)';

  @override
  String get enterCustomFileNameOptional =>
      'הזן שם קובץ מותאם אישית (אופציונלי)';

  @override
  String get filenameCannotContainCharacters =>
      'שם הקובץ לא יכול להכיל את התווים הבאים: \\ /: * ? \" < > |';

  @override
  String get downloadPDF => 'הורד PDF';

  @override
  String get viewPdf => 'הצג PDF';

  @override
  String get about => 'אודות';

  @override
  String get getFullLifetimeAccess => 'קבל גישה מלאה לכל החיים ב-1.99';

  @override
  String get viewPurchaseDetails => 'הצג פרטי רכישה';

  @override
  String get dataCollection => 'איסוף נתונים:';

  @override
  String get invalidFilename => 'שם קובץ לא חוקי';

  @override
  String get freeFeatureRenewal => 'תכונות חינמיות מתחדשות כל 3 ימים';

  @override
  String get upgradePrompt =>
      'שדרג עכשיו ברכישה חד פעמית ופתח את מלוא העוצמה של iSpeedPix2PDF 🚀.';

  @override
  String get ok => 'אישור';

  @override
  String get rateAppTitle => 'דרג את האפליקציה';

  @override
  String get rateAppMessage =>
      'אם אתה נהנה מהשימוש באפליקציה, נשמח אם תיקח דקה לכתוב ביקורת! המשוב שלך עוזר לנו להשתפר ולא ייקח יותר מדקה מזמנך.';

  @override
  String get rateButton => 'דרג';

  @override
  String get noThanksButton => 'לא תודה';

  @override
  String get maybeLaterButton => 'אולי מאוחר יותר';

  @override
  String get processing => 'מעבד';

  @override
  String get pleaseWait => 'אנא המתן';

  @override
  String get trialLimitReached => 'הגעת למגבלת הניסיון';

  @override
  String get privacyPolicy => 'מדיניות פרטיות';

  @override
  String get creatingPdf => 'יוצר PDF';

  @override
  String get loadingImagesInProgress => 'טוען תמונות';

  @override
  String get subscriptionRequired => 'נדרש מנוי';

  @override
  String get subscriptionMessageRequired =>
      'אנא הירשם כדי להמשיך להשתמש בכל הפונקציות';

  @override
  String get subscribeNowButton => 'הירשם עכשיו';

  @override
  String get restorePurchaseButton => 'שחזר רכישה';

  @override
  String get purchaseRestoredSuccessfully => 'הרכישה שוחזרה בהצלחה';

  @override
  String get purchaseRestoreFailedError => 'שחזור הרכישה נכשל';

  @override
  String get storagePermissionRequired => 'נדרש אישור אחסון';

  @override
  String get storagePermissionMessageRequired =>
      'אפליקציה זו דורשת אישור אחסון כדי לשמור קובצי PDF';

  @override
  String get grantPermissionButton => 'הענק הרשאה';

  @override
  String get openSettingsButton => 'פתח הגדרות';

  @override
  String get permissionDeniedError => 'ההרשאה נדחתה';

  @override
  String get errorWhileCreatingPdf => 'שגיאה ביצירת PDF';

  @override
  String get errorWhileSavingPdf => 'שגיאה בשמירת PDF';

  @override
  String get errorWhileLoadingImages => 'שגיאה בטעינת תמונות';

  @override
  String get pdfCreatedSuccessfully => 'PDF נוצר בהצלחה';

  @override
  String get pdfSavedSuccessfully => 'PDF נשמר בהצלחה';

  @override
  String get tryAgainButton => 'נסה שוב';

  @override
  String get continueButton => 'המשך';

  @override
  String get cancelButton => 'ביטול';

  @override
  String get closeButton => 'סגור';

  @override
  String get savingInProgress => 'שומר...';

  @override
  String get downloadingInProgress => 'מוריד...';

  @override
  String get invalidFileTypeError => 'סוג קובץ לא חוקי';

  @override
  String get maxFileSizeExceeded => 'חרגת מגודל הקובץ המרבי';

  @override
  String get maxImagesLimitReached => 'הגעת למספר התמונות המרבי';

  @override
  String get trialLimitMessageReached =>
      'הגעת למגבלת הניסיון. אנא הירשם כדי להמשיך להשתמש בכל הפונקציות.';

  @override
  String freeVersionLimitReached(Object Count, Object count) {
    return 'הגרסה החינמית מוגבלת ל-$count קובצי PDF';
  }

  @override
  String get imageQualityHighOption => 'איכות גבוהה (90%)';

  @override
  String get imageQualityMediumOption => 'איכות בינונית (70%)';

  @override
  String get imageQualityLowOption => 'איכות נמוכה (50%)';

  @override
  String get orientationDefaultOption => 'תצוגת ברירת מחדל';

  @override
  String get orientationPortraitOption => 'כפה תצוגה לאורך';

  @override
  String get orientationLandscapeOption => 'כפה תצוגה לרוחב';

  @override
  String get orientationMixedOption => 'תצוגה מעורבת';

  @override
  String get unsupportedFileFormatError => 'פורמט קובץ לא נתמך';

  @override
  String get supportedFormatsMessage => 'פורמטים נתמכים: JPG, PNG, HEIC';

  @override
  String get shareViaButton => 'שתף באמצעות';

  @override
  String get sharePdfButton => 'שתף PDF';

  @override
  String get enjoyingAppMessage => 'נהנה מ-iSpeedPix2PDF?';

  @override
  String get rateAppStoreButton => 'דרג בחנות האפליקציות';

  @override
  String get ratePlayStoreButton => 'דרג ב-Google Play';

  @override
  String get sendFeedbackButton => 'שלח משוב';

  @override
  String get preparingImagesInProgress => 'מכין תמונות...';

  @override
  String get optimizingImagesInProgress => 'ממטב תמונות...';

  @override
  String get generatingPdfInProgress => 'יוצר PDF...';

  @override
  String get almostDoneMessage => 'כמעט סיימנו...';

  @override
  String get unlockFeatureButton => 'פתח תכונה זו';

  @override
  String get premiumFeatureMessage => 'תכונה בתשלום';

  @override
  String get upgradeToUnlockMessage => 'שדרג כדי לפתוח את כל הפונקציות';

  @override
  String get weDoNotCollectAnyPersonalData =>
      ' אנו לא אוספים, שומרים או מעבדים כל מידע אישי מהמשתמשים. כל הנתונים מנוהלים מקומית במכשיר שלך. כלומר';

  @override
  String get noImagesAreShared =>
      'שום תמונה לא מועברת לשרת.\n- שום מידע אישי לא נאסף, נשמר או משותף על ידי האפליקציה שלנו.';

  @override
  String get filesSelected => 'קבצים נבחרו';

  @override
  String get rateThisApp => 'דרג אפליקציה זו';

  @override
  String get rateThisAppMessage =>
      'אם אתה נהנה מהשימוש באפליקציה, נשמח אם תיקח דקה לכתוב ביקורת! המשוב שלך עוזר לנו להשתפר ולא ייקח יותר מדקה מזמנך.';

  @override
  String get rate => 'דרג';

  @override
  String get noThanks => 'לא תודה';

  @override
  String get maybeLater => 'אולי מאוחר יותר';

  @override
  String get permissionRequired => 'נדרשת הרשאה';

  @override
  String get freeTrialExpiredMessage =>
      'תקופת הניסיון הסתיימה או הפיצ’רים החינמיים נוצלו';

  @override
  String get upgradeNowButton => 'שדרג עכשיו';

  @override
  String get howToUse => 'כיצד להשתמש';

  @override
  String get simplicityAndEfficiency => 'פשטות ויעילות';

  @override
  String get privacyAndSecurity => 'פרטיות ואבטחה';

  @override
  String get moreAppsByTevinEighDesigns =>
      'עוד אפליקציות מבית Tevin Eigh Designs';

  @override
  String get aboutTevinEighDesigns => 'אודות Tevin Eigh Designs';

  @override
  String get returnToConverter => 'חזור לממיר';

  @override
  String get currentPlanFullAccess => 'תוכנית נוכחית: גישה מלאה';

  @override
  String get currentPlanFreeTrial => 'תוכנית נוכחית: ניסיון חינמי';

  @override
  String get freeTrialOneWeekUnlimitedUse =>
      'ניסיון חינמי – 3 ימים – שימוש ללא הגבלה';

  @override
  String get freeVersionTrialAfterTrialExpires =>
      'גרסה חינמית – לאחר סיום תקופת הניסיון';

  @override
  String get createUpToFivePDFsEverySevenDays =>
      '✔ צור עד 5 קובצי PDF כל 3 ימים\n';

  @override
  String get eachPDFCanHaveUpToThreePages =>
      '✔ כל PDF יכול להכיל עד 3 עמודים\n';

  @override
  String get autoResetEverySevenDays => '✔ איפוס אוטומטי כל 3 ימים\n\n';

  @override
  String get oneTimePurchaseUnlockFullAccess =>
      'רכישה חד פעמית (גישה מלאה לכל החיים)\n\n';

  @override
  String get adFreeAfterPurchase => '✔ ללא פרסומות לאחר הרכישה\n';

  @override
  String get unlimitedPDFCreation => '✔ יצירת PDF ללא הגבלה\n';

  @override
  String get singlePurchaseLifetimeAccess =>
      '✔ רכישה אחת לגישה מלאה לכל החיים\n\n';

  @override
  String get upgradeTodayToUnlockCompletePotential =>
      'שדרג עוד היום כדי לפתוח את כל הפוטנציאל של iSpeedPix2PDF עם מנוי לכל החיים 🚀';

  @override
  String get enjoyFullAccess => 'תהנה מגישה מלאה';

  @override
  String get checkingActivePurchase => 'בודק רכישות פעילות';

  @override
  String get alreadyPurchasedRestoreHere => 'כבר רכשת? שחזר כאן';

  @override
  String get buyNowInFourNineNine => 'קנה עכשיו ב-1.99';

  @override
  String get success => 'הצלחה';

  @override
  String get yourPurchaseHasBeenSuccessfullyRestored =>
      'הרכישה שלך שוחזרה בהצלחה!';

  @override
  String get purchaseHistory => 'היסטוריית רכישות';

  @override
  String get noPurchasesFound => 'לא נמצאו רכישות';

  @override
  String get weCouldNotFindAnyPreviousPurchasesToRestore =>
      'לא הצלחנו למצוא רכישות קודמות לשחזור.';

  @override
  String get purchaseDate => 'תאריך רכישה';

  @override
  String get purchaseAmount => 'סכום רכישה';

  @override
  String get purchaseStatus => 'סטטוס רכישה';

  @override
  String get purchaseId => 'מזהה רכישה';

  @override
  String get purchaseDetails => 'פרטי רכישה';

  @override
  String get error => 'שגיאה';

  @override
  String get failedToRestorePurchasesPleaseTryAgainLater =>
      'שחזור הרכישות נכשל. אנא נסה שוב מאוחר יותר.';

  @override
  String get howToUseISpeedPix2PDFStepByStep =>
      'כיצד להשתמש ב-iSpeedPix2PDF: שלב אחר שלב';

  @override
  String get howToUsePointOne =>
      '1. בחר תמונות\nהקש על כפתור \'בחר קבצים\' לפתיחת גלריית התמונות שלך\n-בחר את התמונות שברצונך להוסיף ל-PDF שלך. ניתן לבחור מספר תמונות בו זמנית\n\n2. הוסף שם לקובץ (אופציונלי)\n- תוכל להזין שם מותאם אישית ל-PDF שלך על ידי הקשה על שדה \'שם הקובץ\'\n- אם לא תזין שם, האפליקציה תיצור שם אוטומטי בפורמט iSpeedPix2PDF_DATE_TIME\n\n3. הצג או הורד את ה-PDF\n- הורד כדי לשמור את הקובץ (הקובץ בנוי להיות קטן לצורך שיתוף וניהול נוחים)\n- הצג אותו ישירות באפליקציה להצגה מהירה\n\n4. שתף את ה-PDF\n- לאחר השמירה, תוכל לשתף את ה-PDF בדוא״ל, אפליקציות מסרים, שירותי ענן, או כל אפשרות שיתוף אחרת במכשירך\n- עם PDF שמור, תוכל לנהל, לערוך ולשתף את הסריקות שלך בקלות, באמצעות הכלים שאתה כבר מכיר—לייעול התהליך וניהול מסמכים יעיל יותר\n\nוזהו! יצרת, צפית ושיתפת PDF קל לניהול עם iSpeedPix2PDF.';

  @override
  String get mainMenu => 'תפריט ראשי';

  @override
  String get simplicityAndPrivacyDetail =>
      'הפילוסופיה שלנו\n-פשטות: האפליקציות שלנו נבנו בצורה אינטואיטיבית ופשוטה לשימוש לכולם.\n\n-אבטחה: על ידי שמירת כל העיבוד בצד המשתמש, אנו מבטיחים שהנתונים שלך נשארים פרטיים ומאובטחים.\n-יעילות: אנו ממשיכים לייעל את האפליקציות שלנו על ידי הסרת שלבים מיותרים תוך שמירה על הפונקציונליות העיקרית.';

  @override
  String get simplicityAndPrivacyDetailTwo =>
      'אנו מאמינים בלספק בדיוק את מה שאתה צריך, לא יותר ולא פחות. במהלך ההתפתחות שלנו, המחויבות שלנו נותרת לשפר יעילות מבלי לפגוע בתכלית העיקרית של האפליקציה.';

  @override
  String get simplicityAndPrivacyDetailThree =>
      'גלה את מגוון האפליקציות המקומיות שלנו ותחווה את ההבדל שפשטות, יעילות ואבטחה יכולים לעשות במשימות היומיומיות שלך.';

  @override
  String get privacyAndSecurityDetailTitle =>
      'ברוכים הבאים ל-iSpeedPix2PDF. אנו מחויבים לשמור על פרטיותך ולהבטיח את אבטחת המידע האישי שלך. מדיניות פרטיות זו מפרטת כיצד אנו אוספים, משתמשים ומגנים על הנתונים שלך בעת השימוש באפליקציית iSpeedPix2PDF במכשירים ניידים.';

  @override
  String get privacyAndSecurityDetailOne =>
      '1. איסוף מידע ושימוש - iSpeedPix2PDF היא אפליקציה בצד הלקוח; כל הנתונים המעובדים נשארים מקומית במכשירך, ללא שליחה לשרתים חיצוניים לעיבוד.\n-גישה לגלריית התמונות: iSpeedPix2PDF דורשת גישה לגלריית התמונות שלך כדי לאפשר בחירת תמונות להמרה ל-PDF.\n-לאחר יצירת ה-PDF, האפליקציה לא שומרת או שומרת קבצים. למשתמש שליטה מלאה בקבצי ה-PDF ויכול לבחור לשתף, לשלוח במייל, לשמור או להעלות אותם.';

  @override
  String get privacyAndSecurityDetailTwo =>
      '2. ללא העברת נתונים - כאפליקציה בצד הלקוח, iSpeedPix2PDF מבטיחה שאף אחד מהנתונים שלך, כולל מידע אישי או קובצי PDF שנוצרו, לא מועבר לשרתים חיצוניים או שירותי צד שלישי. כל התהליך—from בחירת תמונות ליצירת PDF—מתבצע כולו במכשירך, ומבטיח את רמת הפרטיות והאבטחה הגבוהה ביותר.';

  @override
  String get privacyAndSecurityDetailThree =>
      '3. מנוי חד פעמי - iSpeedPix2PDF פועלת במודל של רכישה חד פעמית לכל החיים, כך שאתה משלם רק פעם אחת עבור גישה מלאה לכל הפונקציות—ללא תשלומים חוזרים, ללא עלויות נסתרות. עיבוד התשלומים מתבצע בצורה מאובטחת דרך שירות המאמת ומנהל רכישות. לאחר הרכישה, האפליקציה נשארת פונקציונלית במלואה ללא צורך בתשלומים נוספים.';

  @override
  String get privacyAndSecurityDetailFour =>
      '4. ללא פרסומות - אנו לא מציגים פרסומות או מוכרים את הנתונים שלך. iSpeedPix2PDF נבנתה לספק חוויית משתמש חלקה ויעילה ללא הפרעות מפרסומות. המיקוד שלנו הוא בהבטחת שיטה פשוטה ובטוחה ליצירת ושיתוף קובצי PDF, בשליטה מלאה שלך.';

  @override
  String get view => 'הצג';

  @override
  String get aboutTevinEighDescription =>
      'ב-Tevin Eigh Designs, אנו מתמחים בפיתוח אפליקציות מקומיות הפותרות בעיות יומיומיות בפשטות, יעילות ואבטחה. המיקוד שלנו הוא לספק את הפונקציונליות המרכזית שאתה צריך עם הכי מעט שלבים ולחיצות, כדי שתוכל להתרכז במשימות העיקריות שלך ללא הסחות דעת.\n\nהפילוסופיה שלנו:\n-פשטות: האפליקציות שלנו מעוצבות בצורה אינטואיטיבית וברורה, כך שכל אחד יכול להשתמש בהן.\n-אבטחה: על ידי עיבוד בצד הלקוח, אנו שומרים על פרטיותך ובטיחות המידע שלך.\n-יעילות: אנו משפרים כל הזמן את האפליקציות שלנו, ומסירים שלבים מיותרים תוך שמירה על הליבה הפונקציונלית.\n\nאנו מאמינים בלספק בדיוק את מה שאתה צריך, לא יותר ולא פחות. לאורך ההתפתחות שלנו, נמשיך לשפר את היעילות מבלי לוותר על מטרות היישומים שלנו.\n\nגלה את מגוון האפליקציות שלנו ותחווה את ההבדל שפשטות, יעילות ואבטחה יכולים לעשות.\n\nwww.tevineigh.com\n';

  @override
  String get language => 'שפה';

  @override
  String get chooseLanguage => 'בחר שפה';

  @override
  String get aboutAppDescription => 'המר תמונות ל-PDF במהירות ובקלות';

  @override
  String get settings => 'הגדרות';

  @override
  String get selectLanguage => 'בחר שפה';

  @override
  String get save => 'שמור';

  @override
  String get privacyAndSecurityDetailFive =>
      '5. מדיניות פרטיות - האפליקציות שלנו משתמשות ב-Google Firebase לצורכי אופטימיזציה לחנויות אפליקציות (ASO) ואופטימיזציה למנועי חיפוש (SEO) בלבד. אנחנו לא אוספים, מוכרים או משתמשים במידע זה לכל מטרה אחרת.\n\nלמידע נוסף על מדיניות השמירה על פרטיות של Google Firebase, אנא עיין במדיניות הפרטיות שלהם:';

  @override
  String get monthlyUsageLimitReached => 'הגעת למגבלת השימוש החודשית';

  @override
  String get monthlyUsageLimitDescription =>
      'ניצלת את 3 הדקות של זמן השימוש החינמי שלך לחודש זה. זמן השימוש יתאפס בתחילת החודש הבא.';

  @override
  String get unlockUnlimitedUsageWithSubscription =>
      'פתח זמן שימוש בלתי מוגבל ברכישה חד-פעמית של מנוי לכל החיים.';

  @override
  String get laterButton => 'אחר כך';

  @override
  String remainingUsageTime(int minutes, int seconds) {
    return 'זמן שימוש שנותר: $minutes דקות $seconds שניות';
  }

  @override
  String get threeMinutesUsagePerMonth => '✔ 3 דקות שימוש בכל חודש\n';

  @override
  String get usageTimeResetMonthly => '✔ זמן השימוש מתאפס אחת לחודש\n\n';

  @override
  String get trialTimeLeft => 'זמן ניסיון נותר';

  @override
  String remainingTime(int minutes, String seconds) {
    return 'נותר $minutes:$seconds';
  }

  @override
  String get unlockUnlimitedAccessToday => 'פתח גישה בלתי מוגבלת היום!';

  @override
  String get enjoyingFreeTrialUpgradeMessage =>
      'אתה נהנה מהניסיון החינמי! למה לחכות? שדרג עכשיו לתוכנית לכל החיים שלנו ולעולם לא תדאג יותר ממגבלות זמן. תשלום אחד, שימוש בלתי מוגבל לנצח — ללא מנויים, ללא חיובים חוזרים!';

  @override
  String get usagePausedThirtyDays => 'השימוש הושהה (30 יום)';

  @override
  String get freeTimeExpired => 'הזמן החינמי פג';

  @override
  String get almostOutOfFreeTime => 'כמעט נגמר הזמן החינמי';

  @override
  String usagePausedMessage(int days) {
    return 'הזמן החינמי שלך מושהה עוד $days ימים. שדרג לתוכנית לכל החיים שלנו כדי לקבל שימוש בלתי מוגבל מיד — ללא חיובים חוזרים, ללא מנויים.';
  }

  @override
  String get freeTimeExpiredMessage =>
      'הזמן החינמי שלך פג! שדרג לתוכנית לכל החיים שלנו בתשלום חד-פעמי — ללא חיובים חוזרים, ללא מנויים. קבל שימוש בלתי מוגבל לנצח.';

  @override
  String get almostOutOfFreeTimeMessage =>
      'כמעט נגמר לך הזמן החינמי החודש! שדרג לתוכנית לכל החיים שלנו בתשלום חד-פעמי — ללא חיובים חוזרים, ללא מנויים. קבל שימוש בלתי מוגבל לנצח.';

  @override
  String get subscribeNow => 'הירשם עכשיו';

  @override
  String get likingTheApp => 'אוהב את האפליקציה?';

  @override
  String get likingTheAppMessage =>
      'אוהב את האפליקציה? קבל גישה לכל החיים היום בתשלום חד-פעמי — ללא חיובים חוזרים, ללא מנויים. פתח שימוש בלתי מוגבל לנצח!';

  @override
  String get maybeLatr => 'אולי מאוחר יותר';

  @override
  String get getLifetimeAccess => 'קבל גישה לכל החיים';

  @override
  String get stillEnjoyingIt => 'עדיין נהנה?';

  @override
  String get stillEnjoyingItMessage =>
      'עדיין נהנה? שדרג עכשיו ושמור על הגישה לנצח עם תוכנית לכל החיים שלנו — תשלום אחד, ללא מנויים, שימוש בלתי מוגבל לכל החיים!';

  @override
  String get notNow => 'לא עכשיו';

  @override
  String get upgradeForever => 'שדרג לנצח';

  @override
  String get almostOutOfFreeTimeTitle => 'כמעט נגמר הזמן החינמי';

  @override
  String get almostOutOfFreeTimeWarningMessage =>
      'כמעט נגמר לך הזמן החינמי החודש! שדרג לתוכנית לכל החיים שלנו בתשלום חד-פעמי — ללא חיובים חוזרים, ללא מנויים. קבל שימוש בלתי מוגבל לנצח.';

  @override
  String get later => 'מאוחר יותר';

  @override
  String get upgradeNow => 'שדרג עכשיו';

  @override
  String get creatingPdfMessage => 'יוצר PDF...';

  @override
  String get day => 'יום';

  @override
  String get days => 'ימים';

  @override
  String get left => 'נותר';

  @override
  String get sessionTime => 'זמן הפעלה';

  @override
  String get usePromoCode => 'השתמש בקוד פרומו';

  @override
  String get enterPromoCode => 'הכנס קוד פרומו';

  @override
  String get apply => 'החל';

  @override
  String get invalidPromoCode => 'קוד פרומו לא תקין';

  @override
  String get promoCodeAppliedSuccessfully => 'קוד פרומו הוחל בהצלחה!';

  @override
  String get promoCode => 'קוד פרומו';
}
