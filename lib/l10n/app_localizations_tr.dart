// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get rest => 'Reset';

  @override
  String get appTitle => 'iSpeedPix2PDF';

  @override
  String get defaultMixedOrientation => 'Varsayılan - Karışık Yönlendirme';

  @override
  String get pagesFixedPortrait => 'Sayfalar Sabit - Dikey';

  @override
  String get landscapePhotosTopAlignedForEasyViewing =>
      'Yatay Fotoğraflar - Kolay Görüntüleme İçin Üst Hizalanmış';

  @override
  String get reset => 'Sıfırla';

  @override
  String get chooseFiles => 'Dosyaları Seç';

  @override
  String get noFilesSelected => 'Dosya Seçilmedi';

  @override
  String get youCanSelectUpTo3ImagesInFreeVersion =>
      '*Ücretsiz sürümde en fazla 3 resim seçebilirsiniz';

  @override
  String get youCanSelectUpTo60Images => '*En fazla 60 resim seçebilirsiniz';

  @override
  String get filename => 'Dosya Adı';

  @override
  String get filenameOptional => 'Dosya Adı (İsteğe Bağlı)';

  @override
  String get enterCustomFileNameOptional =>
      'Özel dosya adı girin (isteğe bağlı)';

  @override
  String get filenameCannotContainCharacters =>
      'Dosya adı aşağıdaki karakterleri içeremez: \\ / : * ? \" < > |';

  @override
  String get downloadPDF => 'PDF İndir';

  @override
  String get viewPdf => 'PDF Görüntüle';

  @override
  String get about => 'Hakkında';

  @override
  String get getFullLifetimeAccess =>
      '1,99 karşılığında Ömür Boyu Tam Erişim Al';

  @override
  String get viewPurchaseDetails => 'Satın Alma Detaylarını Görüntüle';

  @override
  String get dataCollection => 'Veri Toplama:';

  @override
  String get invalidFilename => 'Geçersiz Dosya Adı';

  @override
  String get freeFeatureRenewal =>
      'ÜCRETSİZ ÖZELLİKLER HER 3 GÜNDE BİR YENİLENİR';

  @override
  String get upgradePrompt =>
      'iSpeedPix2PDF\'nin TAM GÜCÜNÜ KİLİDİNİ AÇMAK İÇİN TEK SEFERLİK SATIN ALMA YAPIN 🚀.';

  @override
  String get ok => 'Tamam';

  @override
  String get rateAppTitle => 'Uygulamayı Değerlendir';

  @override
  String get rateAppMessage =>
      'Uygulamamızı kullanmaktan memnunsanız, bir dakikanızı ayırıp değerlendirme bırakmanızı çok isteriz! Geri bildiriminiz gelişmemize yardımcı olur ve sadece bir dakikanızı alır.';

  @override
  String get rateButton => 'DEĞERLENDİR';

  @override
  String get noThanksButton => 'HAYIR TEŞEKKÜR';

  @override
  String get maybeLaterButton => 'BELKİ SONRA';

  @override
  String get processing => 'İşleniyor';

  @override
  String get pleaseWait => 'Lütfen bekleyin';

  @override
  String get trialLimitReached => 'Deneme Sınırı Aşıldı';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get creatingPdf => 'PDF Oluşturuluyor';

  @override
  String get loadingImagesInProgress => 'Resimler Yükleniyor';

  @override
  String get subscriptionRequired => 'Abonelik Gerekiyor';

  @override
  String get subscriptionMessageRequired =>
      'Tüm özellikleri kullanmaya devam etmek için lütfen abone olun';

  @override
  String get subscribeNowButton => 'Şimdi Abone Ol';

  @override
  String get restorePurchaseButton => 'Satın Almayı Geri Yükle';

  @override
  String get purchaseRestoredSuccessfully =>
      'Satın Alma Başarıyla Geri Yüklendi';

  @override
  String get purchaseRestoreFailedError => 'Satın Alma Geri Yükleme Başarısız';

  @override
  String get storagePermissionRequired => 'Depolama İzni Gerekiyor';

  @override
  String get storagePermissionMessageRequired =>
      'PDF kaydetmek için depolama izni gereklidir';

  @override
  String get grantPermissionButton => 'İzin Ver';

  @override
  String get openSettingsButton => 'Ayarları Aç';

  @override
  String get permissionDeniedError => 'İzin Reddedildi';

  @override
  String get errorWhileCreatingPdf => 'PDF Oluşturma Hatası';

  @override
  String get errorWhileSavingPdf => 'PDF Kaydetme Hatası';

  @override
  String get errorWhileLoadingImages => 'Resim Yükleme Hatası';

  @override
  String get pdfCreatedSuccessfully => 'PDF Başarıyla Oluşturuldu';

  @override
  String get pdfSavedSuccessfully => 'PDF Başarıyla Kaydedildi';

  @override
  String get tryAgainButton => 'Tekrar Dene';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get cancelButton => 'İptal';

  @override
  String get closeButton => 'Kapat';

  @override
  String get savingInProgress => 'Kaydediliyor...';

  @override
  String get downloadingInProgress => 'İndiriliyor...';

  @override
  String get invalidFileTypeError => 'Geçersiz dosya türü';

  @override
  String get maxFileSizeExceeded => 'Maksimum dosya boyutu aşıldı';

  @override
  String get maxImagesLimitReached => 'Maksimum resim sayısına ulaşıldı';

  @override
  String get trialLimitMessageReached =>
      'Deneme sınırına ulaştınız. Tüm özellikleri kullanmaya devam etmek için lütfen abone olun.';

  @override
  String freeVersionLimitReached(Object Count, Object count) {
    return 'Ücretsiz sürüm $count PDF ile sınırlıdır';
  }

  @override
  String get imageQualityHighOption => 'Yüksek Kalite (%%90)';

  @override
  String get imageQualityMediumOption => 'Orta Kalite (%%70)';

  @override
  String get imageQualityLowOption => 'Düşük Kalite (%%50)';

  @override
  String get orientationDefaultOption => 'Varsayılan Yönlendirme';

  @override
  String get orientationPortraitOption => 'Dik Zorla';

  @override
  String get orientationLandscapeOption => 'Yatay Zorla';

  @override
  String get orientationMixedOption => 'Karışık Yönlendirme';

  @override
  String get unsupportedFileFormatError => 'Desteklenmeyen dosya formatı';

  @override
  String get supportedFormatsMessage => 'Desteklenen formatlar: JPG, PNG, HEIC';

  @override
  String get shareViaButton => 'Şununla paylaş';

  @override
  String get sharePdfButton => 'PDF Paylaş';

  @override
  String get enjoyingAppMessage => 'iSpeedPix2PDF\'den memnun musunuz?';

  @override
  String get rateAppStoreButton => 'App Store\'da Değerlendir';

  @override
  String get ratePlayStoreButton => 'Play Store\'da Değerlendir';

  @override
  String get sendFeedbackButton => 'Geri Bildirim Gönder';

  @override
  String get preparingImagesInProgress => 'Resimler Hazırlanıyor...';

  @override
  String get optimizingImagesInProgress => 'Resimler Optimize Ediliyor...';

  @override
  String get generatingPdfInProgress => 'PDF Oluşturuluyor...';

  @override
  String get almostDoneMessage => 'Neredeyse Hazır...';

  @override
  String get unlockFeatureButton => 'Bu Özelliğin Kilidini Aç';

  @override
  String get premiumFeatureMessage => 'Premium Özellik';

  @override
  String get upgradeToUnlockMessage =>
      'Tüm özelliklerin kilidini açmak için yükseltin';

  @override
  String get weDoNotCollectAnyPersonalData =>
      ' Kişisel verilerinizi toplamaz, saklamaz veya işlemez. Tüm veriler cihazınızda yerel olarak işlenir. Bu demek oluyor ki';

  @override
  String get noImagesAreShared =>
      'Hiçbir resim bir sunucuya yüklenmez.\n- Mobil uygulamamız tarafından kişisel veri toplanmaz, saklanmaz veya paylaşılmaz.';

  @override
  String get filesSelected => 'Seçilen Dosyalar';

  @override
  String get rateThisApp => 'Bu uygulamayı değerlendirin';

  @override
  String get rateThisAppMessage =>
      'Uygulamayı kullanmaktan keyif alıyorsanız, bir dakikanızı ayırıp bir değerlendirme bırakmanızı çok isteriz! Geri bildiriminiz gelişmemize yardımcı olur ve sadece bir dakikanızı alır.';

  @override
  String get rate => 'DEĞERLENDİR';

  @override
  String get noThanks => 'HAYIR TEŞEKKÜR';

  @override
  String get maybeLater => 'BELKİ SONRA';

  @override
  String get permissionRequired => 'İzin Gerekli';

  @override
  String get freeTrialExpiredMessage =>
      'ÜCRETSİZ DENEME SÜRESİ DOLDU veya ÜCRETSİZ ÖZELLİKLER TÜKENDİ';

  @override
  String get upgradeNowButton => 'Şimdi Yükselt';

  @override
  String get howToUse => 'Nasıl Kullanılır';

  @override
  String get simplicityAndEfficiency => 'Basitlik ve Verimlilik';

  @override
  String get privacyAndSecurity => 'Gizlilik ve Güvenlik';

  @override
  String get moreAppsByTevinEighDesigns =>
      'Tevin Eigh Designs\'dan Daha Fazla Uygulama';

  @override
  String get aboutTevinEighDesigns => 'Tevin Eigh Designs Hakkında';

  @override
  String get returnToConverter => 'Dönüştürücüye Dön';

  @override
  String get currentPlanFullAccess => 'Mevcut Plan: Tam Erişim';

  @override
  String get currentPlanFreeTrial => 'Mevcut Plan: Ücretsiz Deneme';

  @override
  String get freeTrialOneWeekUnlimitedUse =>
      'ÜCRETSİZ DENEME – 3 Gün – Sınırsız Kullanım';

  @override
  String get freeVersionTrialAfterTrialExpires =>
      'ÜCRETSİZ SÜRÜM – Deneme Süresi Sonrası';

  @override
  String get createUpToFivePDFsEverySevenDays =>
      '✔ Her 3 günde 5 PDF oluşturabilirsiniz\n';

  @override
  String get eachPDFCanHaveUpToThreePages =>
      '✔ Her PDF en fazla 3 sayfa içerebilir\n';

  @override
  String get autoResetEverySevenDays => '✔ Her 3 günde otomatik sıfırlama\n\n';

  @override
  String get oneTimePurchaseUnlockFullAccess =>
      'Tek Seferlik Satın Alma (Tam Erişimi Açar)\n\n';

  @override
  String get adFreeAfterPurchase => '✔ Satın alma sonrası reklamsız\n';

  @override
  String get unlimitedPDFCreation => '✔ Sınırsız PDF oluşturma\n';

  @override
  String get singlePurchaseLifetimeAccess =>
      '✔ Ömür boyu erişim için tek satın alma\n\n';

  @override
  String get upgradeTodayToUnlockCompletePotential =>
      'Bugün yükseltin ve iSpeedPix2Pdf\'nin tüm potansiyelinin kilidini açın 🚀';

  @override
  String get enjoyFullAccess => 'Tam Erişimin Tadını Çıkarın';

  @override
  String get checkingActivePurchase => 'Aktif Satın Alma Kontrol Ediliyor';

  @override
  String get alreadyPurchasedRestoreHere =>
      'Zaten satın aldıysanız buradan geri yükleyin';

  @override
  String get buyNowInFourNineNine => 'Şimdi 1,99\'a Satın Al';

  @override
  String get success => 'Başarılı';

  @override
  String get yourPurchaseHasBeenSuccessfullyRestored =>
      'Satın alma başarıyla geri yüklendi!';

  @override
  String get purchaseHistory => 'Satın Alma Geçmişi';

  @override
  String get noPurchasesFound => 'Satın alma bulunamadı';

  @override
  String get weCouldNotFindAnyPreviousPurchasesToRestore =>
      'Geri yüklemek için önceki bir satın alma bulunamadı.';

  @override
  String get purchaseDate => 'Satın Alma Tarihi';

  @override
  String get purchaseAmount => 'Satın Alma Tutarı';

  @override
  String get purchaseStatus => 'Satın Alma Durumu';

  @override
  String get purchaseId => 'Satın Alma Kimliği';

  @override
  String get purchaseDetails => 'Satın Alma Detayları';

  @override
  String get error => 'Hata';

  @override
  String get failedToRestorePurchasesPleaseTryAgainLater =>
      'Satın almalar geri yüklenemedi. Lütfen daha sonra tekrar deneyin.';

  @override
  String get howToUseISpeedPix2PDFStepByStep =>
      'iSpeedPix2PDF Nasıl Kullanılır: Adım Adım';

  @override
  String get howToUsePointOne =>
      '1. Resim Seçin\n\n\'\'Dosyaları Seç\'\' düğmesine dokunarak fotoğraf galeriniz açılır\n- PDF\'ye eklemek istediğiniz fotoğrafları seçin. Birden fazla resmi aynı anda seçebilirsiniz.\n\n2. Dosya Adı Ekleyin (İsteğe Bağlı)\n\n- PDF\'nize özel bir dosya adı vermek için \'\'Dosya Adı\'\' alanına dokunun\n- İsim girmezseniz, uygulama otomatik olarak iSpeedPix2PDF_TARİH_SAAT formatında bir isim atar\n\n3. PDF\'yi Görüntüleyin veya İndirin\n\n- Dosyayı kaydetmek için indirin (Dosya, paylaşımı ve yönetimi kolay küçük boyutludur)\n- Hızlı bakış için uygulama içinde doğrudan görüntüleyin\n\n4. PDF\'yi Paylaşın\n\n- Kaydettikten sonra PDF\'yi e-posta, mesajlaşma uygulamaları, bulut servisleri veya cihazınızdaki diğer paylaşım seçenekleriyle paylaşabilirsiniz\n- Kaydedilen PDF\'lerle taramalarınızı kolayca yönetebilir, düzenleyebilir ve paylaşabilirsiniz\n\nHepsi bu kadar! iSpeedPix2PDF ile hızlı, yönetimi kolay bir PDF oluşturdunuz, görüntülediniz ve paylaştınız.';

  @override
  String get mainMenu => 'Ana Menü';

  @override
  String get simplicityAndPrivacyDetail =>
      'Felsefemiz\n- Basitlik: Uygulamalarımız, herkesin kolayca kullanabilmesi için sezgisel ve basit olacak şekilde tasarlanmıştır.\n\n- Güvenlik: Tüm işlemler cihazınızda gerçekleştiği için verileriniz gizli ve güvende kalır.\n- Verimlilik: Gereksiz adımları ortadan kaldırarak uygulamalarımızı sürekli geliştiriyoruz.\n';

  @override
  String get simplicityAndPrivacyDetailTwo =>
      'İhtiyacınız olanı, fazlası değil, tam olarak sunmaya inanıyoruz. Geliştikçe, uygulamalarımızın temel amacından ödün vermeden verimliliği artırmaya devam edeceğiz.';

  @override
  String get simplicityAndPrivacyDetailThree =>
      'Müşteri tarafı uygulamalarımızı keşfedin ve basitlik, verimlilik ve güvenliğin günlük işlerinizde nasıl fark yarattığını deneyimleyin.';

  @override
  String get privacyAndSecurityDetailTitle =>
      'iSpeedPix2PDF\'ye Hoş Geldiniz. Gizliliğinizi korumaya ve kişisel bilgilerinizin güvenliğini sağlamaya kararlıyız. Bu Gizlilik Politikası, iSpeedPix2PDF uygulamasını kullanırken verilerinizin nasıl toplandığını, kullanıldığını ve korunduğunu açıklar.';

  @override
  String get privacyAndSecurityDetailOne =>
      '1. Bilgi Toplama ve Kullanımı - iSpeedPix2PDF, tüm verilerin cihazınızda işlenmesini sağlayan müşteri tarafı bir uygulamadır. Veriler dış sunuculara gönderilmez.\n- Fotoğraf Galerisi Erişimi: PDF\'ye dönüştürmek için resim seçmenize izin vermek amacıyla cihazınızın fotoğraf galerisine erişim gerektirir.\n- PDF oluşturulduktan sonra, uygulama dosyaları saklamaz veya tutmaz. Kullanıcılar PDF\'lerini paylaşabilir, e-posta ile gönderebilir, kaydedebilir veya istedikleri şekilde yükleyebilir.';

  @override
  String get privacyAndSecurityDetailTwo =>
      '2. Veri İletimi Yok - Müşteri tarafı uygulaması olarak iSpeedPix2PDF, verilerinizin dış sunuculara veya üçüncü taraf hizmetlere gönderilmemesini garanti eder. İşlemin her adımı cihazınızda gerçekleşir, bu da en yüksek gizlilik ve güvenlik seviyesini sağlar.';

  @override
  String get privacyAndSecurityDetailThree =>
      '3. Tek Seferlik Ömür Boyu Abonelik - iSpeedPix2PDF, tüm özelliklere tam erişim için sadece bir kere ödeme yapmanız gereken tek seferlik ömür boyu abonelik modeliyle çalışır. Ödeme işlemleri güvenli bir hizmet aracılığıyla yapılır. Satın alma tamamlandıktan sonra, uygulama ek ödeme gerektirmeden tamamen işlevsel kalır.';

  @override
  String get privacyAndSecurityDetailFour =>
      '4. Reklam Yok - Reklam göstermez veya verilerinizi satmaz. iSpeedPix2PDF, kesintisiz, basit ve güvenli bir PDF oluşturma ve paylaşma deneyimi sunmak için tasarlanmıştır.';

  @override
  String get view => 'Görüntüle';

  @override
  String get aboutTevinEighDescription =>
      'Tevin Eigh Designs olarak, günlük sorunlara basitlik, verimlilik ve güvenlikle çözüm sunan müşteri tarafı uygulamalar geliştiriyoruz. Amacımız, en az adım ve tıklama ile temel işlevselliği sunarak kullanıcıların esas görevlerine odaklanmasını sağlamaktır.\n\nFelsefemiz\n- Basitlik: Uygulamalarımız herkesin kolayca kullanabileceği şekilde sezgisel ve basittir.\n- Güvenlik: Tüm işlemler cihazınızda gerçekleşir, böylece verileriniz gizli ve güvende kalır.\n- Verimlilik: Temel işlevselliği korurken gereksiz adımları ortadan kaldırmak için sürekli çalışıyoruz.\n\nİhtiyacınız olanı, fazlası değil, tam olarak sunmaya inanıyoruz. Geliştikçe, uygulamalarımızın temel amacından ödün vermeden verimliliği artırmaya devam edeceğiz.\n\nMüşteri tarafı uygulamalarımızı keşfedin ve basitlik, verimlilik ve güvenliğin günlük işlerinizde nasıl fark yarattığını deneyimleyin.\n\nwww.tevineigh.com\n';

  @override
  String get language => 'Dil';

  @override
  String get chooseLanguage => 'Dil Seçin';

  @override
  String get aboutAppDescription =>
      'Resimleri hızlı ve kolayca PDF\'ye dönüştürün';

  @override
  String get settings => 'Ayarlar';

  @override
  String get selectLanguage => 'Dil Seç';

  @override
  String get save => 'Kaydet';

  @override
  String get privacyAndSecurityDetailFive =>
      '5. Gizlilik Politikası - Uygulamalarımız, yalnızca Uygulama Mağazası Optimizasyonu (ASO) ve Arama Motoru Optimizasyonu (SEO) amaçlarıyla Google Firebase kullanır. Bu bilgileri başka herhangi bir amaçla toplamaz, satmaz veya kullanmayız.\n\nGoogle Firebase’in veri uygulamaları hakkında daha fazla bilgi için lütfen Gizlilik Politikalarına başvurun:';

  @override
  String get monthlyUsageLimitReached => 'Aylık Kullanım Sınırına Ulaşıldı';

  @override
  String get monthlyUsageLimitDescription =>
      'Bu ay için 3 dakikalık ücretsiz kullanım sürenizi tükettiniz. Kullanım süreniz önümüzdeki ayın başında sıfırlanacaktır.';

  @override
  String get unlockUnlimitedUsageWithSubscription =>
      'Ömür boyu abonelik satın alarak sınırsız kullanım süresinin kilidini açın.';

  @override
  String get laterButton => 'Daha sonra';

  @override
  String remainingUsageTime(int minutes, int seconds) {
    return 'Kalan kullanım süresi: $minutes dk $seconds sn';
  }

  @override
  String get threeMinutesUsagePerMonth => '✔ Aylık 3 dakika kullanım süresi\n';

  @override
  String get usageTimeResetMonthly => '✔ Kullanım süresi her ay sıfırlanır\n\n';

  @override
  String get trialTimeLeft => 'Kalan Deneme Süresi';

  @override
  String remainingTime(int minutes, String seconds) {
    return '$minutes:$seconds kaldı';
  }

  @override
  String get unlockUnlimitedAccessToday => 'Bugün Sınırsız Erişimi Açın!';

  @override
  String get enjoyingFreeTrialUpgradeMessage =>
      'Ücretsiz deneme sürümünün keyfini çıkarıyorsunuz! Neden bekleyelim? Şimdi yaşam boyu planımıza yükseltin ve zaman sınırları konusunda bir daha endişelenmeyin. Tek ödeme, sonsuza kadar sınırsız kullanım — abonelik yok, tekrarlayan ücret yok!';

  @override
  String get usagePausedThirtyDays => 'Kullanım Duraklatıldı (30 Gün)';

  @override
  String get freeTimeExpired => 'Ücretsiz Süre Doldu';

  @override
  String get almostOutOfFreeTime => 'Ücretsiz Süre Neredeyse Bitti';

  @override
  String usagePausedMessage(int days) {
    return 'Ücretsiz süreniz $days gün daha duraklatıldı. Hemen sınırsız kullanım elde etmek için yaşam boyu planımıza yükseltin — tekrarlayan ücret yok, abonelik yok.';
  }

  @override
  String get freeTimeExpiredMessage =>
      'Ücretsiz süreniz doldu! Tek seferlik ödeme ile yaşam boyu planımıza yükseltin — tekrarlayan ücret yok, abonelik yok. Sonsuza kadar sınırsız kullanım elde edin.';

  @override
  String get almostOutOfFreeTimeMessage =>
      'Bu ay ücretsiz süreniz neredeyse bitiyor! Tek seferlik ödeme ile yaşam boyu planımıza yükseltin — tekrarlayan ücret yok, abonelik yok. Sonsuza kadar sınırsız kullanım elde edin.';

  @override
  String get subscribeNow => 'Şimdi Abone Ol';

  @override
  String get likingTheApp => 'Uygulamayı Beğeniyor musunuz?';

  @override
  String get likingTheAppMessage =>
      'Uygulamayı beğeniyor musunuz? Tek seferlik ödeme ile bugün yaşam boyu erişim elde edin — tekrarlayan ücret yok, abonelik yok. Sonsuza kadar sınırsız kullanımı açın!';

  @override
  String get maybeLatr => 'Belki Sonra';

  @override
  String get getLifetimeAccess => 'Yaşam Boyu Erişim Al';

  @override
  String get stillEnjoyingIt => 'Hala Beğeniyor musunuz?';

  @override
  String get stillEnjoyingItMessage =>
      'Hala beğeniyor musunuz? Şimdi yükseltin ve yaşam boyu planımızla sonsuza kadar erişimi koruyun — tek ödeme, abonelik yok, yaşam boyu sınırsız kullanım!';

  @override
  String get notNow => 'Şimdi Değil';

  @override
  String get upgradeForever => 'Sonsuza Kadar Yükselt';

  @override
  String get almostOutOfFreeTimeTitle => 'Ücretsiz Süre Neredeyse Bitti';

  @override
  String get almostOutOfFreeTimeWarningMessage =>
      'Bu ay ücretsiz süreniz neredeyse bitiyor! Tek seferlik ödeme ile yaşam boyu planımıza yükseltin — tekrarlayan ücret yok, abonelik yok. Sonsuza kadar sınırsız kullanım elde edin.';

  @override
  String get later => 'Sonra';

  @override
  String get upgradeNow => 'Şimdi Yükselt';

  @override
  String get creatingPdfMessage => 'PDF Oluşturuluyor...';

  @override
  String get day => 'gün';

  @override
  String get days => 'gün';

  @override
  String get left => 'kaldı';

  @override
  String get sessionTime => 'oturum süresi';

  @override
  String get usePromoCode => 'Promosyon Kodu Kullan';

  @override
  String get enterPromoCode => 'Promosyon Kodu Girin';

  @override
  String get apply => 'Uygula';

  @override
  String get invalidPromoCode => 'Geçersiz Promosyon Kodu';

  @override
  String get promoCodeAppliedSuccessfully =>
      'Promosyon Kodu Başarıyla Uygulandı!';

  @override
  String get promoCode => 'Promosyon Kodu';
}
