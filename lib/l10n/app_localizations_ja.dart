// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get rest => 'Reset';

  @override
  String get appTitle => 'iSpeedPix2PDF';

  @override
  String get defaultMixedOrientation => 'デフォルト - 混合向き';

  @override
  String get pagesFixedPortrait => 'ページ固定 - 縦向き';

  @override
  String get landscapePhotosTopAlignedForEasyViewing => '横向き写真 - 上揃えで見やすく';

  @override
  String get reset => 'リセット';

  @override
  String get chooseFiles => 'ファイルを選択';

  @override
  String get noFilesSelected => 'ファイルが選択されていません';

  @override
  String get youCanSelectUpTo3ImagesInFreeVersion => '*無料版では最大3枚の画像を選択可能';

  @override
  String get youCanSelectUpTo60Images => '*最大60枚の画像を選択可能';

  @override
  String get filename => 'ファイル名';

  @override
  String get filenameOptional => 'ファイル名（任意）';

  @override
  String get enterCustomFileNameOptional => 'カスタムファイル名を入力（任意）';

  @override
  String get filenameCannotContainCharacters =>
      'ファイル名に以下の文字は使用できません: \\ /: * ? \" < > |';

  @override
  String get downloadPDF => 'PDFをダウンロード';

  @override
  String get viewPdf => 'PDFを表示';

  @override
  String get about => '概要';

  @override
  String get getFullLifetimeAccess => '1.99で生涯フルアクセスを取得';

  @override
  String get viewPurchaseDetails => '購入詳細を表示';

  @override
  String get dataCollection => 'データ収集：';

  @override
  String get invalidFilename => '無効なファイル名';

  @override
  String get freeFeatureRenewal => '無料機能は3日ごとに更新されます';

  @override
  String get upgradePrompt => '今すぐ一括購入でアップグレードし、iSpeedPix2PDFの全機能をアンロック🚀。';

  @override
  String get ok => 'OK';

  @override
  String get rateAppTitle => 'このアプリを評価';

  @override
  String get rateAppMessage =>
      'このアプリを気に入っていただけたら、レビューを残していただけると嬉しいです！フィードバックは改善の助けになり、1分もかかりません。';

  @override
  String get rateButton => '評価する';

  @override
  String get noThanksButton => 'いいえ、結構です';

  @override
  String get maybeLaterButton => 'あとで';

  @override
  String get processing => '処理中';

  @override
  String get pleaseWait => 'お待ちください';

  @override
  String get trialLimitReached => '試用制限に達しました';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get creatingPdf => 'PDFを作成中';

  @override
  String get loadingImagesInProgress => '画像を読み込み中';

  @override
  String get subscriptionRequired => 'サブスクリプションが必要です';

  @override
  String get subscriptionMessageRequired => 'すべての機能を利用するには購読してください';

  @override
  String get subscribeNowButton => '今すぐ購読';

  @override
  String get restorePurchaseButton => '購入を復元';

  @override
  String get purchaseRestoredSuccessfully => '購入が正常に復元されました';

  @override
  String get purchaseRestoreFailedError => '購入の復元に失敗しました';

  @override
  String get storagePermissionRequired => 'ストレージ権限が必要です';

  @override
  String get storagePermissionMessageRequired => 'PDFを保存するためにストレージ権限が必要です';

  @override
  String get grantPermissionButton => '権限を付与';

  @override
  String get openSettingsButton => '設定を開く';

  @override
  String get permissionDeniedError => '権限が拒否されました';

  @override
  String get errorWhileCreatingPdf => 'PDF作成中にエラーが発生しました';

  @override
  String get errorWhileSavingPdf => 'PDF保存中にエラーが発生しました';

  @override
  String get errorWhileLoadingImages => '画像読み込み中にエラーが発生しました';

  @override
  String get pdfCreatedSuccessfully => 'PDFが正常に作成されました';

  @override
  String get pdfSavedSuccessfully => 'PDFが正常に保存されました';

  @override
  String get tryAgainButton => '再試行';

  @override
  String get continueButton => '続行';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get closeButton => '閉じる';

  @override
  String get savingInProgress => '保存中...';

  @override
  String get downloadingInProgress => 'ダウンロード中...';

  @override
  String get invalidFileTypeError => '無効なファイルタイプです';

  @override
  String get maxFileSizeExceeded => '最大ファイルサイズを超えています';

  @override
  String get maxImagesLimitReached => '最大画像数に達しました';

  @override
  String get trialLimitMessageReached => '試用制限に達しました。すべての機能を使うには購読してください。';

  @override
  String freeVersionLimitReached(Object Count, Object count) {
    return '無料版は$count件のPDFまで利用可能です';
  }

  @override
  String get imageQualityHighOption => '高画質（90％）';

  @override
  String get imageQualityMediumOption => '中画質（70％）';

  @override
  String get imageQualityLowOption => '低画質（50％）';

  @override
  String get orientationDefaultOption => 'デフォルトの向き';

  @override
  String get orientationPortraitOption => '縦向きに固定';

  @override
  String get orientationLandscapeOption => '横向きに固定';

  @override
  String get orientationMixedOption => '混合向き';

  @override
  String get unsupportedFileFormatError => 'サポートされていないファイル形式です';

  @override
  String get supportedFormatsMessage => '対応形式: JPG, PNG, HEIC';

  @override
  String get shareViaButton => '共有方法';

  @override
  String get sharePdfButton => 'PDFを共有';

  @override
  String get enjoyingAppMessage => 'iSpeedPix2PDFを楽しんでいますか？';

  @override
  String get rateAppStoreButton => 'App Storeで評価';

  @override
  String get ratePlayStoreButton => 'Play ストアで評価';

  @override
  String get sendFeedbackButton => 'フィードバックを送信';

  @override
  String get preparingImagesInProgress => '画像を準備中...';

  @override
  String get optimizingImagesInProgress => '画像を最適化中...';

  @override
  String get generatingPdfInProgress => 'PDFを生成中...';

  @override
  String get almostDoneMessage => 'もう少しで完了...';

  @override
  String get unlockFeatureButton => 'この機能をアンロック';

  @override
  String get premiumFeatureMessage => 'プレミアム機能';

  @override
  String get upgradeToUnlockMessage => 'すべての機能をアンロックするにはアップグレードしてください';

  @override
  String get weDoNotCollectAnyPersonalData =>
      '私たちはユーザーの個人データを収集、保存、処理しません。すべてのデータはデバイス内で処理されます。つまり';

  @override
  String get noImagesAreShared =>
      '画像はサーバーにアップロードされません。\n- 私たちのモバイルアプリは個人情報を収集、保存、共有しません。';

  @override
  String get filesSelected => 'ファイルが選択されました';

  @override
  String get rateThisApp => 'このアプリを評価';

  @override
  String get rateThisAppMessage =>
      'このアプリを気に入っていただけたら、レビューを残していただけると嬉しいです！フィードバックは改善の助けになり、1分もかかりません。';

  @override
  String get rate => '評価する';

  @override
  String get noThanks => 'いいえ、結構です';

  @override
  String get maybeLater => 'あとで';

  @override
  String get permissionRequired => '権限が必要です';

  @override
  String get freeTrialExpiredMessage => '無料トライアル終了または無料機能の利用制限に達しました';

  @override
  String get upgradeNowButton => '今すぐアップグレード';

  @override
  String get howToUse => '使い方';

  @override
  String get simplicityAndEfficiency => 'シンプルさと効率性';

  @override
  String get privacyAndSecurity => 'プライバシーとセキュリティ';

  @override
  String get moreAppsByTevinEighDesigns => 'Tevin Eigh Designs のその他のアプリ';

  @override
  String get aboutTevinEighDesigns => 'Tevin Eigh Designsについて';

  @override
  String get returnToConverter => 'コンバーターに戻る';

  @override
  String get currentPlanFullAccess => '現在のプラン: フルアクセス';

  @override
  String get currentPlanFreeTrial => '現在のプラン: 無料トライアル';

  @override
  String get freeTrialOneWeekUnlimitedUse => '無料トライアル – 3日間 – 無制限使用';

  @override
  String get freeVersionTrialAfterTrialExpires => '無料版 – トライアル終了後';

  @override
  String get createUpToFivePDFsEverySevenDays => '✔ 3日ごとに最大5件のPDFを作成\n';

  @override
  String get eachPDFCanHaveUpToThreePages => '✔ 各PDFは最大3ページまで\n';

  @override
  String get autoResetEverySevenDays => '✔ 3日ごとに自動リセット\n\n';

  @override
  String get oneTimePurchaseUnlockFullAccess => '一度の購入でフルアクセスをアンロック\n\n';

  @override
  String get adFreeAfterPurchase => '✔ 購入後は広告なし\n';

  @override
  String get unlimitedPDFCreation => '✔ 無制限のPDF作成\n';

  @override
  String get singlePurchaseLifetimeAccess => '✔ 一度の購入で生涯アクセス\n\n';

  @override
  String get upgradeTodayToUnlockCompletePotential =>
      '今すぐアップグレードして、生涯サブスクリプションでiSpeedPix2PDFの全機能をアンロック🚀';

  @override
  String get enjoyFullAccess => 'フルアクセスをお楽しみください';

  @override
  String get checkingActivePurchase => '購入状況を確認中';

  @override
  String get alreadyPurchasedRestoreHere => 'すでに購入済みですか？ここで復元';

  @override
  String get buyNowInFourNineNine => '今すぐ1.99で購入';

  @override
  String get success => '成功';

  @override
  String get yourPurchaseHasBeenSuccessfullyRestored => '購入が正常に復元されました！';

  @override
  String get purchaseHistory => '購入履歴';

  @override
  String get noPurchasesFound => '購入が見つかりません';

  @override
  String get weCouldNotFindAnyPreviousPurchasesToRestore =>
      '復元可能な以前の購入が見つかりませんでした。';

  @override
  String get purchaseDate => '購入日';

  @override
  String get purchaseAmount => '購入金額';

  @override
  String get purchaseStatus => '購入ステータス';

  @override
  String get purchaseId => '購入ID';

  @override
  String get purchaseDetails => '購入詳細';

  @override
  String get error => 'エラー';

  @override
  String get failedToRestorePurchasesPleaseTryAgainLater =>
      '購入の復元に失敗しました。後でもう一度試してください。';

  @override
  String get howToUseISpeedPix2PDFStepByStep => 'iSpeedPix2PDFの使い方：ステップバイステップ';

  @override
  String get howToUsePointOne =>
      '1. 画像を選択\n「ファイルを選択」ボタンをタップして写真ギャラリーを開きます。\nPDFに含めたい写真を選択できます。複数の画像を同時に選択可能です。\n\n2. ファイル名を追加（任意）\n「ファイル名」欄をタップしてPDFにカスタムファイル名を付けることができます。\nファイル名を入力しない場合は、iSpeedPix2PDF_DATE_TIME の形式で自動的に名前が付けられます。\n\n3. PDFを表示またはダウンロード\n- ダウンロードしてファイルを保存します（共有や管理がしやすいようにサイズは小さく設計されています）\n- アプリ内で直接PDFを表示してすばやく確認できます。\n\n4. PDFを共有\n- 保存後、メール、メッセージアプリ、クラウドサービスなど、端末の共有オプションを使ってPDFを共有可能です。\n- PDFが保存されると、すでに慣れているツールを使ってスキャンの管理、編集、共有が簡単に行え、書類処理がより速く効率的になります。\n\nこれで完了です！iSpeedPix2PDFでコンパクトで扱いやすいPDFを作成、表示、共有できました。';

  @override
  String get mainMenu => 'メインメニュー';

  @override
  String get simplicityAndPrivacyDetail =>
      '私たちの理念\n- シンプルさ：私たちのアプリは直感的でわかりやすく、誰でも簡単に使えるよう設計されています。\n\n- セキュリティ：すべての処理をクライアント側で行うため、お客様のデータは安全でプライベートに保たれます。\n- 効率性：無駄なステップを省きつつ、主要な機能は損なわず、常に改善を続けています。';

  @override
  String get simplicityAndPrivacyDetailTwo =>
      '必要なものだけを提供し、それ以上でもそれ以下でもありません。進化し続ける中で、アプリの目的を損なうことなく効率性を高めることにコミットしています。';

  @override
  String get simplicityAndPrivacyDetailThree =>
      'クライアント側アプリのラインナップをぜひご覧ください。シンプルさ、効率性、セキュリティが日々の作業にどれほどの違いをもたらすか体験してみてください。';

  @override
  String get privacyAndSecurityDetailTitle =>
      'iSpeedPix2PDFへようこそ。私たちはお客様のプライバシー保護と個人情報の安全を最優先に考えています。本プライバシーポリシーは、モバイルデバイス上でiSpeedPix2PDFを利用する際のデータ収集、使用、保護について説明します。';

  @override
  String get privacyAndSecurityDetailOne =>
      '1. 情報の収集と利用 - iSpeedPix2PDFはクライアント側アプリであり、アプリによるすべてのデータ処理は端末内で完結し、外部サーバーへ送信されません。\n- 写真ギャラリーへのアクセス：PDFに変換する画像を選択するために端末の写真ギャラリーへのアクセス権を必要とします。\n- PDF生成後はファイルを保存・保持しません。ユーザーはPDFの共有、メール送信、保存、アップロードを自由に行えます。';

  @override
  String get privacyAndSecurityDetailTwo =>
      '2. データ送信なし - クライアント側アプリとして、個人情報や生成されたPDFなどのいかなるデータも外部サーバーや第三者サービスへ送信しません。画像選択からPDF生成まで全て端末内で行われ、最高レベルのプライバシーとセキュリティを保証します。';

  @override
  String get privacyAndSecurityDetailThree =>
      '3. 一回限りの生涯サブスクリプション - iSpeedPix2PDFは一回限りの生涯サブスクリプションモデルで運営されており、すべての機能に一度の支払いでアクセス可能です。追加の料金や隠れた費用はありません。支払い処理は安全に行われ、購入後は追加支払いなしで完全に利用できます。';

  @override
  String get privacyAndSecurityDetailFour =>
      '4. 広告なし - 広告表示やデータ販売は行いません。iSpeedPix2PDFは広告に邪魔されずスムーズで効率的なユーザー体験を提供するために設計されています。PDF作成と共有が完全にユーザーのコントロール下で行えます。';

  @override
  String get view => '表示';

  @override
  String get aboutTevinEighDescription =>
      'Tevin Eigh Designsでは、シンプルで効率的かつ安全なクライアント側アプリの開発に特化しています。最小限のステップと操作で必要な機能を届けることに注力し、ユーザーが本来の作業に集中できる環境を提供します。\n\n私たちの理念\n- シンプルさ：誰でも簡単に使えるように直感的でわかりやすい設計。\n- セキュリティ：すべての処理をクライアント側で行い、データのプライバシーと安全を確保。\n- 効率性：不要なステップを排除しながらも、基本機能は損なわず継続的に改良。\n\n必要なものだけを提供することに信念を持ち、進化し続ける中でもアプリの主要目的を維持しつつ効率性を高めることにコミットしています。\n\n私たちのクライアント側アプリをぜひ体験し、シンプルさ、効率性、セキュリティが日常の作業にどれほどの違いをもたらすか感じてください。\n\nwww.tevineigh.com\n';

  @override
  String get language => '言語';

  @override
  String get chooseLanguage => '言語を選択';

  @override
  String get aboutAppDescription => '画像を素早く簡単にPDFに変換';

  @override
  String get settings => '設定';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get save => '保存';

  @override
  String get privacyAndSecurityDetailFive =>
      '5. プライバシーポリシー - 当社のアプリは、アプリストア最適化（ASO）および検索エンジン最適化（SEO）の目的のみで Google Firebase を使用しています。これらの情報を他の目的で収集、販売、使用することはありません。\n\nGoogle Firebase のデータ処理に関する詳細は、プライバシーポリシーをご参照ください：';

  @override
  String get monthlyUsageLimitReached => '月間利用制限に達しました';

  @override
  String get monthlyUsageLimitDescription =>
      '今月の無料利用時間（3分）をすでに使い切りました。利用時間は翌月初めにリセットされます。';

  @override
  String get unlockUnlimitedUsageWithSubscription =>
      '生涯サブスクリプションを一度購入すると、無制限の利用時間がアンロックされます。';

  @override
  String get laterButton => '後で';

  @override
  String remainingUsageTime(int minutes, int seconds) {
    return '残りの利用時間：$minutes分 $seconds秒';
  }

  @override
  String get threeMinutesUsagePerMonth => '✔ 月に3分の利用時間\n';

  @override
  String get usageTimeResetMonthly => '✔ 利用時間は毎月リセットされます\n\n';

  @override
  String get trialTimeLeft => '試用時間残り';

  @override
  String remainingTime(int minutes, String seconds) {
    return '残り$minutes:$seconds';
  }

  @override
  String get unlockUnlimitedAccessToday => '今日無制限アクセスを解除！';

  @override
  String get enjoyingFreeTrialUpgradeMessage =>
      '無料トライアルをお楽しみいただいています！なぜ待つのですか？今すぐライフタイムプランにアップグレードして、時間制限を気にする必要がなくなります。一回の支払い、永続的な無制限使用 — サブスクリプションなし、継続課金なし！';

  @override
  String get usagePausedThirtyDays => '使用一時停止（30日）';

  @override
  String get freeTimeExpired => '無料時間終了';

  @override
  String get almostOutOfFreeTime => '無料時間がほぼ終了';

  @override
  String usagePausedMessage(int days) {
    return '無料時間があと$days日間一時停止されています。ライフタイムプランにアップグレードして、すぐに無制限使用を取得 — 継続課金なし、サブスクリプションなし。';
  }

  @override
  String get freeTimeExpiredMessage =>
      '無料時間が終了しました！一回限りの支払いでライフタイムプランにアップグレード — 継続課金なし、サブスクリプションなし。永続的な無制限使用を取得。';

  @override
  String get almostOutOfFreeTimeMessage =>
      '今月の無料時間がほぼ終了です！一回限りの支払いでライフタイムプランにアップグレード — 継続課金なし、サブスクリプションなし。永続的な無制限使用を取得。';

  @override
  String get subscribeNow => '今すぐ購読';

  @override
  String get likingTheApp => 'アプリを気に入っていますか？';

  @override
  String get likingTheAppMessage =>
      'アプリを気に入っていますか？一回限りの支払いで今日ライフタイムアクセスを取得 — 継続課金なし、サブスクリプションなし。永続的な無制限使用を解除！';

  @override
  String get maybeLatr => '後で';

  @override
  String get getLifetimeAccess => 'ライフタイムアクセスを取得';

  @override
  String get stillEnjoyingIt => 'まだ楽しんでいますか？';

  @override
  String get stillEnjoyingItMessage =>
      'まだ楽しんでいますか？今すぐアップグレードして、ライフタイムプランで永続的なアクセスを維持 — 一回の支払い、サブスクリプションなし、生涯無制限使用！';

  @override
  String get notNow => '今はしない';

  @override
  String get upgradeForever => '永続的にアップグレード';

  @override
  String get almostOutOfFreeTimeTitle => '無料時間がほぼ終了';

  @override
  String get almostOutOfFreeTimeWarningMessage =>
      '今月の無料時間がほぼ終了です！一回限りの支払いでライフタイムプランにアップグレード — 継続課金なし、サブスクリプションなし。永続的な無制限使用を取得。';

  @override
  String get later => '後で';

  @override
  String get upgradeNow => '今すぐアップグレード';

  @override
  String get creatingPdfMessage => 'PDF作成中...';

  @override
  String get day => '日';

  @override
  String get days => '日';

  @override
  String get left => '残り';

  @override
  String get sessionTime => 'セッション時間';

  @override
  String get usePromoCode => 'プロモコードを使用';

  @override
  String get enterPromoCode => 'プロモコードを入力';

  @override
  String get apply => '適用';

  @override
  String get invalidPromoCode => '無効なプロモコード';

  @override
  String get promoCodeAppliedSuccessfully => 'プロモコードが正常に適用されました！';

  @override
  String get promoCode => 'プロモコード';
}
