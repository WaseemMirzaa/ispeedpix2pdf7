// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get rest => 'Reset';

  @override
  String get appTitle => 'iSpeedPix2PDF';

  @override
  String get defaultMixedOrientation => '기본 - 혼합 방향';

  @override
  String get pagesFixedPortrait => '페이지 고정 - 세로 방향';

  @override
  String get landscapePhotosTopAlignedForEasyViewing => '가로 사진 - 상단 정렬로 쉽게 보기';

  @override
  String get reset => '초기화';

  @override
  String get chooseFiles => '파일 선택';

  @override
  String get noFilesSelected => '선택된 파일이 없습니다';

  @override
  String get youCanSelectUpTo3ImagesInFreeVersion =>
      '*무료 버전에서는 최대 3장까지 선택할 수 있습니다';

  @override
  String get youCanSelectUpTo60Images => '*최대 60장까지 선택할 수 있습니다';

  @override
  String get filename => '파일 이름';

  @override
  String get filenameOptional => '파일 이름 (선택 사항)';

  @override
  String get enterCustomFileNameOptional => '맞춤 파일 이름 입력 (선택 사항)';

  @override
  String get filenameCannotContainCharacters =>
      '파일 이름에는 다음 문자를 포함할 수 없습니다: \\ /: * ? \" < > |';

  @override
  String get downloadPDF => 'PDF 다운로드';

  @override
  String get viewPdf => 'PDF 보기';

  @override
  String get about => '정보';

  @override
  String get getFullLifetimeAccess => '1.99에 평생 이용권 구매';

  @override
  String get viewPurchaseDetails => '구매 내역 보기';

  @override
  String get dataCollection => '데이터 수집:';

  @override
  String get invalidFilename => '잘못된 파일 이름';

  @override
  String get freeFeatureRenewal => '무료 기능은 3일마다 갱신됩니다';

  @override
  String get upgradePrompt => '한 번의 구매로 iSpeedPix2PDF의 모든 기능을 잠금 해제하세요 🚀';

  @override
  String get ok => '확인';

  @override
  String get rateAppTitle => '앱 평가하기';

  @override
  String get rateAppMessage =>
      '이 앱을 즐겨 사용하신다면, 잠시 시간을 내어 리뷰를 남겨주세요! 여러분의 피드백은 저희가 앱을 개선하는 데 큰 도움이 됩니다.';

  @override
  String get rateButton => '평가하기';

  @override
  String get noThanksButton => '괜찮아요';

  @override
  String get maybeLaterButton => '나중에 할게요';

  @override
  String get processing => '처리 중';

  @override
  String get pleaseWait => '잠시만 기다려 주세요';

  @override
  String get trialLimitReached => '체험 한도 도달';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get creatingPdf => 'PDF 생성 중';

  @override
  String get loadingImagesInProgress => '이미지 불러오는 중';

  @override
  String get subscriptionRequired => '구독 필요';

  @override
  String get subscriptionMessageRequired => '모든 기능을 사용하려면 구독해 주세요';

  @override
  String get subscribeNowButton => '지금 구독하기';

  @override
  String get restorePurchaseButton => '구매 복원';

  @override
  String get purchaseRestoredSuccessfully => '구매 복원 성공';

  @override
  String get purchaseRestoreFailedError => '구매 복원 실패';

  @override
  String get storagePermissionRequired => '저장소 권한 필요';

  @override
  String get storagePermissionMessageRequired => 'PDF 저장을 위해 저장소 권한이 필요합니다';

  @override
  String get grantPermissionButton => '권한 허용';

  @override
  String get openSettingsButton => '설정 열기';

  @override
  String get permissionDeniedError => '권한 거부됨';

  @override
  String get errorWhileCreatingPdf => 'PDF 생성 중 오류 발생';

  @override
  String get errorWhileSavingPdf => 'PDF 저장 중 오류 발생';

  @override
  String get errorWhileLoadingImages => '이미지 불러오기 오류';

  @override
  String get pdfCreatedSuccessfully => 'PDF 생성 완료';

  @override
  String get pdfSavedSuccessfully => 'PDF 저장 완료';

  @override
  String get tryAgainButton => '다시 시도';

  @override
  String get continueButton => '계속';

  @override
  String get cancelButton => '취소';

  @override
  String get closeButton => '닫기';

  @override
  String get savingInProgress => '저장 중...';

  @override
  String get downloadingInProgress => '다운로드 중...';

  @override
  String get invalidFileTypeError => '잘못된 파일 형식';

  @override
  String get maxFileSizeExceeded => '최대 파일 크기 초과';

  @override
  String get maxImagesLimitReached => '최대 이미지 수 도달';

  @override
  String get trialLimitMessageReached =>
      '체험 한도에 도달했습니다. 모든 기능을 계속 사용하려면 구독해 주세요.';

  @override
  String freeVersionLimitReached(Object Count, Object count) {
    return '무료 버전은 $count개의 PDF로 제한됩니다';
  }

  @override
  String get imageQualityHighOption => '고화질 (90%)';

  @override
  String get imageQualityMediumOption => '중간 화질 (70%)';

  @override
  String get imageQualityLowOption => '저화질 (50%)';

  @override
  String get orientationDefaultOption => '기본 방향';

  @override
  String get orientationPortraitOption => '세로 고정';

  @override
  String get orientationLandscapeOption => '가로 고정';

  @override
  String get orientationMixedOption => '혼합 방향';

  @override
  String get unsupportedFileFormatError => '지원하지 않는 파일 형식';

  @override
  String get supportedFormatsMessage => '지원 형식: JPG, PNG, HEIC';

  @override
  String get shareViaButton => '공유하기';

  @override
  String get sharePdfButton => 'PDF 공유';

  @override
  String get enjoyingAppMessage => 'iSpeedPix2PDF를 즐기고 계신가요?';

  @override
  String get rateAppStoreButton => '앱스토어에서 평가하기';

  @override
  String get ratePlayStoreButton => '플레이스토어에서 평가하기';

  @override
  String get sendFeedbackButton => '피드백 보내기';

  @override
  String get preparingImagesInProgress => '이미지 준비 중...';

  @override
  String get optimizingImagesInProgress => '이미지 최적화 중...';

  @override
  String get generatingPdfInProgress => 'PDF 생성 중...';

  @override
  String get almostDoneMessage => '거의 완료되었습니다...';

  @override
  String get unlockFeatureButton => '이 기능 잠금 해제';

  @override
  String get premiumFeatureMessage => '프리미엄 기능';

  @override
  String get upgradeToUnlockMessage => '모든 기능 잠금 해제를 위해 업그레이드하세요';

  @override
  String get weDoNotCollectAnyPersonalData =>
      '개인 데이터를 수집, 저장 또는 처리하지 않습니다. 모든 데이터는 기기 내에서만 처리됩니다.';

  @override
  String get noImagesAreShared =>
      '이미지가 서버에 업로드되지 않습니다.\n- 모바일 앱은 개인 데이터를 수집, 저장 또는 공유하지 않습니다.';

  @override
  String get filesSelected => '선택된 파일';

  @override
  String get rateThisApp => '이 앱 평가하기';

  @override
  String get rateThisAppMessage =>
      '이 앱이 마음에 드셨다면, 리뷰를 남겨주시면 정말 감사하겠습니다! 여러분의 피드백은 저희가 앱을 개선하는 데 큰 도움이 됩니다.';

  @override
  String get rate => '평가';

  @override
  String get noThanks => '괜찮아요';

  @override
  String get maybeLater => '나중에 할게요';

  @override
  String get permissionRequired => '권한 필요';

  @override
  String get freeTrialExpiredMessage => '무료 체험 종료 또는 무료 기능 소진';

  @override
  String get upgradeNowButton => '지금 업그레이드';

  @override
  String get howToUse => '사용 방법';

  @override
  String get simplicityAndEfficiency => '간편함과 효율성';

  @override
  String get privacyAndSecurity => '개인정보 보호 및 보안';

  @override
  String get moreAppsByTevinEighDesigns => 'Tevin Eigh Designs의 더 많은 앱';

  @override
  String get aboutTevinEighDesigns => 'Tevin Eigh Designs 소개';

  @override
  String get returnToConverter => '변환기로 돌아가기';

  @override
  String get currentPlanFullAccess => '현재 플랜: 전체 접근';

  @override
  String get currentPlanFreeTrial => '현재 플랜: 무료 체험';

  @override
  String get freeTrialOneWeekUnlimitedUse => '무료 체험 – 3일 – 무제한 사용';

  @override
  String get freeVersionTrialAfterTrialExpires => '무료 버전 – 체험 종료 후';

  @override
  String get createUpToFivePDFsEverySevenDays => '✔ 3일마다 최대 5개의 PDF 생성\n';

  @override
  String get eachPDFCanHaveUpToThreePages => '✔ 각 PDF는 최대 3페이지\n';

  @override
  String get autoResetEverySevenDays => '✔ 3일마다 자동 초기화\n\n';

  @override
  String get oneTimePurchaseUnlockFullAccess => '일회성 구매로 전체 기능 잠금 해제\n\n';

  @override
  String get adFreeAfterPurchase => '✔ 구매 후 광고 없음\n';

  @override
  String get unlimitedPDFCreation => '✔ 무제한 PDF 생성\n';

  @override
  String get singlePurchaseLifetimeAccess => '✔ 평생 이용 가능한 단일 구매\n\n';

  @override
  String get upgradeTodayToUnlockCompletePotential =>
      '오늘 업그레이드하여 iSpeedPix2PDF의 모든 기능을 평생 구독으로 잠금 해제하세요 🚀';

  @override
  String get enjoyFullAccess => '전체 기능을 즐기세요';

  @override
  String get checkingActivePurchase => '활성 구매 확인 중';

  @override
  String get alreadyPurchasedRestoreHere => '이미 구매하셨나요? 여기서 복원하세요';

  @override
  String get buyNowInFourNineNine => '1.99에 구매하기';

  @override
  String get success => '성공';

  @override
  String get yourPurchaseHasBeenSuccessfullyRestored => '구매가 성공적으로 복원되었습니다!';

  @override
  String get purchaseHistory => '구매 내역';

  @override
  String get noPurchasesFound => '구매 내역이 없습니다';

  @override
  String get weCouldNotFindAnyPreviousPurchasesToRestore =>
      '복원할 이전 구매 내역을 찾을 수 없습니다.';

  @override
  String get purchaseDate => '구매 날짜';

  @override
  String get purchaseAmount => '구매 금액';

  @override
  String get purchaseStatus => '구매 상태';

  @override
  String get purchaseId => '구매 ID';

  @override
  String get purchaseDetails => '구매 상세 정보';

  @override
  String get error => '오류';

  @override
  String get failedToRestorePurchasesPleaseTryAgainLater =>
      '구매 복원에 실패했습니다. 나중에 다시 시도해 주세요.';

  @override
  String get howToUseISpeedPix2PDFStepByStep => 'iSpeedPix2PDF 사용법: 단계별 안내';

  @override
  String get howToUsePointOne =>
      '1. 사진 선택\n‘파일 선택’ 버튼을 눌러 사진 갤러리를 엽니다.\n- PDF에 포함할 사진을 선택하세요. 여러 장을 한 번에 선택할 수 있습니다.\n\n2. 파일 이름 추가 (선택 사항)\n- ‘파일 이름’ 필드를 눌러 PDF의 맞춤 이름을 지정할 수 있습니다.\n- 이름을 지정하지 않으면 자동으로 iSpeedPix2PDF_날짜_시간 형식으로 이름이 지정됩니다.\n\n3. PDF 보기 또는 다운로드\n- 다운로드하여 파일을 저장하세요 (파일 크기는 공유와 관리가 용이하도록 작게 설계되었습니다).\n- 앱 내에서 바로 보기를 할 수도 있습니다.\n\n4. PDF 공유\n- 저장 후 이메일, 메시지 앱, 클라우드 서비스 등 원하는 방법으로 PDF를 공유할 수 있습니다.\n- 저장된 PDF는 이미 익숙한 도구를 사용해 쉽게 관리, 편집, 공유할 수 있어 문서 처리 과정이 더욱 빨라집니다.\n\n이것으로 끝입니다! iSpeedPix2PDF로 간편하고 관리하기 쉬운 PDF를 생성, 보고, 공유하셨습니다.';

  @override
  String get mainMenu => '메인 메뉴';

  @override
  String get simplicityAndPrivacyDetail =>
      '우리의 철학\n- 간편함: 모든 앱은 직관적이고 쉽게 사용할 수 있도록 설계되었습니다.\n\n- 보안: 모든 처리는 클라이언트 측에서 이루어져 데이터가 안전하게 보호됩니다.\n- 효율성: 불필요한 단계를 제거하고 핵심 기능을 유지하도록 지속적으로 앱을 개선합니다.';

  @override
  String get simplicityAndPrivacyDetailTwo =>
      '필요한 것만, 딱 맞게 제공합니다. 앞으로도 주요 기능을 해치지 않으면서 효율성을 높이는 데 최선을 다할 것입니다.';

  @override
  String get simplicityAndPrivacyDetailThree =>
      '저희 클라이언트 사이드 앱을 탐색하시고, 단순함, 효율성, 그리고 보안이 일상 업무에 가져다주는 차이를 경험해보세요.';

  @override
  String get privacyAndSecurityDetailTitle =>
      'iSpeedPix2PDF에 오신 것을 환영합니다. 저희는 여러분의 개인정보 보호와 보안 유지에 최선을 다하고 있습니다. 본 개인정보처리방침은 모바일 기기에서 iSpeedPix2PDF 앱을 사용할 때 데이터를 어떻게 수집, 사용, 보호하는지에 대해 안내합니다.';

  @override
  String get privacyAndSecurityDetailOne =>
      '1. 정보 수집 및 이용 - iSpeedPix2PDF는 클라이언트 사이드 앱으로, 앱에서 처리되는 모든 데이터는 기기 내에만 저장되며 외부 서버로 전송되지 않습니다.\n- 사진 갤러리 접근: PDF 변환을 위해 이미지 선택 시, iSpeedPix2PDF는 기기의 사진 갤러리에 접근할 권한이 필요합니다.\n- PDF가 생성된 후, 앱은 파일을 저장하거나 보관하지 않습니다. 사용자는 PDF를 자유롭게 공유, 이메일 전송, 저장 또는 업로드할 수 있습니다.';

  @override
  String get privacyAndSecurityDetailTwo =>
      '2. 데이터 전송 없음 - 클라이언트 사이드 앱으로서 iSpeedPix2PDF는 개인 정보나 생성된 PDF를 포함한 어떠한 데이터도 외부 서버나 제3자 서비스로 전송하지 않음을 보장합니다. 이미지 선택부터 PDF 생성까지 모든 과정이 기기 내에서 완료되어 최고 수준의 프라이버시와 보안을 제공합니다.';

  @override
  String get privacyAndSecurityDetailThree =>
      '3. 일회성 평생 구독 - iSpeedPix2PDF는 일회성 평생 구독 모델을 운영하여, 모든 기능을 완전하게 이용하기 위해 한 번만 결제하면 됩니다. 반복 결제나 숨겨진 비용이 없습니다. 결제 처리는 안전한 서비스를 통해 검증 및 관리됩니다. 구매 후에는 추가 결제 없이 앱을 완전히 사용할 수 있습니다.';

  @override
  String get privacyAndSecurityDetailFour =>
      '4. 광고 없음 - 저희는 광고를 표시하지 않으며, 사용자 데이터를 판매하지 않습니다. iSpeedPix2PDF는 방해 없는 매끄럽고 효율적인 사용자 경험을 제공하며, PDF 생성 및 공유를 간단하고 안전하게 할 수 있도록 설계되었습니다.';

  @override
  String get view => '보기';

  @override
  String get aboutTevinEighDescription =>
      'Tevin Eigh Designs는 단순함, 효율성, 그리고 보안을 중시하는 클라이언트 사이드 앱을 전문적으로 개발합니다. 최소한의 단계와 클릭으로 필요한 핵심 기능을 제공하여, 사용자가 주요 작업에 집중할 수 있도록 돕습니다.\n\n저희 철학\n- 단순함: 모든 사람이 쉽게 사용할 수 있도록 직관적이고 간단하게 설계합니다.\n- 보안: 모든 처리를 클라이언트 측에서 수행하여 데이터 프라이버시를 보장합니다.\n- 효율성: 불필요한 단계를 제거하면서 핵심 기능을 유지하기 위해 지속적으로 앱을 개선합니다.\n\n필요한 것만 제공하며, 그 이상도 그 이하도 아닙니다. 앞으로도 본질을 해치지 않으면서 효율성을 높이는 데 최선을 다하겠습니다.\n\n저희 클라이언트 사이드 앱을 경험하며, 단순함, 효율성, 보안이 여러분의 일상에 가져다주는 변화를 느껴보세요.\n\nwww.tevineigh.com\n';

  @override
  String get language => '언어';

  @override
  String get chooseLanguage => '언어 선택';

  @override
  String get aboutAppDescription => '이미지를 빠르고 쉽게 PDF로 변환';

  @override
  String get settings => '설정';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get save => '저장';

  @override
  String get privacyAndSecurityDetailFive =>
      '5. 개인정보 보호정책 - 당사의 앱은 앱 스토어 최적화(ASO) 및 검색 엔진 최적화(SEO) 목적에 한하여 Google Firebase를 사용합니다. 우리는 이 정보를 다른 목적으로 수집하거나 판매하거나 사용하지 않습니다.\n\nGoogle Firebase의 데이터 처리 방식에 대한 자세한 내용은 해당 개인정보 보호정책을 참고해 주세요:';

  @override
  String get monthlyUsageLimitReached => '월간 사용 한도에 도달했습니다';

  @override
  String get monthlyUsageLimitDescription =>
      '이번 달의 무료 사용 시간 3분을 모두 사용하셨습니다. 사용 시간은 다음 달 초에 초기화됩니다.';

  @override
  String get unlockUnlimitedUsageWithSubscription =>
      '평생 구독을 한 번만 구매하면 무제한 사용 시간이 해제됩니다.';

  @override
  String get laterButton => '나중에';

  @override
  String remainingUsageTime(int minutes, int seconds) {
    return '남은 사용 시간: $minutes분 $seconds초';
  }

  @override
  String get threeMinutesUsagePerMonth => '✔ 매월 3분의 사용 시간\n';

  @override
  String get usageTimeResetMonthly => '✔ 사용 시간은 매월 초기화됩니다\n\n';

  @override
  String get trialTimeLeft => '체험 시간 남음';

  @override
  String remainingTime(int minutes, String seconds) {
    return '$minutes:$seconds 남음';
  }

  @override
  String get unlockUnlimitedAccessToday => '오늘 무제한 액세스 잠금 해제!';

  @override
  String get enjoyingFreeTrialUpgradeMessage =>
      '무료 체험을 즐기고 계시는군요! 왜 기다리시나요? 지금 평생 플랜으로 업그레이드하여 시간 제한을 더 이상 걱정하지 마세요. 한 번의 결제, 영구 무제한 사용 — 구독 없음, 반복 요금 없음!';

  @override
  String get usagePausedThirtyDays => '사용 일시정지 (30일)';

  @override
  String get freeTimeExpired => '무료 시간 만료';

  @override
  String get almostOutOfFreeTime => '무료 시간 거의 소진';

  @override
  String usagePausedMessage(int days) {
    return '무료 시간이 $days일 더 일시정지되었습니다. 평생 플랜으로 업그레이드하여 즉시 무제한 사용을 얻으세요 — 반복 요금 없음, 구독 없음.';
  }

  @override
  String get freeTimeExpiredMessage =>
      '무료 시간이 만료되었습니다! 일회성 결제로 평생 플랜으로 업그레이드 — 반복 요금 없음, 구독 없음. 영구 무제한 사용을 얻으세요.';

  @override
  String get almostOutOfFreeTimeMessage =>
      '이번 달 무료 시간이 거의 소진되었습니다! 일회성 결제로 평생 플랜으로 업그레이드 — 반복 요금 없음, 구독 없음. 영구 무제한 사용을 얻으세요.';

  @override
  String get subscribeNow => '지금 구독';

  @override
  String get likingTheApp => '앱이 마음에 드시나요?';

  @override
  String get likingTheAppMessage =>
      '앱이 마음에 드시나요? 일회성 결제로 오늘 평생 액세스를 얻으세요 — 반복 요금 없음, 구독 없음. 영구 무제한 사용을 잠금 해제하세요!';

  @override
  String get maybeLatr => '나중에';

  @override
  String get getLifetimeAccess => '평생 액세스 얻기';

  @override
  String get stillEnjoyingIt => '아직도 즐기고 계시나요?';

  @override
  String get stillEnjoyingItMessage =>
      '아직도 즐기고 계시나요? 지금 업그레이드하여 평생 플랜으로 영구 액세스를 유지하세요 — 한 번의 결제, 구독 없음, 평생 무제한 사용!';

  @override
  String get notNow => '지금은 안함';

  @override
  String get upgradeForever => '영구 업그레이드';

  @override
  String get almostOutOfFreeTimeTitle => '무료 시간 거의 소진';

  @override
  String get almostOutOfFreeTimeWarningMessage =>
      '이번 달 무료 시간이 거의 소진되었습니다! 일회성 결제로 평생 플랜으로 업그레이드 — 반복 요금 없음, 구독 없음. 영구 무제한 사용을 얻으세요.';

  @override
  String get later => '나중에';

  @override
  String get upgradeNow => '지금 업그레이드';

  @override
  String get creatingPdfMessage => 'PDF 생성 중...';

  @override
  String get day => '일';

  @override
  String get days => '일';

  @override
  String get left => '남음';

  @override
  String get sessionTime => '세션 시간';

  @override
  String get usePromoCode => '프로모 코드 사용';

  @override
  String get enterPromoCode => '프로모 코드 입력';

  @override
  String get apply => '적용';

  @override
  String get invalidPromoCode => '유효하지 않은 프로모 코드';

  @override
  String get promoCodeAppliedSuccessfully => '프로모 코드가 성공적으로 적용되었습니다!';

  @override
  String get promoCode => '프로모 코드';
}
