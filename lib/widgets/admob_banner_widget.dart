import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobBannerWidget extends StatefulWidget {
  const AdMobBannerWidget({super.key});

  @override
  State<AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<AdMobBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // Ad Unit IDs
  static const String _androidBannerAdUnitId =
      'ca-app-pub-8212879270080474/1957188650';
  static const String _iosBannerAdUnitId =
      'ca-app-pub-8212879270080474/1957188650';

  // Test Ad Unit IDs for development
  static const String _testAndroidBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testIosBannerAdUnitId =
      'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  /// Get the appropriate ad unit ID based on platform and build mode
  String get _adUnitId {
    // Use test ads in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      return Platform.isAndroid
          ? _testAndroidBannerAdUnitId
          : _testIosBannerAdUnitId;
    }

    // Use real ads in production
    return Platform.isAndroid ? _androidBannerAdUnitId : _iosBannerAdUnitId;
  }

  /// Load the banner ad
  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ Banner ad loaded successfully');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('❌ Banner ad failed to load: $err');
          ad.dispose();
          setState(() {
            _isLoaded = false;
          });
        },
        onAdOpened: (ad) {
          debugPrint('📱 Banner ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('🔒 Banner ad closed');
        },
        onAdImpression: (ad) {
          debugPrint('👁️ Banner ad impression recorded');
        },
        onAdClicked: (ad) {
          debugPrint('👆 Banner ad clicked');
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show anything if ad is not loaded
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

/// Widget that shows banner ad only for non-subscribed users
class ConditionalAdMobBanner extends StatelessWidget {
  final bool isSubscribed;

  const ConditionalAdMobBanner({
    super.key,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show ads to subscribed users
    if (!isSubscribed) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        const AdMobBannerWidget(),
        const SizedBox(height: 8),
      ],
    );
  }
}
